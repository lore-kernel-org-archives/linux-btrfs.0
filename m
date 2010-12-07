From: C Anthony Risinger <anthony@extof.me>
Subject: Re: [PATCH] Btrfs: Fix a crash when mounting a subvolume
Date: Mon, 6 Dec 2010 20:05:13 -0600
Message-ID: <AANLkTi=anwAyvYcBK8sKxcUrHL9wpcoDZc3tQNO1Ubif@mail.gmail.com>
References: <4CFD931E.6050503@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Michael Niederle <mniederle@gmx.at>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CFD931E.6050503@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 6, 2010 at 7:51 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> We should drop dentry before deactivating the superblock, otherwise
> we can hit this bug:
>
> BUG: Dentry f349a690{i=3D100,n=3D/} still in use (1) [unmount of btrf=
s loop1]
> ...
>
> Steps to reproduce the bug:
>
> =A0# mount /dev/loop1 /mnt
> =A0# mkdir save
> =A0# btrfs subvolume snapshot /mnt save/snap1
> =A0# umount /mnt
> =A0# mount -o subvol=3Dsave/snap1 /dev/loop1 /mnt
> =A0(crash)
>
> Reported-by: Michael Niederle <mniederle@gmx.at>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
> =A0fs/btrfs/super.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 47bf67c..61bd79a 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -685,9 +685,9 @@ static int btrfs_get_sb(struct file_system_type *=
fs_type, int flags,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mutex_unlock(&root->d_inode->i_mutex);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (IS_ERR(new_root)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dput(root);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0deactivate_locked_supe=
r(s);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D PTR_ERR(new_=
root);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dput(root);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto error_free_subvol=
_name;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!new_root->d_inode) {
> --

this seems very reasonable to me... more than once i have wanted to be
able to mount in this way (while working out system rollback schemes
in particular; mount by name doesn't care what the ID is).  what's the
possibility of a patch to mount an arbitrarily nested subvol?

btw, patch posted regarding the above:

http://www.spinics.net/lists/linux-btrfs/msg07191.html

though as author noted, needs overview by more experienced eyes.

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
