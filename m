From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: Fix a crash when mounting a subvolume
Date: Tue, 07 Dec 2010 12:32:03 +0800
Message-ID: <4CFDB8C3.2040003@cn.fujitsu.com>
References: <4CFD931E.6050503@cn.fujitsu.com> <AANLkTi=anwAyvYcBK8sKxcUrHL9wpcoDZc3tQNO1Ubif@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Michael Niederle <mniederle@gmx.at>
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=anwAyvYcBK8sKxcUrHL9wpcoDZc3tQNO1Ubif@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

C Anthony Risinger wrote:
> On Mon, Dec 6, 2010 at 7:51 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> We should drop dentry before deactivating the superblock, otherwise
>> we can hit this bug:
>>
>> BUG: Dentry f349a690{i=100,n=/} still in use (1) [unmount of btrfs loop1]
>> ...
>>
>> Steps to reproduce the bug:
>>
>>  # mount /dev/loop1 /mnt
>>  # mkdir save
>>  # btrfs subvolume snapshot /mnt save/snap1
>>  # umount /mnt
>>  # mount -o subvol=save/snap1 /dev/loop1 /mnt
>>  (crash)
>>
>> Reported-by: Michael Niederle <mniederle@gmx.at>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  fs/btrfs/super.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 47bf67c..61bd79a 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -685,9 +685,9 @@ static int btrfs_get_sb(struct file_system_type *fs_type, int flags,
>>                mutex_unlock(&root->d_inode->i_mutex);
>>
>>                if (IS_ERR(new_root)) {
>> +                       dput(root);
>>                        deactivate_locked_super(s);
>>                        error = PTR_ERR(new_root);
>> -                       dput(root);
>>                        goto error_free_subvol_name;
>>                }
>>                if (!new_root->d_inode) {
>> --
> 
> this seems very reasonable to me... more than once i have wanted to be
> able to mount in this way (while working out system rollback schemes
> in particular; mount by name doesn't care what the ID is).  what's the
> possibility of a patch to mount an arbitrarily nested subvol?
> 

I guess it's just because not many people cared much about this, and
no one coded it up?

> btw, patch posted regarding the above:
> 
> http://www.spinics.net/lists/linux-btrfs/msg07191.html
> 
> though as author noted, needs overview by more experienced eyes.
> 
