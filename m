From: Leszek Ciesielski <skolima@gmail.com>
Subject: Re: Reporting free space to userspace programs
Date: Tue, 23 Feb 2010 23:27:10 +0100
Message-ID: <23a15591002231427i4cacb74ahb09fe9c98d74bd16@mail.gmail.com>
References: <23a15590910300458y677692bbua62d2b41e9141bc7@mail.gmail.com>
	 <4AEAE84A.5080003@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AEAE84A.5080003@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

in a long overdue followup to my previous email, I am sending a patch
that modifies the result of running 'df' against a btrfs volume. I
understand that, give the simplicity of 'df', there is not 'correct'
solution - I do think however, that the changed output is more
intuitive. Most importantly - the free/used space percentage are
reported correctly, which should decrease the frequency of 'my 50%
filled btrfs volume is failing with ENOSPC' emails.

Would anyone like to comment?

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8a1ea6e..893c154 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -623,13 +623,18 @@ static int btrfs_statfs(struct dentry *dentry,
struct kstatfs *buf)
 {
 	struct btrfs_root *root =3D btrfs_sb(dentry->d_sb);
 	struct btrfs_super_block *disk_super =3D &root->fs_info->super_copy;
+	struct btrfs_device *device;
 	int bits =3D dentry->d_sb->s_blocksize_bits;
 	__be32 *fsid =3D (__be32 *)root->fs_info->fsid;

 	buf->f_namelen =3D BTRFS_NAME_LEN;
 	buf->f_blocks =3D btrfs_super_total_bytes(disk_super) >> bits;
-	buf->f_bfree =3D buf->f_blocks -
-		(btrfs_super_bytes_used(disk_super) >> bits);
+	buf->f_bfree =3D buf->f_blocks;
+	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+	list_for_each_entry(device, &root->fs_info->fs_devices->devices, dev_=
list) {
+	    buf->f_bfree -=3D (device->bytes_used >> bits);
+	}
+	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 	buf->f_bavail =3D buf->f_bfree;
 	buf->f_bsize =3D dentry->d_sb->s_blocksize;
 	buf->f_type =3D BTRFS_SUPER_MAGIC;


On Fri, Oct 30, 2009 at 2:21 PM, jim owens <jowens@hp.com> wrote:
> Leszek Ciesielski wrote:
>>
>> Hi,
>>
>> the results of running 'df' against a btrfs volume are somewhat
>> unintuitive from a user point of view. On a single drive btrfs volum=
e,
>> created with 'mkfs.btrfs -m raid1 -d raid1 /dev/sda6', I am getting
>> the following result:
>>
>> /dev/sda6 =A0 =A0 =A0 =A0 =A0 =A0 1.4T =A0594G =A0804G =A043% /mnt
>>
>> while 'btrfs-show' displays much more expected result:
>>
>> Label: none =A0uuid: 46e2f2b6-e3a6-4b02-8fdc-f9d0fb0882e0
>> =A0 =A0 =A0 =A0Total devices 1 FS bytes used 593.15GB
>> =A0 =A0 =A0 =A0devid =A0 =A01 size 1.36TB used 1.26TB path /dev/sda6
>>
>> IMHO it would be more intuitive for df in this case to show 699GB
>> total capacity (based on the fact that data is mirrored, and users
>> probably are not concerned with metadata handling during normal
>> usage), the 'used space' probably should include the space taken up =
by
>> metadata in addition to data usage (after all, this space is not
>> available for user data) and free space should report only data spac=
e
>> available (because this is what the user is usually expecting). Or, =
in
>> other words: the result of 'df' should not concern the user with the
>> details of raid0/raid1/raid10 used either for data or metadata.
>
> I agree that df output sucks... but I've been there before with
> another filesystem on another OS. =A0The sad fact is df output is
> too simplistic for the features of modern (last 20 years) systems.
>
> There is no way to make df report a value other than "raw space"
> (which is what btrfs reports today) that will be accurate under
> all possible raid conditions. =A0The problem is each file can be
> stored in a different raid (OK not done now, but permitted) and
> different COW state. =A0That means space_used_per_user_file_block
> is not constant.
>
> So btrfs can only report "best case" or "worst case", but neither
> will be true.
>
> jim
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
