Received: from calculus.sigma-star.at (calculus.sigma-star.at [188.245.196.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08C4370ADA
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 18:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.245.196.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789842808; cv=none; b=hqr7sZzGU9LYpwgE/cp6qN4No7abbvzYyL9dfhYDZGfn+J7sEIYL27zpQsLxdOotDRHdGw8bDALy3WyUVmRkz4UCVH5L1YIfXEQpAm/gNcs6UMXtzfWIkDmZAY+SWn9QUXfc8bKiSc4QmnRuc93b8u0FvXi+1bPqxdYfAQUqc1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789842808; c=relaxed/simple;
	bh=5AtHagMMUYLeYZzQ54196G5PP4vBSBQZztcyKpzpnpk=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=nck+pXrQpEdnHCsi0px9Qx1lPJFKiTOiYbPb7zdgTwhNLBHyLmeoQAbC58zjp5GHpZblRc6WyTP4Xyx2WWgwp7qjkSJ6mSPjyQ3OdUMXJ2ZJDf+rcOXFMAbj8OWdGzZDm8Ong7VRqh3aY3LvFV42qmPq4L1g/509aVs7f61Y9+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nod.at; spf=fail smtp.mailfrom=nod.at; dkim=permerror (0-bit key) header.d=nod.at header.i=@nod.at header.b=qQcq8QeR; dkim=pass (2048-bit key) header.d=nod.at header.i=@nod.at header.b=UWJJY50z; arc=none smtp.client-ip=188.245.196.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=nod.at header.i=@nod.at header.b="qQcq8QeR";
	dkim=pass (2048-bit key) header.d=nod.at header.i=@nod.at header.b="UWJJY50z"
DKIM-Signature: v=1; a=ed25519-sha256; s=v1-ed25519-20260901; d=nod.at; c=relaxed/relaxed; r=y;
	h=Date:Message-ID:Subject:To:From; t=1789842798; bh=f2HtFOe1wO2gJW7nL43hZ7q
	Uec8V2oBdSax6UtyFdMY=; b=qQcq8QeR5xhpnDnRGVoyOXGyxr8AHh/yLwDuwU/ZUSPEtahj4A
	KLmFiw2uL9+PmdPEbNBkkocaqZqiR4tBKWDw==;
DKIM-Signature: v=1; a=rsa-sha256; s=v1-rsa-20260901; d=nod.at; c=relaxed/relaxed; r=y;
	h=Date:Message-ID:Subject:To:From; t=1789842798; bh=f2HtFOe1wO2gJW7nL43hZ7q
	Uec8V2oBdSax6UtyFdMY=; b=UWJJY50zdxWH/TZ6z2Rj8mWxst69aZavuQHhsCK7JtPx7bZMqZ
	Qxi9tZnhbJBWMbJw+8QMi3pCiD5jHK4++PhvTZK1axzPv2eM6uZI+u90KuCR3b3tt9pI71LNj1a
	jndHwz25mGLaCeXJX54UmoGSnaAttxTNtevZRcoTVd7O5mMMrTjiLhLSgNkaaUId0ACySqc5Ntj
	Ab+nkmVdhC42tsA16xffttLt8TGy4UuT8UW6g5+9owt4isNbZYr3F9DnWsPZvKrR9CWl8gT0hPl
	q38WQidE+a1VAhXDnBnzh0se9kqT179dFbexqWVEN68YYzxf/cMRoJ2D4j9XNQh8eFw==;
From: "Richard Weinberger" <richard@nod.at>
To: "Johannes Thumshirn" <johannes.thumshirn@wdc.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: AW: qgroup rescan worker makes suspend fail
Message-ID: <mu8q6tyn.42813128-4ef0-41f8-afe4-d8322f21bf21@nod.at>
In-Reply-To: <aq7HYO9SKdIaqvr_@mayhem.fritz.box>
References: <mu8fq8a8.b9a9a1ae-dd6b-45a4-a415-5db853d61536@nod.at>
	<aq7HYO9SKdIaqvr_@mayhem.fritz.box>
Date: Sat, 19 Sep 2026 18:33:18 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Sat, Sep 19, 2026, 19:34 schrieb Johannes Thumshirn <johannes.thumshirn@w=
dc.com>:
> On Sat, Sep 19, 2026 at 01:40:27PM +0000, Richard Weinberger wrote:
> > Once in a while, suspending my laptop just causes the screen to freeze.
> > Initially, I thought Linux had crashed, but it usually recovers after 2 =
minutes,
> > though the suspend doesn't actually happen. You can imagine this can be =
very
> > unfortunate when you just close the laptop lid and pack the laptop into =
your
> > bag...
> >=20
> > After the problem started occurring more frequently, I investigated and =
found
> > that the qgroup rescan worker is the problem. In dmesg, logs like these =
can
> > usually be found:
> >=20
> > [246013.777637] [ T278489] Freezing remaining freezable tasks
> > [246033.780538] [ T278489] Freezing remaining freezable tasks failed aft=
er 20.003 seconds (0 tasks refusing to freeze, wq_busy=3D1):
> > [246033.780576] [ T278489] Showing freezable workqueues that are still b=
usy:
> > [246033.780582] [ T278489] workqueue events_freezable: flags=3D0x104
> > [246033.780590] [ T278489]   pwq 10: cpus=3D2 node=3D0 flags=3D0x0 nice=
=3D0 active=3D0 refcnt=3D2
> > [246033.780609] [ T278489]     inactive: pci_pme_list_scan
> > [246033.780642] [ T278489] workqueue btrfs-endio-meta: flags=3D0xe
> > [246033.780649] [ T278489]   pwq 57: cpus=3D0-13 node=3D0 flags=3D0x4 ni=
ce=3D0 active=3D0 refcnt=3D2
> > [246033.780660] [ T278489]     inactive: simple_end_io_work [btrfs]
> > [246033.781183] [ T278489] workqueue btrfs-qgroup-rescan: flags=3D0x2000=
e
> > [246033.781189] [ T278489]   pwq 56: cpus=3D0-13 flags=3D0x4 nice=3D0 ac=
tive=3D1 refcnt=3D16
> > [246033.781199] [ T278489]     in-flight: 205929:btrfs_work_helper [btrf=
s] for 111s
> > [246033.781721] [ T278489] workqueue wg-kex-wginterproc: flags=3D0x6
> > [246033.781726] [ T278489]   pwq 57: cpus=3D0-13 node=3D0 flags=3D0x4 ni=
ce=3D0 active=3D0 refcnt=3D2
> > [246033.781736] [ T278489]     inactive: wg_packet_handshake_send_worker=
 [wireguard]
> >=20
> > My first thought was that the worker is likely not freezable, but it is.
> > The problem is that the whole qgroup rescan is a single work item.
> > In my case, such a scan can take up to 10 minutes, even though I have a
> > fast NVMe SSD installed...
> >=20
> > Wouldn't it make sense to have rescan_should_stop() return true when
> > suspend starts? I think using a pm notifier could help here.
> > What do you think?
>=20
> Something like this (completely untested):

Yeah, I had something like that in mind but my btrfs-fu is weak.
=20
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a1d83ad9a4c0..541735d8fdb6 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -17,6 +17,7 @@
>  #include <linux/error-injection.h>
>  #include <linux/crc32c.h>
>  #include <linux/sched/mm.h>
> +#include <linux/suspend.h>
>  #include <linux/unaligned.h>
>  #include "ctree.h"
>  #include "disk-io.h"
> @@ -3198,6 +3199,29 @@ int btrfs_start_pre_rw_mount(struct btrfs_fs_info *=
fs_info)
>  	return 0;
>  }
> =20
> +static int btrfs_pm_notifier(struct notifier_block *nb, unsigned long act=
ion,
> +			     void *data)
> +{
> +	struct btrfs_fs_info *fs_info =3D container_of(nb, struct btrfs_fs_info,
> +						     pm_notifier);
> +
> +	switch (action) {
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
> +	case PM_RESTORE_PREPARE:
> +		set_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags);
> +		break;
> +	case PM_POST_HIBERNATION:
> +	case PM_POST_SUSPEND:
> +	case PM_POST_RESTORE:
> +		clear_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags);

AFAIK changing the bits needs to happen under ->qgroup_rescan_lock
otherwise there is no barrier which will make sure the worker sees the chang=
e.

> +		btrfs_qgroup_rescan_resume(fs_info);

Are you sure we're allowed to resume unconditionally? What if a ro remount h=
appened?
Same for the umount case.

> +		break;
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
>  /*
>   * Do various sanity and dependency checks of different features.
>   *
> @@ -3794,6 +3818,9 @@ int __cold open_ctree(struct super_block *sb, struct=
 btrfs_fs_devices *fs_device
> =20
>  	set_bit(BTRFS_FS_OPEN, &fs_info->flags);
> =20
> +	fs_info->pm_notifier.notifier_call =3D btrfs_pm_notifier;
> +	register_pm_notifier(&fs_info->pm_notifier);
> +
>  	/* Kick the cleaner thread so it'll start deleting snapshots. */
>  	if (test_bit(BTRFS_FS_UNFINISHED_DROPS, &fs_info->flags))
>  		wake_up_process(fs_info->cleaner_kthread);
> @@ -4370,6 +4397,8 @@ void __cold close_ctree(struct btrfs_fs_info *fs_inf=
o)
>  	 */
>  	kthread_park(fs_info->cleaner_kthread);
> =20
> +	unregister_pm_notifier(&fs_info->pm_notifier);
> +
>  	/* wait for the qgroup rescan worker to stop */
>  	btrfs_qgroup_wait_for_completion(fs_info, false);
> =20
> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
> index 3eba8438593c..caa90dc98e59 100644
> --- a/fs/btrfs/fs.h
> +++ b/fs/btrfs/fs.h
> @@ -26,6 +26,7 @@
>  #include <linux/wait_bit.h>
>  #include <linux/sched.h>
>  #include <linux/rbtree.h>
> +#include <linux/notifier.h>
>  #include <linux/xxhash.h>
>  #include <linux/fserror.h>
>  #include <uapi/linux/btrfs.h>
> @@ -234,6 +235,8 @@ enum {
>  	 */
>  	BTRFS_FS_UNALIGNED_TREE_BLOCK,
> =20
> +	BTRFS_FS_PM_SUSPENDING,
> +
>  #if BITS_PER_LONG =3D=3D 32
>  	/* Indicate if we have error/warn message printed on 32bit systems */
>  	BTRFS_FS_32BIT_ERROR,
> @@ -841,6 +844,8 @@ struct btrfs_fs_info {
>  	u8 qgroup_drop_subtree_thres;
>  	u64 qgroup_enable_gen;
> =20
> +	struct notifier_block pm_notifier;
> +
>  	/*
>  	 * If this is not 0, then it indicates a serious filesystem error has
>  	 * happened and it contains that error (negative errno value).
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 05e35eb126dc..b4f1290d1e14 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -3883,6 +3883,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_=
work *work)
>  	struct btrfs_trans_handle *trans =3D NULL;
>  	int ret =3D 0;
>  	bool stopped =3D false;
> +	bool pm_paused =3D false;
>  	bool did_leaf_rescans =3D false;
> =20
>  	if (btrfs_qgroup_mode(fs_info) =3D=3D BTRFS_QGROUP_MODE_SIMPLE)
> @@ -3900,7 +3901,18 @@ static void btrfs_qgroup_rescan_worker(struct btrfs=
_work *work)
>  	path->search_commit_root =3D true;
>  	path->skip_locking =3D true;
> =20
> -	while (!ret && !(stopped =3D rescan_should_stop(fs_info))) {
> +	while (!ret) {
> +		if (rescan_should_stop(fs_info)) {
> +			stopped =3D true;
> +			break;
> +		}
> +
> +		if (test_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags)) {
> +			stopped =3D true;
> +			pm_paused =3D true;
> +			break;
> +		}
> +
>  		trans =3D btrfs_start_transaction(fs_info->fs_root, 0);
>  		if (IS_ERR(trans)) {
>  			ret =3D PTR_ERR(trans);
> @@ -3963,12 +3975,17 @@ static void btrfs_qgroup_rescan_worker(struct btrf=
s_work *work)
>  	complete_all(&fs_info->qgroup_rescan_completion);
>  	mutex_unlock(&fs_info->qgroup_rescan_lock);
> =20
> +	if (pm_paused && !test_bit(BTRFS_FS_PM_SUSPENDING, &fs_info->flags))
> +		btrfs_qgroup_rescan_resume(fs_info);
> +
>  	if (!trans)
>  		return;
> =20
>  	btrfs_end_transaction(trans);
> =20
> -	if (stopped) {
> +	if (pm_paused) {
> +		btrfs_info(fs_info, "qgroup scan paused for system suspend");
> +	} else if (stopped) {
>  		btrfs_info(fs_info, "qgroup scan paused");
>  	} else if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qg=
roup_flags)) {
>  		btrfs_info(fs_info, "qgroup scan cancelled");
> @@ -4142,13 +4159,20 @@ int btrfs_qgroup_wait_for_completion(struct btrfs_=
fs_info *fs_info,
>  void
>  btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
>  {
> -	if (test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags)) {
> -		mutex_lock(&fs_info->qgroup_rescan_lock);
> +	if (!test_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags))
> +		return;
> +
> +	if (btrfs_fs_closing(fs_info))
> +		return;
> +
> +	mutex_lock(&fs_info->qgroup_rescan_lock);
> +	if (!fs_info->qgroup_rescan_running) {
> +		reinit_completion(&fs_info->qgroup_rescan_completion);
>  		fs_info->qgroup_rescan_running =3D true;
>  		btrfs_queue_work(fs_info->qgroup_rescan_workers,
>  				 &fs_info->qgroup_rescan_work);
> -		mutex_unlock(&fs_info->qgroup_rescan_lock);
>  	}
> +	mutex_unlock(&fs_info->qgroup_rescan_lock);
>  }
> =20
>  #define rbtree_iterate_from_safe(node, next, start)				\
>=20
>=20
