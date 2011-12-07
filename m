From: BJ Quinn <bj@placs.net>
Subject: Cloning a Btrfs partition
Date: Wed, 07 Dec 2011 12:35:42 -0600 (CST)
Message-ID: <d0ff909c-00a0-4f34-a1dc-6be0a8fdd832@mail.placs.net>
References: <bb747e0c-d6d8-4f60-a3f6-cf64c856515e@mail.placs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <bb747e0c-d6d8-4f60-a3f6-cf64c856515e@mail.placs.net>
List-ID: <linux-btrfs.vger.kernel.org>

I've got a 6TB btrfs array (two 3TB drives in a RAID 0). It's about 2/3 full and has lots of snapshots. I've written a script that runs through the snapshots and copies the data efficiently (rsync --inplace --no-whole-file) from the main 6TB array to a backup array, creating snapshots on the backup array and then continuing on copying the next snapshot. Problem is, it looks like it will take weeks to finish. 

I've tried simply using dd to clone the btrfs partition, which technically appears to work, but then it appears that the UUID between the arrays is identical, so I can only mount one or the other. This means I can't continue to simply update the backup array with the new snapshots created on the main array (my script is capable of "catching up" the backup array with the new snapshots, but if I can't mount both arrays...). 

Any suggestions? 

-BJ Quinn 
