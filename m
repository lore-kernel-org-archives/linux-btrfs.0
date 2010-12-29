From: Lubos Kolouch <lubos.kolouch@gmail.com>
Subject: list files on a device
Date: Wed, 29 Dec 2010 13:50:41 +0000 (UTC)
Message-ID: <iffebh$dlj$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

After another power loss (I am fortune, am I not?) I have the following 
situation :

Label: none  uuid: ac155851-0e31-4aed-9ba4-ee712506368a
	Total devices 3 FS bytes used 1.02TB
	devid    1 size 931.51GB used 70.00GB path /dev/sdd1
	devid    3 size 1.79TB used 66.52GB path /dev/md2
	devid    2 size 914.70GB used 914.50GB path /dev/sda4

btrfs device delete does not work on both md2 and sdd1
(csum errors).

So what I would like to do is to delete the files either on md2 or
sdd1 and then try to remove the volume again (followed by rsync).

Is there a way to find out what files are on each volume?

Thank you

Lubos

