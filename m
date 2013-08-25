Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dalmat.net ([88.183.56.135]:52646 "EHLO athena.dalmat.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433Ab3HYQXU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Aug 2013 12:23:20 -0400
Received: from [192.168.0.37] (ncemdalstein-wifi.dalmat.net [192.168.0.37])
	by athena.dalmat.net (Postfix) with ESMTPSA id 520713FC6F
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Aug 2013 18:23:18 +0200 (CEST)
Message-ID: <521A2F78.908@dalmat.net>
Date: Sun, 25 Aug 2013 18:23:20 +0200
From: Matthieu Dalstein <matthieu.dalstein@dalmat.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Ability to free space on a full btrfs filesystem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm currently experiencing some space issue on btrfs with linux kernel 3.10.
My btrfs partition is full and I fail to remove any data to give some 
free space:

athena:~# rm -f /mnt/storage/current/backup/slash/var/log/syslog
rm: cannot remove `/mnt/storage/current/backup/slash/var/log/syslog': No 
space left on device

athena:~# true > /mnt/storage/current/backup/slash/var/log/syslog
bash: /mnt/storage/current/backup/slash/var/log/syslog: No space left on 
device

I tried to follow the wiki page 
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space
but the balance operation fails due to lack of space:
athena:~# btrfs fi balance start -dusage=5 /mnt/storage/
ERROR: error during balancing '/mnt/storage/' - No space left on device

[ Kernel logs ] btrfs: 138 enospc errors during balance

I guess this scenario is not expected, or I am probably missing something.
Is there any way I can free some space and get back a writable filesystem ?

Some more info:
Mount options used for the recovery (from 
https://btrfs.wiki.kernel.org/index.php/Ubuntu_support#ENOSPC.2C_no_space_left_on_device)
/dev/sdb1 on /mnt/storage type btrfs 
(rw,relatime,nodatasum,nodatacow,nospace_cache,clear_cache)

athena:~# btrfs fi show
Label: none  uuid: 8fa5ecc2-fff6-4ad1-a6bb-e384ea2086cb
         Total devices 1 FS bytes used 475.19GB
         devid    1 size 619.33GB used 619.33GB path /dev/sdb1

athena:~# btrfs fi df /mnt/storage/
Data: total=613.30GB, used=472.69GB
System, DUP: total=8.00MB, used=72.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=3.00GB, used=2.50GB
Metadata: total=8.00MB, used=0.00

Thanks in advance
-- 
Matthieu
