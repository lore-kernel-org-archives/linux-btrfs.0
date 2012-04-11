From: Francesco Cepparo <francesco.cepparo@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1890!
Date: Wed, 11 Apr 2012 23:59:43 +0000
Message-ID: <CACfQV3j_WGTB-+booc1bDMvs1i_Kjr_WAAmLKgUb9sUWe-+wPg@mail.gmail.com>
References: <CACfQV3hb92zrYUJ8to1mq8s1wzfdEoMBDi9b5VmfZ0AZ=UBkFA@mail.gmail.com>
	<20120411150158.GA5820@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120411150158.GA5820@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

I tried your patch but unfortunately the kernel still gives me the
same error message :(



On Wed, Apr 11, 2012 at 3:01 PM, Josef Bacik <josef@redhat.com> wrote:
> On Wed, Apr 11, 2012 at 02:44:26PM +0000, Francesco Cepparo wrote:
>> Hi, I've been using btrfs for a while now, and some months ago one o=
f
>> my filesystems stopped mounting. I tried to fix it by mounting it wi=
th
>> the recovery option, by using btrfs-zero-log and by restoring the
>> superblock but it didn't work, so I left the filesystem standing the=
re
>> waiting for the fsck repairing tool to be released (running the
>> version of fsck I had at the time produced the following output:
>> http://dl.dropbox.com/u/2565562/btrfsck-old-output while running the
>> 2012-03-28 version of btrfsck produces the following output:
>> http://dl.dropbox.com/u/2565562/btrfsck-20120328-output.gz ).
>> I'm still waiting for the repairing tool and I haven't tried the
>> dangerous don't ever use branch, but as I have updated the kernel to
>> version 3.4.0-rc2 I tried to mount the filesystem again with the new
>> kernel, and instead of failing with this error message:
>> http://dl.dropbox.com/u/2565562/btrfs-kernel-3.3 as it did with kern=
el
>> 3.3.1 and the previous kernels, with 3.4.0-rc2 it now hits the
>> following kernel BUG:
>> http://dl.dropbox.com/u/2565562/btrfs-kernel-3.4-bug
>>
>> I hope I can be of any help in improving the already great btrfs.
>> Also, is there any hope for me to recover my old filesystem? :)
>
> Sorry, can you try this patch and see if it stops panicing, thanks,
>
> Josef
>
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 20196f4..2a3ddd2 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -383,17 +383,17 @@ static int btree_read_extent_buffer_pages(struc=
t btrfs_root *root,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (test_bit(EXTENT_BUFFER_CORRUPT, &e=
b->bflags))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_copies =3D btrfs_num_copies(&root->=
fs_info->mapping_tree,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 eb->start, eb->len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (num_copies =3D=3D 1)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!failed_mirror) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0failed =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR "faile=
d mirror was %d\n", eb->failed_mirror);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0failed_mirror =3D eb->=
failed_mirror;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 num_copies =3D btrfs_num_copies(&root->=
fs_info->mapping_tree,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 eb->start, eb->len);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (num_copies =3D=3D 1)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mirror_num++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mirror_num =3D=3D failed_mirror)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mirror_num++;
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
