From: Olivier Bonvalet <btrfs.list@daevel.fr>
Subject: btrfs-convert processing time
Date: Mon, 20 Feb 2012 13:51:29 +0100
Message-ID: <4F4241D1.4080506@daevel.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm trying to convert two ext4 FS to btrfs, but I'm surprised by the 
time needed to do that conversion.

The first FS is on a 500GiB block device, and btrfs-convert is running 
since more than 48h :
root      1978 25.6 47.7 748308 732556 ?       D    Feb18 944:44 
btrfs-convert /dev/vg-backup/backup

The second is on a 340GiB block device, and the processing time is similar :
root     30192  5.2  3.0  73180 61520 pts/0    R    Feb18 121:04 
btrfs-convert /dev/vg-balor/backup


Is it "normal", or is there a problem during the processing ?

Thanks,
Olivier
