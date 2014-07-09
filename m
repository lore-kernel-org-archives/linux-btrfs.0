Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28939 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751150AbaGIB5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jul 2014 21:57:20 -0400
Message-ID: <53BCA17D.9060301@cn.fujitsu.com>
Date: Wed, 9 Jul 2014 09:57:17 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <lists@xunil.at>, <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs and mount in gentoo linux
References: <53BC4172.8080300@xunil.at> <pan.2014.07.08.20.19.04@googlemail.com> <53BC5A1A.7020403@xunil.at>
In-Reply-To: <53BC5A1A.7020403@xunil.at>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: btrfs and mount in gentoo linux
From: Stefan G. Weichinger <lists@xunil.at>
To: linux-btrfs@vger.kernel.org
Date: 2014年07月09日 04:52
> Am 08.07.2014 22:19, schrieb Holger Hoffstätte:
>> On Tue, 08 Jul 2014 21:07:30 +0200, Stefan G. Weichinger wrote:
>>
>>> I am a happy btrfs-user with gentoo linux for some time now and noticed
>>> that the command "mount" does not show me which subvolid is mounted where.
>> Interestingly I just found that this came up in Fedora some time ago:
>> https://bugzilla.redhat.com/show_bug.cgi?id=743118
>>
>> findmnt seems to do the trick, so the underlying functionality in
>> libmnt seems to work. Maybe Debian's mount does something differently?
> findmnt does not fully show the subvolids or names:
>
>
> # findmnt  | grep btrfs
> /                                /dev/sda3[/rootfs]    btrfs
> rw,noatime,compress=lzo,ssd,space_cache
> ├─/mnt/uncow                     /dev/sda3             btrfs
> rw,noatime,compress=lzo,ssd,space_cache
> └─/home/sgw                      /dev/mapper/_dev_sda4 btrfs
> rw,noatime,compress=lzo,ssd,space_cache
>
> The "[/rootfs]" is something in the right direction ...
The bug is that, if you don't use 'subvol=' mount option but use default 
subvolume or 'subvolid=' mount option,
findmnt will not give the output.

Since 'subvol=' mount option differs from default subvolume mount or 
'subvolid=' mount option in calling behavior,
'subvol=' uses mount_subtree() vfs call, which records subtree mount info.
On the other hand, default subvolume mount or 'subvolid=' mount does not 
go through the vfs subtree mount
but use btrfs's implement, which does not report vfs submount.

I'll try to investigate further and find whether we can fix it to show 
more info.

Thanks,
Qu
>
> S
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

