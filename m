From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Reporting free space to userspace programs
Date: Thu, 25 Feb 2010 17:59:23 -0600
Message-ID: <26a1f7961002251559ya4f38d3q6b087248294f94dc@mail.gmail.com>
References: <23a15590910300458y677692bbua62d2b41e9141bc7@mail.gmail.com>
	 <4AEAE84A.5080003@hp.com>
	 <23a15591002231427i4cacb74ahb09fe9c98d74bd16@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Leszek Ciesielski <skolima@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <23a15591002231427i4cacb74ahb09fe9c98d74bd16@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 23, 2010 at 4:27 PM, Leszek Ciesielski <skolima@gmail.com> =
wrote:
> Hi,
>
> in a long overdue followup to my previous email, I am sending a patch
> that modifies the result of running 'df' against a btrfs volume. I
> understand that, give the simplicity of 'df', there is not 'correct'
> solution - I do think however, that the changed output is more
> intuitive. Most importantly - the free/used space percentage are
> reported correctly, which should decrease the frequency of 'my 50%
> filled btrfs volume is failing with ENOSPC' emails.
>
> Would anyone like to comment?
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 8a1ea6e..893c154 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -623,13 +623,18 @@ static int btrfs_statfs(struct dentry *dentry,
> struct kstatfs *buf)
> =A0{
> =A0 =A0 =A0 =A0struct btrfs_root *root =3D btrfs_sb(dentry->d_sb);
> =A0 =A0 =A0 =A0struct btrfs_super_block *disk_super =3D &root->fs_inf=
o->super_copy;
> + =A0 =A0 =A0 struct btrfs_device *device;
> =A0 =A0 =A0 =A0int bits =3D dentry->d_sb->s_blocksize_bits;
> =A0 =A0 =A0 =A0__be32 *fsid =3D (__be32 *)root->fs_info->fsid;
>
> =A0 =A0 =A0 =A0buf->f_namelen =3D BTRFS_NAME_LEN;
> =A0 =A0 =A0 =A0buf->f_blocks =3D btrfs_super_total_bytes(disk_super) =
>> bits;
> - =A0 =A0 =A0 buf->f_bfree =3D buf->f_blocks -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 (btrfs_super_bytes_used(disk_super) >> =
bits);
> + =A0 =A0 =A0 buf->f_bfree =3D buf->f_blocks;
> + =A0 =A0 =A0 mutex_lock(&root->fs_info->fs_devices->device_list_mute=
x);
> + =A0 =A0 =A0 list_for_each_entry(device, &root->fs_info->fs_devices-=
>devices, dev_list) {
> + =A0 =A0 =A0 =A0 =A0 buf->f_bfree -=3D (device->bytes_used >> bits);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 mutex_unlock(&root->fs_info->fs_devices->device_list_mu=
tex);
> =A0 =A0 =A0 =A0buf->f_bavail =3D buf->f_bfree;
> =A0 =A0 =A0 =A0buf->f_bsize =3D dentry->d_sb->s_blocksize;
> =A0 =A0 =A0 =A0buf->f_type =3D BTRFS_SUPER_MAGIC;
>
>
> On Fri, Oct 30, 2009 at 2:21 PM, jim owens <jowens@hp.com> wrote:
>> Leszek Ciesielski wrote:
>>>
>>> Hi,
>>>
>>> the results of running 'df' against a btrfs volume are somewhat
>>> unintuitive from a user point of view. On a single drive btrfs volu=
me,
>>> created with 'mkfs.btrfs -m raid1 -d raid1 /dev/sda6', I am getting
>>> the following result:
>>>
>>> /dev/sda6 =A0 =A0 =A0 =A0 =A0 =A0 1.4T =A0594G =A0804G =A043% /mnt
>>>
>>> while 'btrfs-show' displays much more expected result:
>>>
>>> Label: none =A0uuid: 46e2f2b6-e3a6-4b02-8fdc-f9d0fb0882e0
>>> =A0 =A0 =A0 =A0Total devices 1 FS bytes used 593.15GB
>>> =A0 =A0 =A0 =A0devid =A0 =A01 size 1.36TB used 1.26TB path /dev/sda=
6
>>>
>>> IMHO it would be more intuitive for df in this case to show 699GB
>>> total capacity (based on the fact that data is mirrored, and users
>>> probably are not concerned with metadata handling during normal
>>> usage), the 'used space' probably should include the space taken up=
 by
>>> metadata in addition to data usage (after all, this space is not
>>> available for user data) and free space should report only data spa=
ce
>>> available (because this is what the user is usually expecting). Or,=
 in
>>> other words: the result of 'df' should not concern the user with th=
e
>>> details of raid0/raid1/raid10 used either for data or metadata.
>>
>> I agree that df output sucks... but I've been there before with
>> another filesystem on another OS. =A0The sad fact is df output is
>> too simplistic for the features of modern (last 20 years) systems.
>>
>> There is no way to make df report a value other than "raw space"
>> (which is what btrfs reports today) that will be accurate under
>> all possible raid conditions. =A0The problem is each file can be
>> stored in a different raid (OK not done now, but permitted) and
>> different COW state. =A0That means space_used_per_user_file_block
>> is not constant.
>>
>> So btrfs can only report "best case" or "worst case", but neither
>> will be true.
>>
>> jim
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I felt like the 'df' value that was returned after applying this patch
was misleading.

Btrfs pre-allocates an amount of space for data, metadata, and system
data, but it doesn't actually use all that space (until the volume
begins to get full).

The 'df' value returned with this patch applied is the amount of space
that is 'allocated' (which is labeled as 'used' in the btrfs-show
output, but really isn't all used yet).

=46or example, when I tested this patch on my volume, the result was
based on 10.00GB of allocated data space.  But only 7.22GB of the
allocated data space had been used.

It highlights an odd problem.  The volume runs out of space based on
the allocated areas.  So in that sense this patch gives a more
accurate representation of when the disk is full.  But from what I've
seen so far, btrfs operates most of the time with a fair amount of fat
between allocated space and actually used space.  So this patch
doesn't give you a good idea of how much space is actually left for
you to use.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
