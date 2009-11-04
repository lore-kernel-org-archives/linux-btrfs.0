From: "Rui Miguel Silva" <rmfrfs@gmail.com>
Subject: Re: [PATCH]] Btrfs: fix destroy snapshot to get the right parent
 dentry
Date: Wed, 04 Nov 2009 10:00:28 -0000
Message-ID: <op.u2u7e0budmptbl@gentoo-vm>
References: <20091103161054.GA13781@gentoo-vm.octal.tv>
 <3d0408630911031520k78af1c39g16988123739a16e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630911031520k78af1c39g16988123739a16e2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 03 Nov 2009 23:20:02 -0000, Yan, Zheng  <yanzheng@21cn.com> wrote:

> On Wed, Nov 4, 2009 at 12:10 AM, Rui Miguel Silva <rmfrfs@gmail.com>  
> wrote:
>> In snapshot destroy the dentry used for parent was the snapshot dentry
>> itself. Remove d_invalidate since always return EBUSY, making possible
>> to remove a snapshot using the btrfsctl -D option.
>>
>
> This is not correct. The snapshot destroy ioctl receives two parameters.
> The first one provides directory that the snapshot is in, the second one
> provides the name of snapshot..
>
> The usage of 'btrfsctl -D' is:
> btrfsctl -D [name of snapshot] [directory that holds the snapshot]
>
> Yan, Zheng
>
Hi,
thanks for the explanation. I just saw the usage output: " [-D dir .]"  
"-D: delete snapshot" and I didn't understand it like the usage that you  
explained above.
I understood it like this: btrfsctl -D relative/path/to/snapshot comparing  
to the -s option "-s snap_name dir: creates a new snapshot of dir" which  
is more clear.

That makes the patch completely wrong. Once again many thanks.

Cheers,
-- Rui
>
>> Signed-off-by: Rui Miguel Silva <rmfrfs@gmail.com>
>> ---
>>  fs/btrfs/ioctl.c |    7 ++-----
>>  1 files changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index cdbb054..fe6ac9a 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -741,7 +741,7 @@ out:
>>  static noinline int btrfs_ioctl_snap_destroy(struct file *file,
>>                                             void __user *arg)
>>  {
>> -       struct dentry *parent = fdentry(file);
>> +       struct dentry *parent = file->f_path.dentry->d_parent;
>>        struct dentry *dentry;
>>        struct inode *dir = parent->d_inode;
>>        struct inode *inode;
>> @@ -793,9 +793,6 @@ static noinline int btrfs_ioctl_snap_destroy(struct  
>> file *file,
>>        dest = BTRFS_I(inode)->root;
>>
>>        mutex_lock(&inode->i_mutex);
>> -       err = d_invalidate(dentry);
>> -       if (err)
>> -               goto out_unlock;
>>
>>        down_write(&root->fs_info->subvol_sem);
>>
>> @@ -827,7 +824,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct  
>> file *file,
>>        inode->i_flags |= S_DEAD;
>>  out_up_write:
>>        up_write(&root->fs_info->subvol_sem);
>> -out_unlock:
>> +
>>        mutex_unlock(&inode->i_mutex);
>>        if (!err) {
>>                shrink_dcache_sb(root->fs_info->sb);


--
