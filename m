Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.parallels.com ([64.131.90.16]:33543 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab2L1QbY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Dec 2012 11:31:24 -0500
Received: from [199.115.105.252] (helo=mail.parallels.com)
	by mx2.parallels.com with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <dolenin@parallels.com>)
	id 1TocqB-0002ku-Pp
	for linux-btrfs@vger.kernel.org; Fri, 28 Dec 2012 11:31:24 -0500
Message-ID: <50DDC957.9060803@parallels.com>
Date: Sat, 29 Dec 2012 01:31:19 +0900
From: dima <dolenin@parallels.com>
MIME-Version: 1.0
To: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: problems with dracut mounting subvols
References: <5FA2C0D0-740D-4425-A099-46382311E2A3@colorremedies.com> <50DCF245.20705@parallels.com> <5EE8E8F7-4147-4DD3-A928-AEFA27CE683C@colorremedies.com>
In-Reply-To: <5EE8E8F7-4147-4DD3-A928-AEFA27CE683C@colorremedies.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/28/2012 10:44 AM, Chris Murphy wrote:
>
> On Dec 27, 2012, at 6:13 PM, dima <dolenin@parallels.com> wrote:
>>
>>
>>> /dev/disk/by-uuid/64383cfe-c31d-4d25-97c4-4e6b7e788b26 /sysroot/usr btrfs subvol=usr,subvol=root,ro 1 2
>>
>> I'd say that the problem is definitely with this line having two subvolumes listed.
>> Maybe you should boot from a live CD, mount your subvolid=1 and check out what subvolumes you really have in there. And then re-write fstab manually.
>
> When I mount subvolid=5 there are subvols root, boot, usr, var, home. And the /etc/fstab in root is:
>
> #
> # /etc/fstab
> # Created by anaconda on Thu Dec 27 15:21:03 2012
> #
> # Accessible filesystems, by reference, are maintained under '/dev/disk'
> # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
> #
> UUID=64383cfe-c31d-4d25-97c4-4e6b7e788b26 /                       btrfs   subvol=root     1 1
> UUID=64383cfe-c31d-4d25-97c4-4e6b7e788b26 /boot                   btrfs   subvol=boot     1 2
> UUID=64383cfe-c31d-4d25-97c4-4e6b7e788b26 /home                   btrfs   subvol=home     1 2
> UUID=64383cfe-c31d-4d25-97c4-4e6b7e788b26 /usr                    btrfs   subvol=usr      1 2
> UUID=64383cfe-c31d-4d25-97c4-4e6b7e788b26 /var                    btrfs   subvol=var      1 2
>
>
> It's correct.
>
> Seems dracut is creating the wrong fstab for itself, but then also can't mount it correctly manually from a shell command. When booted in rescue mode to a full system, not just a dracut shell, I can mount -o subvol=root to one mount point, and also mount -o subvol=usr to another mountpoint (within or outside the former mount point) without error.


Then I guess all is fine with subvolumes and something is strange with 
the way fedora is handling those. Because it is the temporary ro mount 
that fails.
The only thing I can recommend is to first create all needed subvolumes, 
then install the minimal OS manually from CLI and configure your grub 
and fstab by hand.

Can't really help with dracut troubleshooting..


>
>
>> If you have /sysroot subvolume, you can create /sysroot/usr as a child subvolume and you won't even need then to specify /sysroot/usr in your fstab because it will be mounted automatically when the parent subvolume gets mounted.
>
> It's a useful work around. I'd like to narrow down if the real problem is dracut and if it should eventually be fixed. Seems both need fixing.
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
