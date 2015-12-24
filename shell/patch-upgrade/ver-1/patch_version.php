<?php

include 'app/Mage.php';
echo "version-" . str_replace(".","", Mage::getVersion());
