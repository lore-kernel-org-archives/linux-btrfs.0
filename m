Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:35328
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932076AbbKLStB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 13:49:01 -0500
From: Scotty Edmonds <scotty@scottyedmonds.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: BTRFS Error - Rockstor
Date: Thu, 12 Nov 2015 18:48:56 +0000
Message-ID: <SN2PR07MB013A0D1DE3EC69CFAD9885ACF120@SN2PR07MB013.namprd07.prod.outlook.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rockstor was running great, I ordered a SuperMicro 24-bay Chassis and decided to power down the machine while I was away.  When I turned it back on I got "Failed to read chunk tree" & "open_ctree failed" error (http://i.imgur.com/rGk9M57l.jpg)

I spoke with support at Rockstor and they recommended I seek help via the mailing list.  Here are some details and commands I've run.  The specific array is in RAID5 and the label is mainNAS, seagate3x2tb is running perfectly.

[root@rockstor ~]# btrfs device scan
Scanning for Btrfs filesystems
[root@rockstor ~]# 

 
 
[root@rockstor ~]# /usr/bin/lsblk -P -o NAME,MODEL,SERIAL,SIZE,TRAN,VENDOR,HCTL,TYPE,FSTYPE,LABEL,UUID
NAME="sda" MODEL="WDC WD30EFRX-68E" SERIAL="WD-WCC4N4KVC39Y" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:0:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
NAME="sdb" MODEL="WDC WD30EZRX-00M" SERIAL="WD-WCAWZ2551761" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:1:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
NAME="sdc" MODEL="HGST HDN724030AL" SERIAL="PK2234P9J590GY" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:2:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
NAME="sdd" MODEL="HGST HDN724030AL" SERIAL="PK2234P9J5WA1Y" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:3:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
NAME="sde" MODEL="ST3000DM001-1CH1" SERIAL="Z1F517PH" SIZE="2.7T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:4:0" TYPE="disk" FSTYPE="btrfs" LABEL="mainNAS" UUID="e8c92d93-fac3-4f83-b3aa-31cb92caafd9"
NAME="sdf" MODEL="ST2000DL003-9VT1" SERIAL="5YD1WK0V" SIZE="1.8T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:5:0" TYPE="disk" FSTYPE="btrfs" LABEL="seagate3x2tb" UUID="6ef19043-2d83-4ff1-b959-b9f3c425cc69"
NAME="sdg" MODEL="ST2000DL003-9VT1" SERIAL="5YD2EBDA" SIZE="1.8T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:6:0" TYPE="disk" FSTYPE="btrfs" LABEL="seagate3x2tb" UUID="6ef19043-2d83-4ff1-b959-b9f3c425cc69"
NAME="sdh" MODEL="ST2000DL003-9VT1" SERIAL="5YD2L28Z" SIZE="1.8T" TRAN="sas" VENDOR="ATA     " HCTL="0:0:7:0" TYPE="disk" FSTYPE="btrfs" LABEL="seagate3x2tb" UUID="6ef19043-2d83-4ff1-b959-b9f3c425cc69"
NAME="sdi" MODEL="INTEL SSDSA2CW08" SERIAL="CVPR1330019Y080BGN" SIZE="74.5G" TRAN="sata" VENDOR="ATA     " HCTL="1:0:0:0" TYPE="disk" FSTYPE="" LABEL="" UUID=""
NAME="sdi1" MODEL="" SERIAL="" SIZE="500M" TRAN="" VENDOR="" HCTL="" TYPE="part" FSTYPE="ext4" LABEL="" UUID="53aabf2f-5e28-4a18-922f-b0767a77a8ec"
NAME="sdi2" MODEL="" SERIAL="" SIZE="7.3G" TRAN="" VENDOR="" HCTL="" TYPE="part" FSTYPE="swap" LABEL="" UUID="bf9e72c7-7d72-4a33-a5eb-0a0013033234"
NAME="sdi3" MODEL="" SERIAL="" SIZE="66.8G" TRAN="" VENDOR="" HCTL="" TYPE="part" FSTYPE="btrfs" LABEL="rockstor_rockstor" UUID="3533171e-d95b-4491-aa4c-cc956536a1c3"
[root@rockstor ~]# 


 
 
[root@rockstor ~]# btrfs fi show
Label: 'rockstor_rockstor'  uuid: 3533171e-d95b-4491-aa4c-cc956536a1c3
        Total devices 1 FS bytes used 2.17GiB
        devid    1 size 66.79GiB used 7.02GiB path /dev/sdi3
 
Label: 'seagate3x2tb'  uuid: 6ef19043-2d83-4ff1-b959-b9f3c425cc69
        Total devices 3 FS bytes used 1.13TiB
        devid    1 size 1.82TiB used 595.03GiB path /dev/sdh
        devid    2 size 1.82TiB used 595.01GiB path /dev/sdf
        devid    3 size 1.82TiB used 595.01GiB path /dev/sdg
 
Label: 'mainNAS'  uuid: e8c92d93-fac3-4f83-b3aa-31cb92caafd9
        Total devices 5 FS bytes used 5.43TiB
        devid    1 size 2.73TiB used 1.36TiB path /dev/sdd
        devid    2 size 2.73TiB used 1.36TiB path /dev/sdc
        devid    3 size 2.73TiB used 1.36TiB path /dev/sda
        devid    4 size 2.73TiB used 1.36TiB path /dev/sde
        devid    5 size 2.73TiB used 1.36TiB path /dev/sdb
 
 
btrfs-progs v4.2.1

I'm unable to mount any of the drives that are in the mainNAS array, this is the error when I try to mount all of the drives degraded.

[root@rockstor ~]# mount -v -o degraded /dev/sdd /mnt2/mainNAS
mount: wrong fs type, bad option, bad superblock on /dev/sdd,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so.
[root@rockstor ~]# 

I haven't given up hope yet as the "btrfs fi show" gives me all the correct data and I ran chunk-recover and superblocks all report back as good.


Thanks for your help, let me know if you need any further information.

 Thanks,
 
 Scotty Edmonds
 Scotty@ScottyEdmonds.com
    