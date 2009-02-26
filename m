From: Yan Zheng <yanzheng@21cn.com>
Subject: Re: [review] Btrfs: Allow shrinking close to used space
Date: Thu, 26 Feb 2009 10:31:09 +0800
Message-ID: <3d0408630902251831x4fad55d3t2375135067bdd3ce@mail.gmail.com>
References: <m34oyixrcp.fsf@pullcord.laptop.org>
	 <20090225200229.GB10849@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Ball <cjb@laptop.org>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090225200229.GB10849@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/2/26 Josef Bacik <josef@redhat.com>:
> On Wed, Feb 25, 2009 at 02:13:10PM -0500, Chris Ball wrote:
>> Hi,
>>
>> This patch (against experimental HEAD) attempts to make shrinking mo=
re
>> robust, by only updating device size if we've succeeded in creating
>> enough free space without any failures in btrfs_relocate_chunk().
>>
>> Here's a log with my patch applied. =A0The two things to note are th=
at a
>> near-limit shrink now works, and that a failed shrink (in this case,
>> trying to shrink to less than the used space) no longer updates the
>> device size erroneously:
>>
>> =A0 http://dev.laptop.org/~cjb/btrfs/shrink-log
>>
>> Please review carefully -- I'm still new to btrfs. =A0The short vers=
ion of
>> the patch is:
>>
>> * create a success path, as a break out of the while(1) relocating
>> =A0 (rather than going to the "done" label).
>> * move the device size updating code into that path
>> * leave "path->reada =3D 2;" behind in the entry path, since path is
>> =A0 used by the searching operation rather than the later resize.
>>
>> Thanks!
>>
>> Signed-off-by: Chris Ball <cjb@laptop.org>
>>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index 1316139..e2fa072 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1815,30 +1815,8 @@ int btrfs_shrink_device(struct btrfs_device *=
device, u64 new_size)
>> =A0 =A0 =A0 if (!path)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>>
>> - =A0 =A0 trans =3D btrfs_start_transaction(root, 1);
>> - =A0 =A0 if (!trans) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOMEM;
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto done;
>> - =A0 =A0 }
>> -
>> =A0 =A0 =A0 path->reada =3D 2;
>>
>> - =A0 =A0 lock_chunks(root);
>> -
>> - =A0 =A0 device->total_bytes =3D new_size;
>> - =A0 =A0 if (device->writeable)
>> - =A0 =A0 =A0 =A0 =A0 =A0 device->fs_devices->total_rw_bytes -=3D di=
ff;
>
> So I think you still want to do this part, to keep the allocator from=
 actually
> allocating new space in the area we are trying to cull with the shrin=
k, we just
> don't want to update the ondisk stuff just yet, so everything else ca=
n be moved
> to below the loop.
>
> So this
>> - =A0 =A0 ret =3D btrfs_update_device(trans, device);
>> - =A0 =A0 if (ret) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 unlock_chunks(root);
>> - =A0 =A0 =A0 =A0 =A0 =A0 btrfs_end_transaction(trans, root);
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto done;
>> - =A0 =A0 }
>> - =A0 =A0 WARN_ON(diff > old_total);
>> - =A0 =A0 btrfs_set_super_total_bytes(super_copy, old_total - diff);
>
> to here should all be moved below like you have it. =A0Other than tha=
t it looks
> good. =A0Thanks,
>

This isn't working. we don't call btrfs_update_device here, but it can =
be called
in other places. I think we should add a new field in btrfs_device to
reflect the
on disk device size, and update it when shrinking succeeds.

Regards
Yan Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
