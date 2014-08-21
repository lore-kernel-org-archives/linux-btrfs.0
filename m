Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52104 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753634AbaHUGs5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 02:48:57 -0400
Message-ID: <53F59656.4090404@cn.fujitsu.com>
Date: Thu, 21 Aug 2014 14:48:54 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Eryu Guan <guaneryu@gmail.com>, Zach Brown <zab@zabbo.net>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] cannot mount subvolume with selinux context
References: <20140819033216.GB3013@dhcp-13-216.nay.redhat.com> <20140819172854.GG429@lenny.home.zabbo.net> <20140820035742.GC3013@dhcp-13-216.nay.redhat.com>
In-Reply-To: <20140820035742.GC3013@dhcp-13-216.nay.redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [BUG] cannot mount subvolume with selinux context
From: Eryu Guan <guaneryu@gmail.com>
To: Zach Brown <zab@zabbo.net>
Date: 2014年08月20日 11:57
> On Tue, Aug 19, 2014 at 10:28:54AM -0700, Zach Brown wrote:
>> On Tue, Aug 19, 2014 at 11:32:16AM +0800, Eryu Guan wrote:
>>> Hi,
>>>
>>> Description of the problem:
>>>
>>> mount btrfs with selinux context, then create a subvolume, the new
>>> subvolume cannot be mounted, even with the same context.
>>>
>>> mkfs -t btrfs /dev/sda5
>>> mount -o context=system_u:object_r:nfs_t:s0 /dev/sda5 /mnt/btrfs
>>> btrfs subvolume create /mnt/btrfs/subvol
>>> mount -o subvol=subvol,context=system_u:object_r:nfs_t:s0 /dev/sda5 /mnt/test
>> Submit a xfstest?
> Sure, will do.
>
> Thanks,
> Eryu
>>> The security_sb_copy_data() takes out selinux context data to
>>> "secdata", then mount_subvol() calls mount_fs() (via vfs_kern_mount())
>>> again without selinux context, so mount_subvol() fails, which fails
>>> the whole mount.
>>>
>>> Not sure what's the proper fix. Zach suggestted that the fix will
>>> probably be to rework the vfs functions a bit as he said in rh
>>> bugzilla[1].
>> Yeah, I have no idea what'd be preferred here:
>>
>>   - rework the vfs _kern_ mount api to offer one that doesn't mess with
>>     selinux mount options
>>   - add a flag to have the second _kern_ mount ignore selinux (but not
>>     MS_KERNMOUNT?)
>>   - binary data and fs selinux handling?  (like nfs)
In fact, we can just make btrfs deal with "subvol=" mount option in a 
new method.
Current, btrfs handle "subvol=" by call vfs_kern_mount again and use vfs 
level mount_subtree() to do the path
search thing.

But on the other hand, btrfs does not call vfs_kern_mount() when 
handling default subvolume or "subvolid=" mount,
so, I think we can do all the path search inside btrfs instead of reuse 
vfs level functions, and convert "subvol="
mount option to "subvolid=", which should be selinux friendly now.
(And in this method mount_subvol() should be called just before 
get_default_root()).

If I am wrong, please tell me.

BTW, it seems that if mainline kernel accept the patchset which convert 
"subvolid=" to "subvol=", it will make the
bug more seriously. :-(
Thank goddness, the successor patch uses get_path()....

Thanks,
Qu
>>
>> - z
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

