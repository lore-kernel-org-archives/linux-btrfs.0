Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from walhalla.sjomar.eu ([141.105.125.198]:54349 "EHLO
	mail.sjomar.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332AbbI3T3q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 15:29:46 -0400
From: Sjoerd <sjoerd@sjomar.eu>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, <artafinde@gmail.com>
Date: Wed, 30 Sep 2015 21:29:42 +0200
Message-ID: <1501fbb5088.2767.ff8c1290f37e89588b661f56613851bb@sjomar.eu>
In-Reply-To: <1501fba4ad0.2767.ff8c1290f37e89588b661f56613851bb@sjomar.eu>
References: <1627746.fEEz2JqgZk@hoefnix>
 <20150930190423.GB9194@sune>
Subject: Re: RAID5 doesn't mount on boot, but you can afterwards?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi my fstab looks as follows (nb: i added the recovery option to see if 
that would help, which didn't) the bootdisk (and @home)is a ssd and the 
label STORAGE represents the RAID5 array:

# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sdc1 during installation
UUID=0ea60d4d-3f34-4451-8272-442fcccb7f2e /               btrfs   
recovery,noatime,nodiratime,subvol=@ 0       1
# /home was on /dev/sdc1 during installation
UUID=0ea60d4d-3f34-4451-8272-442fcccb7f2e /home           btrfs   
recovery,noatime,nodiratime,subvol=@home 0       2

# STORAGE
LABEL=STORAGE   /data/HOME              btrfs   
recovery,noatime,nodiratime,compress=zlib,subvol=@home_dir      0       2
LABEL=STORAGE   /data/Pictures          btrfs   
recovery,noatime,nodiratime,compress=zlib,subvol=@pictures      0       2
LABEL=STORAGE   /data/Multimedia        btrfs   
recovery,noatime,nodiratime,compress=zlib,subvol=@multimedia    0       2
LABEL=STORAGE   /data/docker            btrfs   
recovery,noatime,nodiratime,compress=zlib,subvol=@docker                0   
   2LABEL=STORAGE   /data/vms               btrfs   
recovery,noatime,nodiratime,compress=zlib,subvol=@vms           0       2
LABEL=STORAGE   /data/Downloads         btrfs   
recovery,noatime,nodiratime,compress=zlib,subvol=@downloads     0       2
LABEL=STORAGE   /data/Backups           btrfs   
recovery,noatime,nodiratime,compress=zlib,subvol=@backups       0       2
LABEL=STORAGE   /data/Software          btrfs   
recovery,noatime,nodiratime,compress=zlib,subvol=@software      0       2



On September 30, 2015 9:04:39 PM Leonidas Spyropoulos <artafinde@gmail.com> 
wrote:

> Hello,
>
> On 30/09/15, Sjoerd wrote:
>> Hi All,
>>
>> A RAID5 setup on raw devices doesn't want to automount on boot.
>> [..]
>
> Post your /etc/fstab file please.
>
> Thanks
> --
> Sent using mutt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


