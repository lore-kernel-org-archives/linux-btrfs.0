Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm28-vm1.bullet.mail.sg3.yahoo.com ([106.10.151.144]:42920 "HELO
	nm28-vm1.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752049Ab2FTHpD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 03:45:03 -0400
Message-ID: <1340178301.84302.YahooMailNeo@web190105.mail.sg3.yahoo.com>
Date: Wed, 20 Jun 2012 15:45:01 +0800 (SGT)
From: Sonu <sonuansuja@yahoo.com>
Reply-To: Sonu <sonuansuja@yahoo.com>
Subject: inspect-internal should this work ? 
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi,


on machine-a where btrfs is not root  inspect-internal works fine.

--------
# filefrag -v /btrfs/tf1 
Filesystem type is: 9123683e 
File size of /btrfs/tf1 is 409600 (100 blocks, blocksize 4096) 
 ext logical physical expected length flags 
   0       0     3101              13 
   1      13     3133     3113     87 eof 
/btrfs/tf1: 2 extents found 

; 3101 * 4096 
    12701696 


# btrfs inspect-internal logical-resolve 12701696 /btrfs 
/btrfs/tf1 

------

However on machine-b with a big file with btrfs as  root,   inspect-internal fails.. as below.

------

# filefrag -v /root/bigfile  | head
Filesystem type is: 9123683e
File size of /root/bigfile is 10737418240 (2621440 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0 13799325            3015 
   1    3015 13787311 13802339      8 
::

; 13787311 * 4096
    56472825856


# df -k .
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/vg_dev-lv_root
                      62128128  52788788   1552008  98% /


# btrfs inspect-internal logical-resolve 56472825856 /
ioctl ret=-1, error: Inappropriate ioctl for device
------

any clue on whats wrong ?  

Thanks

