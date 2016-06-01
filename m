Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34092 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750697AbcFAEkC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 00:40:02 -0400
Date: Wed, 1 Jun 2016 00:39:59 -0400
From: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: don't force mounts to wait for cleaner_kthread to
 delete one or more subvolumes
Message-ID: <20160601043959.GJ15597@hungrycats.org>
References: <1462422229-23797-1-git-send-email-ce3g8jdj@umail.furryterror.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYYhpFXgKVw71fwr"
In-Reply-To: <1462422229-23797-1-git-send-email-ce3g8jdj@umail.furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--mYYhpFXgKVw71fwr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 05, 2016 at 12:23:49AM -0400, Zygo Blaxell wrote:
> During a mount, we start the cleaner kthread first because the transaction
> kthread wants to wake up the cleaner kthread.  We start the transaction
> kthread next because everything in btrfs wants transactions.  We do reloc
> recovery in the thread that was doing the original mount call once the
> transaction kthread is running.  This means that the cleaner kthread
> could already be running when reloc recovery happens (e.g. if a snapshot
> delete was started before a crash).
>=20
> Relocation does not play well with the cleaner kthread, so a mutex was
> added in commit 5f3164813b90f7dbcb5c3ab9006906222ce471b7 "Btrfs: fix
> race between balance recovery and root deletion" to prevent both from
> being active at the same time.
>=20
> If the cleaner kthread is already holding the mutex by the time we get
> to btrfs_recover_relocation, the mount will be blocked until at least
> one deleted subvolume is cleaned (possibly more if the mount process
> doesn't get the lock right away).  During this time (which could be an
> arbitrarily long time on a large/slow filesystem), the mount process is
> stuck and the filesystem is unnecessarily inaccessible.
>=20
> Fix this by locking cleaner_mutex before we start cleaner_kthread, and
> unlocking the mutex after mount no longer requires it.  This ensures
> that the mounting process will not be blocked by the cleaner kthread.
> The cleaner kthread is already prepared for mutex contention and will
> just go to sleep until the mutex is available.
> ---
>  fs/btrfs/disk-io.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index d8d68af..7c8f435 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2509,6 +2509,7 @@ int open_ctree(struct super_block *sb,
>  	int num_backups_tried =3D 0;
>  	int backup_index =3D 0;
>  	int max_active;
> +	bool cleaner_mutex_locked =3D false;
> =20
>  	tree_root =3D fs_info->tree_root =3D btrfs_alloc_root(fs_info);
>  	chunk_root =3D fs_info->chunk_root =3D btrfs_alloc_root(fs_info);
> @@ -2988,6 +2989,13 @@ retry_root_backup:
>  		goto fail_sysfs;
>  	}
> =20
> +	/*
> +	 * Hold the cleaner_mutex thread here so that we don't block
> +	 * for a long time on btrfs_recover_relocation.  cleaner_kthread
> +	 * will wait for us to finish mounting the filesystem.
> +	 */
> +	mutex_lock(&fs_info->cleaner_mutex);
> +	cleaner_mutex_locked =3D true;
>  	fs_info->cleaner_kthread =3D kthread_run(cleaner_kthread, tree_root,
>  					       "btrfs-cleaner");
>  	if (IS_ERR(fs_info->cleaner_kthread))

Unfortunately, if we have a log to replay, we get to code like this
in open_ctree:

        /* do not make disk changes in broken FS */
        if (btrfs_super_log_root(disk_super) !=3D 0) {
                ret =3D btrfs_replay_log(fs_info, fs_devices);
                if (ret) {
                        err =3D ret;
                        goto fail_qgroup;
                }
        }

and:

	static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
				    struct btrfs_fs_devices *fs_devices)
	{
	[...]
		if (fs_info->sb->s_flags & MS_RDONLY) {
			ret =3D btrfs_commit_super(tree_root);
			if (ret)
				return ret;
		}

and finally:

	int btrfs_commit_super(struct btrfs_root *root)
	{
		struct btrfs_trans_handle *trans;

		mutex_lock(&root->fs_info->cleaner_mutex);
		btrfs_run_delayed_iputs(root);
		mutex_unlock(&root->fs_info->cleaner_mutex);
		wake_up_process(root->fs_info->cleaner_kthread);

Well, dammit.  Since we have already locked cleaner_mutex, it promptly
recursive-deadlocks on itself--but only if the filesystem was not cleanly
umounted, and the problem disappears if you reboot and try to mount again
because there won't be a log to replay the second time.

Could we just add a bool to fs_info that says to cleaner_kthread "don't
do anything yet, we're not finished mounting"?  That way it doesn't break
if some new place to lock cleaner_mutex pops up (they do seem to move
around from one kernel version to the next).

I think we can do btrfs_run_delayed_iputs and just skip the
wake_up_process call here?  Or neuter it by having cleaner_kthread do
nothing while we are still somewhere in the middle of open_ctree.


--mYYhpFXgKVw71fwr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldOZx8ACgkQgfmLGlazG5xqjQCg4DntfzGc9kicG1AOXKktqqgP
Sw8AoMYH78iMgvfY8bE1ralse5FGvzda
=3l02
-----END PGP SIGNATURE-----

--mYYhpFXgKVw71fwr--
