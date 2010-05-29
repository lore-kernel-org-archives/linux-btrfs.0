From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [patch 5/11] btrfs: remove unneeded null check in btrfs_rename()
Date: Sat, 29 May 2010 11:01:56 -0700
Message-ID: <AANLkTikLkpTgkOGi8M8VL_rZRLyzbJKoKW9RiNMJenMi@mail.gmail.com>
References: <20100529094508.GF5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, Yan Zheng <zheng.yan@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chris Mason <chris.mason@oracle.com>,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100529094508.GF5483@bicker>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 29, 2010 at 2:45 AM, Dan Carpenter <error27@gmail.com> wrot=
e:
> "old_inode" cannot be null here, because we dereference it
> unconditionally throughout the function.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index fa6ccc1..0bc29be 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6487,10 +6487,8 @@ static int btrfs_rename(struct inode *old_dir,=
 struct dentry *old_dentry,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * make sure the inode gets flushed if it =
is replacing
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * something.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> - =C2=A0 =C2=A0 =C2=A0 if (new_inode && new_inode->i_size &&
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 old_inode && S_ISREG(old_inode->=
i_mode)) {
> + =C2=A0 =C2=A0 =C2=A0 if (new_inode && new_inode->i_size && S_ISREG(=
old_inode->i_mode))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs_add_orde=
red_operation(trans, root, old_inode);
> - =C2=A0 =C2=A0 =C2=A0 }

I think code like this is here because there are still a lot of
features that are being added to btrfs and it's easier to have the
additional checks than continually adding and removing them as the
code changes.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
