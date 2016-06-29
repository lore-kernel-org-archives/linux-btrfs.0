Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zne1-mx-out05.web4pro.fr ([185.49.20.68]:38115 "EHLO
	zne1-mta-edge-out-01.w4p.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776AbcF2QQO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 12:16:14 -0400
Received: from zne1-mta-hub-out-web-02.w4p.fr (zne1-assp-hub-out-01a.w4p.fr [10.101.17.101])
	by zne1-mta-edge-out-01.w4p.fr (Postfix) with ESMTP id 9B1DD203C8
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 18:16:06 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zne1-mta-hub-out-web-02.w4p.fr (Postfix) with ESMTP id 342C7140E25
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 18:11:48 +0200 (CEST)
Received: from zne1-mta-hub-out-web-02.w4p.fr ([127.0.0.1])
	by localhost (zne1-mta-hub-out-web-02.w4p.fr [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id gq3bdySh-1Fm for <linux-btrfs@vger.kernel.org>;
	Wed, 29 Jun 2016 18:11:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zne1-mta-hub-out-web-02.w4p.fr (Postfix) with ESMTP id 15BF1140E42
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 18:11:47 +0200 (CEST)
Received: from zne1-mta-hub-out-web-02.w4p.fr ([127.0.0.1])
	by localhost (zne1-mta-hub-out-web-02.w4p.fr [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id dQ_0DX8l9QTT for <linux-btrfs@vger.kernel.org>;
	Wed, 29 Jun 2016 18:11:46 +0200 (CEST)
Received: from zne1-store-mbox-02a.w4p.fr (zne1-store-mbox-02a.w4p.fr [10.101.17.42])
	by zne1-mta-hub-out-web-02.w4p.fr (Postfix) with ESMTP id EB37D140E25
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 18:11:46 +0200 (CEST)
Date: Wed, 29 Jun 2016 18:15:53 +0200 (CEST)
From: Benoit GEORGELIN - Association Web4all
	<benoit.georgelin@web4all.fr>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1981850459.302621.1467216953768.JavaMail.zimbra@web4all.fr>
In-Reply-To: <1872105242.302575.1467216517408.JavaMail.zimbra@web4all.fr>
References: <1872105242.302575.1467216517408.JavaMail.zimbra@web4all.fr>
Subject: Disk quota exceeded
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi dear users of the list. 

I'm new to the BTRFS file-system and I am having some problems with quotas 
I would like to share with you what I'm facing about "Disk quota exceeded" it's quite strange to me. 

- Description of the environment 
I have a BTRFS volume "/var/lib/lxd" 
I have some subvolume into "/var/lib/lxd/containers" 

The volume have quota enable 
Every subvolume have their quota groupe created 
Limit of 10Go has been set to every single subvolumes 

-The problem 
Randomly I can't write to some of the subvolumes anymore without having datas added into the subvolume. 
I can't figure why and the subvolumes are randomly not usable with the error : Disk quota exceeded 

I did delete all the quota groups, disable quota on the volume, enable the quota group again on the volume, check if quota groups were back automatically as btrfs version 4 is supposed to do 
I added back the limit 10Go 
Rescan 
Everything work just fine but some time after, I'm back to over-quota on some subvolumes. 

Thanks for your help on this. 

Below, more details about the config and system point of view : 


uname -a 
Linux lxd-virt-01b 4.2.0-30-generic #36-Ubuntu SMP Fri Feb 26 00:58:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux 


btrfs --version 
btrfs-progs v4.4 

btrfs fi show 
Label: none uuid: b0b183ed-9970-4e54-b7d5-7b91f3bdea10 
Total devices 2 FS bytes used 21.01GiB 
devid 1 size 50.00GiB used 13.02GiB path /dev/sdb 
devid 2 size 50.00GiB used 13.01GiB path /dev/sdc 

btrfs fi df /var/lib/lxd 
Data, RAID0: total=22.00GiB, used=20.36GiB 
System, RAID1: total=8.00MiB, used=16.00KiB 
System, single: total=4.00MiB, used=0.00B 
Metadata, RAID1: total=2.00GiB, used=660.97MiB 
Metadata, single: total=8.00MiB, used=0.00B 
GlobalReserve, single: total=224.00MiB, used=0.00B 

# Simple script that check the content of /var/lib/lxd/containers were subvolumes stands 
# Try to touch a file into subvolume_name/rootfs/ 
./check_quotas_rw.sh 
Fichier écrit sur /var/lib/lxd/containers/angristan/rootfs/tmp/test 
touch: cannot touch ‘/var/lib/lxd/containers/ben/rootfs/tmp/test’: Disk quota exceeded 
Erreur de quota 
Fichier écrit sur /var/lib/lxd/containers/benltsp/rootfs/tmp/test 
touch: cannot touch ‘/var/lib/lxd/containers/debsid/rootfs/tmp/test’: Disk quota exceeded 
Erreur de quota 
Fichier écrit sur /var/lib/lxd/containers/dworak-vps/rootfs/tmp/test 
Fichier écrit sur /var/lib/lxd/containers/heimdaall/rootfs/tmp/test 
Fichier écrit sur /var/lib/lxd/containers/louisjo/rootfs/tmp/test 
touch: cannot touch ‘/var/lib/lxd/containers/onclben/rootfs/tmp/test’: Disk quota exceeded 
Erreur de quota 
touch: cannot touch ‘/var/lib/lxd/containers/testdisk/rootfs/tmp/test’: Disk quota exceeded 
Erreur de quota 
Fichier écrit sur /var/lib/lxd/containers/tyrower/rootfs/tmp/test 
touch: cannot touch ‘/var/lib/lxd/containers/vega/rootfs/tmp/test’: Disk quota exceeded 
Erreur de quota 

# Script to check group id so you can correlate 
/btrfsQuota.py --unit M /var/lib/lxd 
subvol group total unshared 
------------------------------------------------------------------------------- 
(unknown) 0/5 649.89M 649.89M 
containers/ben 0/261 1297.45M 1297.45M 
images/0d07f11f3f2a0804f501967d278d72a8122b1ec49f01aae4483a41fd9fb546f3.btrfs 0/264 315.33M 315.33M 
containers/vega 0/336 3211.92M 3211.92M 
containers/onclben 0/391 384.45M 384.45M 
images/61ba8f528725bda896eb6ca007f29f2d90a3f375379292e6a31eb851eb33e5ab.btrfs 0/423 563.02M 563.02M 
containers/heimdaall 0/428 1936.61M 1653.59M 
containers/tyrower 0/429 384.33M 101.31M 
containers/angristan 0/435 1132.71M 846.59M 
containers/dworak-vps 0/437 384.74M 98.62M 
containers/louisjo 0/442 663.09M 377.49M 
containers/benltsp 0/443 9209.45M 8933.05M 
images/f452cda3bccb2903e56d53e402b9d35334b4276783d098a879be5d74b04e62e2.btrfs 0/448 631.32M 631.32M 
containers/testdisk 0/449 383.99M 383.99M 
containers/debsid 0/453 428.52M 428.52M 
images/96a08bb9c674e092fe99dd2f96d61f8f0a2a1ea80eb01d384274c1ff8efefce1.btrfs 0/457 328.57M 328.57M 
images/fca47fbd0bb34bd38fdbd67bcc90a00eb8f0420b29a048ff59125d5fc983016c.btrfs 0/458 315.15M 315.15M 
images/c61ac213e75fb99e40d5ac49157314f002db257f38a692fc98c8d4be867f18a6.btrfs 0/463 367.45M 367.45M 


btrfs qg show -r -e /var/lib/lxd -p -c 
qgroupid rfer excl max_rfer max_excl parent child 
-------- ---- ---- -------- -------- ------ ----- 
0/5 649.89MiB 649.89MiB none none --- --- 
0/261 1.27GiB 1.27GiB 10.00GiB none --- --- 
0/264 315.33MiB 315.33MiB none none --- --- 
0/336 3.14GiB 3.14GiB 10.00GiB none --- --- 
0/391 384.45MiB 384.45MiB 10.00GiB none --- --- 
0/423 563.02MiB 563.02MiB none none --- --- 
0/428 1.89GiB 1.61GiB 10.00GiB none --- --- 
0/429 384.33MiB 101.31MiB 10.00GiB none --- --- 
0/435 1.11GiB 846.59MiB 10.00GiB none --- --- 
0/437 384.74MiB 98.62MiB 10.00GiB none --- --- 
0/442 663.09MiB 377.49MiB 10.00GiB none --- --- 
0/443 8.99GiB 8.72GiB 10.00GiB none --- --- 
0/448 631.32MiB 631.32MiB none none --- --- 
0/449 383.99MiB 383.99MiB 10.00GiB none --- --- 
0/453 428.52MiB 428.52MiB 10.00GiB none --- --- 
0/457 328.57MiB 328.57MiB none none --- --- 
0/458 315.15MiB 315.15MiB none none --- --- 
0/463 367.45MiB 367.45MiB none none --- --- 


dmesg |grep -i btrfs 
[ 2.712185] Btrfs loaded 
[ 2.902305] BTRFS: device fsid b0b183ed-9970-4e54-b7d5-7b91f3bdea10 devid 2 transid 113894 /dev/sdc 
[ 2.903883] BTRFS: device fsid b0b183ed-9970-4e54-b7d5-7b91f3bdea10 devid 1 transid 113894 /dev/sdb 
[ 6.201318] BTRFS info (device sdb): disk space caching is enabled 
[ 6.201321] BTRFS: has skinny extents 
[ 39.732758] BTRFS info (device sdb): qgroup scan completed (inconsistency flag cleared) 
[ 540.722625] BTRFS info (device sdb): qgroup scan completed (inconsistency flag cleared) 
[ 1247.758789] BTRFS info (device sdb): qgroup_rescan_init failed with -115 
[ 1265.879801] BTRFS info (device sdb): qgroup_rescan_init failed with -115 
[ 1289.854705] BTRFS info (device sdb): qgroup scan completed (inconsistency flag cleared) 
[ 1403.138613] BTRFS info (device sdb): qgroup scan completed (inconsistency flag cleared) 
[ 1564.685350] BTRFS info (device sdb): qgroup scan completed (inconsistency flag cleared) 
[ 1616.389847] BTRFS info (device sdb): The free space cache file (23651680256) is invalid. skip it 
[ 1765.145922] BTRFS info (device sdb): qgroup scan completed (inconsistency flag cleared) 
[36615.633743] BTRFS info (device sdb): qgroup scan completed (inconsistency flag cleared)

Cordialement, 

Benoît Georgelin - Expert Infrastructure 
Web 4 all Hébergeur associatif 
benoit.georgelin@web 4 all.fr 

Afin de contribuer au respect de l'environnement, merci de n'imprimer ce mail qu'en cas de nécessité

----- Mail original -----
De: "Benoit GEORGELIN - Association Web4all" <benoit.georgelin@web4all.fr>
À: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Envoyé: Mercredi 29 Juin 2016 12:08:37
Objet: Disk quota exceeded


I'm new to the BTRFS file-system and I am having some problems with quotas 
I would like to share with you what I'm facing about "Disk quota exceeded" it's quite strange to me. 

- Description of the environment 
I have a BTRFS volume "/var/lib/lxd" 
I have some subvolume into "/var/lib/lxd/containers" 

The volume have quota enable 
Every subvolume have their quota groupe created 
Limit of 10Go has been set to every single subvolumes 

-The problem 
Randomly I can't write to some of the subvolumes anymore without having datas added into the subvolume. 
I can't figure why and the subvolumes are randomly not usable with the error : Disk quota exceeded 

I did delete all the quota groups, disable quota on the volume, enable the quota group again on the volume, check if quota groups were back automatically as btrfs version 4 is supposed to do 
I added back the limit 10Go 
Rescan 
Everything work just fine but some time after, I'm back to over-quota on some subvolumes. 

Thanks for your help on this. 

Below, more details about the config and system point of view : 


uname -a 
Linux lxd-virt-01b 4.2.0-30-generic #36-Ubuntu SMP Fri Feb 26 00:58:07 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux 


btrfs --version 
btrfs-progs v4.4 

btrfs fi show 
Label: none uuid: b0b183ed-9970-4e54-b7d5-7b91f3bdea10 
Total devices 2 FS bytes used 21.01GiB 
devid 1 size 50.00GiB used 13.02GiB path /dev/sdb 
devid 2 size 50.00GiB used 13.01GiB path /dev/sdc 

btrfs fi df /var/lib/lxd 
Data, RAID0: total=22.00GiB, used=20.36GiB 
System, RAID1: total=8.00MiB, used=16.00KiB 
System, single: total=4.00MiB, used=0.00B 
Metadata, RAID1: total=2.00GiB, used=660.97MiB 
Metadata, single: total=8.00MiB, used=0.00B 
GlobalReserve, single: total=224.00MiB, used=0.00B 

# Simple script that check the content of /var/lib/lxd/containers were subvolumes stands 
# Try to touch a file into subvolume_name/rootfs/ 
./check_quotas_rw.sh 
Fichier écrit sur /var/lib/lxd/containers/angristan/rootfs/tmp/test 
touch: cannot touch ‘/var/lib/lxd/containers/ben/rootfs/tmp/test’: Disk quota exceeded 
Erreur de quota 
Fichier écrit sur /var/lib/lxd/containers/benltsp/rootfs/tmp/test 
touch: cannot touch ‘/var/lib/lxd/containers/debsid/rootfs/tmp/test’: Disk quota exceeded 
Erreur de quota 
Fichier écrit sur /var/lib/lxd/containers/dworak-vps/rootfs/tmp/test 
Fichier écrit sur /var/lib/lxd/containers/heimdaall/rootfs/tmp/test 
Fichier écrit sur /var/lib/lxd/containers/louisjo/rootfs/tmp/test 
touch: cannot touch ‘/var/lib/lxd/containers/onclben/rootfs/tmp/test’: Disk quota exceeded 
Erreur de quota 
touch: cannot touch ‘/var/lib/lxd/containers/testdisk/rootfs/tmp/test’: Disk quota exceeded 
Erreur de quota 
Fichier écrit sur /var/lib/lxd/containers/tyrower/rootfs/tmp/test 
touch: cannot touch ‘/var/lib/lxd/containers/vega/rootfs/tmp/test’: Disk quota exceeded 
Erreur de quota 

# Script to check group id so you can correlate 
/btrfsQuota.py --unit M /var/lib/lxd 
subvol group total unshared 
------------------------------------------------------------------------------- 
(unknown) 0/5 649.89M 649.89M 
containers/ben 0/261 1297.45M 1297.45M 
images/0d07f11f3f2a0804f501967d278d72a8122b1ec49f01aae4483a41fd9fb546f3.btrfs 0/264 315.33M 315.33M 
containers/vega 0/336 3211.92M 3211.92M 
containers/onclben 0/391 384.45M 384.45M 
images/61ba8f528725bda896eb6ca007f29f2d90a3f375379292e6a31eb851eb33e5ab.btrfs 0/423 563.02M 563.02M 
containers/heimdaall 0/428 1936.61M 1653.59M 
containers/tyrower 0/429 384.33M 101.31M 
containers/angristan 0/435 1132.71M 846.59M 
containers/dworak-vps 0/437 384.74M 98.62M 
containers/louisjo 0/442 663.09M 377.49M 
containers/benltsp 0/443 9209.45M 8933.05M 
images/f452cda3bccb2903e56d53e402b9d35334b4276783d098a879be5d74b04e62e2.btrfs 0/448 631.32M 631.32M 
containers/testdisk 0/449 383.99M 383.99M 
containers/debsid 0/453 428.52M 428.52M 
images/96a08bb9c674e092fe99dd2f96d61f8f0a2a1ea80eb01d384274c1ff8efefce1.btrfs 0/457 328.57M 328.57M 
images/fca47fbd0bb34bd38fdbd67bcc90a00eb8f0420b29a048ff59125d5fc983016c.btrfs 0/458 315.15M 315.15M 
images/c61ac213e75fb99e40d5ac49157314f002db257f38a692fc98c8d4be867f18a6.btrfs 0/463 367.45M 367.45M 


btrfs qg show -r -e /var/lib/lxd -p -c 
qgroupid rfer excl max_rfer max_excl parent child 
-------- ---- ---- -------- -------- ------ ----- 
0/5 649.89MiB 649.89MiB none none --- --- 
0/261 1.27GiB 1.27GiB 10.00GiB none --- --- 
0/264 315.33MiB 315.33MiB none none --- --- 
0/336 3.14GiB 3.14GiB 10.00GiB none --- --- 
0/391 384.45MiB 384.45MiB 10.00GiB none --- --- 
0/423 563.02MiB 563.02MiB none none --- --- 
0/428 1.89GiB 1.61GiB 10.00GiB none --- --- 
0/429 384.33MiB 101.31MiB 10.00GiB none --- --- 
0/435 1.11GiB 846.59MiB 10.00GiB none --- --- 
0/437 384.74MiB 98.62MiB 10.00GiB none --- --- 
0/442 663.09MiB 377.49MiB 10.00GiB none --- --- 
0/443 8.99GiB 8.72GiB 10.00GiB none --- --- 
0/448 631.32MiB 631.32MiB none none --- --- 
0/449 383.99MiB 383.99MiB 10.00GiB none --- --- 
0/453 428.52MiB 428.52MiB 10.00GiB none --- --- 
0/457 328.57MiB 328.57MiB none none --- --- 
0/458 315.15MiB 315.15MiB none none --- --- 
0/463 367.45MiB 367.45MiB none none --- --- 


dmesg |grep -i btrfs 
[ 2.712185] Btrfs loaded 
[ 2.902305] BTRFS: device fsid b0b183ed-9970-4e54-b7d5-7b91f3bdea10 devid 2 transid 113894 /dev/sdc 
[ 2.903883] BTRFS: device fsid b0b183ed-9970-4e54-b7d5-7b91f3bdea10 devid 1 transid 113894 /dev/sdb 
[ 6.201318] BTRFS info (device sdb): disk space caching is enabled 
[ 6.201321] BTRFS: has skinny extents 
[ 39.732758] BTRFS info (device sdb): qgroup scan completed (inconsistency flag cleared) 
[ 540.722625] BTRFS info (device sdb): qgroup scan completed (inconsistency flag cleared) 
[ 1247.758789] BTRFS info (device sdb): qgroup_rescan_init failed with -115 
[ 1265.879801] BTRFS info (device sdb): qgroup_rescan_init failed with -115 
[ 1289.854705] BTRFS info (device sdb): qgroup scan completed (inconsistency flag cleared) 
[ 1403.138613] BTRFS info (device sdb): qgroup scan completed (inconsistency flag cleared) 
[ 1564.685350] BTRFS info (device sdb): qgroup scan completed (inconsistency flag cleared) 
[ 1616.389847] BTRFS info (device sdb): The free space cache file (23651680256) is invalid. skip it 
[ 1765.145922] BTRFS info (device sdb): qgroup scan completed (inconsistency flag cleared) 
[36615.633743] BTRFS info (device sdb): qgroup scan completed (inconsistency flag cleared) 

