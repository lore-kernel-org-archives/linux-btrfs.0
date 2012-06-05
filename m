Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60495 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab2FEOiP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 10:38:15 -0400
Received: by ghrr11 with SMTP id r11so4337137ghr.19
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jun 2012 07:38:14 -0700 (PDT)
Message-ID: <4FCE19D3.4090908@webstarts.com>
Date: Tue, 05 Jun 2012 10:38:11 -0400
From: Jim <jim@webstarts.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: delete disk proceedure
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good morning btrfs list,
I had written about 2 weeks ago about using extra btrfs space in an nfs 
file system setup.  Nfs seems to export the files but the mounts don't 
work on older machines without btrfs kernels.  So I am down to deleting 
several drives from btrfs to setup a standard raid 1 array for storage 
and export via nfs.  My system stats are:
[root@advanced ~]# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdm2             196G   50G  137G  27% /
tmpfs                  16G     0   16G   0% /dev/shm
/dev/sdm1             2.0G  141M  1.8G   8% /boot
/dev/sdm5             1.2T   20G  1.1T   2% /var
10.2.0.40:/data/sites
                       2.6T  2.4T  155G  94% /nfs1/data/sites
10.2.0.42:/data/sites
                       2.6T  2.2T  328G  87% /nfs2/data/sites
/dev/sda               11T  4.9T  6.0T  46% /btrfs
[root@advanced ~]# btrfs fi show
failed to read /dev/sr0
Label: none  uuid: c21f1221-a224-4ba4-92e5-cdea0fa6d0f9
         Total devices 12 FS bytes used 4.76TB
         devid    6 size 930.99GB used 429.32GB path /dev/sdf
         devid    5 size 930.99GB used 429.32GB path /dev/sde
         devid    8 size 930.99GB used 429.32GB path /dev/sdh
         devid    9 size 930.99GB used 429.32GB path /dev/sdi
         devid    4 size 930.99GB used 429.32GB path /dev/sdd
         devid    3 size 930.99GB used 429.32GB path /dev/sdc
         devid   11 size 930.99GB used 429.08GB path /dev/sdk
         devid    2 size 930.99GB used 429.32GB path /dev/sdb
         devid   10 size 930.99GB used 429.32GB path /dev/sdj
         devid   12 size 930.99GB used 429.33GB path /dev/sdl
         devid    7 size 930.99GB used 429.32GB path /dev/sdg
         devid    1 size 930.99GB used 429.09GB path /dev/sda

Btrfs v0.19-35-g1b444cd

df -h and btrfs fi show seem to be in good size agreement.  Btrfs was 
created as raid1 metadata and raid0 data.  I would like to delete the 
last 4 drives leaving 7T of space to hold 4.9T of data.  My plan would 
be to remove /dev/sdi, j, k, l one at a time.  After all are deleted run 
"btrfs fi balance /btrfs".  The data is not critical and can be lost but 
I am really trying to avoid the hassle of having to completely redo the 
filesystem.  Does my deletion plan seem reasonable.  Please, I'm really 
swimming alone here and would value some advice.
Jim Maloney
-- 

