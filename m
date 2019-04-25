Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8500C10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 09:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AA1520675
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 09:29:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Qnzp6VBe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfDYJ3x (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 05:29:53 -0400
Received: from mout.gmx.net ([212.227.17.22]:59821 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbfDYJ3x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 05:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556184572;
        bh=K58m5HAOwA0d+KqGwZA/al4/iPid/6bNh/u41dTRFWs=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=Qnzp6VBeHKoiEmhliSaMl2e7lqy7ciVcDCUx/W7YNrrv7gRSv3hqFIwbSa/XJAoQy
         plovBPvZ0T/DsEn62MpSS+4DHu6Ab6RYgHAIVnWzLXdRziqInvqFdpCcyPQRghGUo6
         NjwYh83Dgl5EoBvZd7nt02iEO6WMQ8Bii18dNvsc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mn2aN-1gufOe1wiV-00kB6z; Thu, 25
 Apr 2019 11:29:32 +0200
Subject: Re: [PATCH] Btrfs: fix unexpected failure of nocow buffered writes
 after snapshotting when low on space
To:     robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
References: <1533522630-21758-1-git-send-email-robbieko@synology.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <afb5d89f-e1f9-351e-c789-ac291649d17b@gmx.com>
Date:   Thu, 25 Apr 2019 17:29:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1533522630-21758-1-git-send-email-robbieko@synology.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="u42MJZRqipcN99wcEdEFZM5hR0v8pesAv"
X-Provags-ID: V03:K1:kcIDPLnC6vA5CnmgevrCuiedLP03MbJzoNn891qC2Ib6IGhhxVe
 ZcjiyXoq5T1G7Hp1/qNPTcPz43osJAQzo4kv1JBwZAskmBEAbeUS4PFVmdoq5TsDSfZbmAg
 FwdUKIWUR4JDbv0z+Vs/3L24WeCZwmZWY/sLt8O1TL+sFcj+hxJETouuuFrovgdEbtXDx3B
 y1KhiFZYD5Z0i95CB91yQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ktVCnu8m0bc=:7lIhCNMs7urV0JKv+7F3DE
 NNp9R8hC9ytyyA9eZaSFYN0GSAwrVGH1U/8ZcgcaYutoXlWYB8hSG6zBXUJ8v9hwpr+8AtZBa
 fDqBX1v38uRfdZmTqM7+JTaz+p0e3+QO6VcEp3OVRCM9yvuEoXo6CcjLKX1ZrbeIPA4qogtqi
 koaQ/hfMNjqvWktmcJg5FXC+e9kpgI5kJ+N+Av/++JR0UL3l+ArmPjbS/q2XbwmGAjroyMbWq
 79Rvg3v9s8jZcHt3bz13PsTz8ltsPhblCveMjvbCmlrD9wHJQokEN1emDFRamt2PhWL1nC6G3
 REyegH1yc5SQqVVwkBxQLingWemLsTu72T4uyhS6HlpBlBbCEJVQvNXItlJMbX6dQu+MuBCqA
 xF6kwS6FJ4U5mLRHUQDwJ4v/NSGBlfclmhF/8SVFtH4g5o0D4qrWmVH/H2dQ75qrg6dGJ2abj
 fu+HAk6ZX62DAXYZhWCCxNtJ41pH2jFKjQ5VQrAhxtlcQENVAO18VIYVZRQxTZ5Xlij+6FJ5U
 b7Ui7gj20AuiGhAVIeIGInnO2JkkqQus/f7+fkx00yEnFKMoeUzzN+k/ia4mTtu0W2oCWI8mu
 6zLuK0xTZ4r+Xef8cUw5xj7zpO3QamPe3yk6PsIPhFh2umLo/EnB+OScg2GXDXshRTdb+Nqug
 KqAZToSCKBwHqnC8Nkly9MNHbuvfxd2OFnP/Q3Khovi155Kb74yxC4BGkDXKaSMtFvd83YjTy
 R/JQ/UGqc33CtX52DqkoqANb9dkaiT+bwHSkCr9GMOE3AmTkuhT6Vks9gjQmasxhnd/jcZkX8
 15AFG2Lpp7nHBSocKuDh+i5C4jByLoLBkNJxafHU+7WDGbXpnj6XZhWBp6MZCRaeVV6r6kHSy
 r780Z/h5DVsKwssSFuJ5VZPCEhnrHPp9RQUm+L5UNJ3nw60O9FCiovvEsIAD5T
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--u42MJZRqipcN99wcEdEFZM5hR0v8pesAv
Content-Type: multipart/mixed; boundary="BAkLnErq4wIjEgrNJFIdi8OV5K1yBEKgD";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
Message-ID: <afb5d89f-e1f9-351e-c789-ac291649d17b@gmx.com>
Subject: Re: [PATCH] Btrfs: fix unexpected failure of nocow buffered writes
 after snapshotting when low on space
References: <1533522630-21758-1-git-send-email-robbieko@synology.com>
In-Reply-To: <1533522630-21758-1-git-send-email-robbieko@synology.com>

--BAkLnErq4wIjEgrNJFIdi8OV5K1yBEKgD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/8/6 =E4=B8=8A=E5=8D=8810:30, robbieko wrote:
> From: Robbie Ko <robbieko@synology.com>
>=20
> Commit e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
> forced nocow writes to fallback to COW, during writeback,
> when a snapshot is created. This resulted in writes made before
> creating the snapshot to unexpectedly fail with ENOSPC during
> writeback when success (0) was returned to user space through
> the write system call.
>=20
> The steps leading to this problem are:
>=20
> 1. When it's not possible to allocate data space for a write,
> the buffered write path checks if a NOCOW write is possible.
> If it is, it will not reserve space and success (0) is returned
> to user space.
>=20
> 2. Then when a snapshot is created, the root's will_be_snapshotted
> atomic is incremented and writeback is triggered for all inode's
> that belong to the root being snapshotted. Incrementing that atomic
> forces all previous writes to fallback to COW during writeback
> (running delalloc).
>=20
> 3. This results in the writeback for the inodes to fail and therefore
> setting the ENOSPC error in their mappings, so that a subsequent fsync
> on them will report the error to user space. So it's not a completely
> silent data loss (since fsync will report ENOSPC) but it's a very
> unexpected and undesirable behaviour, because if a clean
> shutdown/unmount of the filesystem happens without previous calls to
> fsync, it is expected to have the data present in the files after
> mounting the filesystem again.
>=20
> So fix this by adding a new atomic named snapshot_force_cow to the
> root structure which prevents this behaviour and works the following wa=
y:

This fix is a little out of dated now.

Since 609e804d771f ("Btrfs: fix file corruption after snapshotting due
to mix of buffered/DIO writes") we will write back all dirty
inodes/pages back to disk before snapshot.

This makes sure that all dirty inodes/pages before a transaction will
reach disk before snapshot  subvolume is created.

Thus the whole will_be_snapshotted member no long makes sense, and in
fact it could cause more problem if we're going back to always check
NODATACOW at buffered write time.

Can we just revert this patch and the will_be_snapshotted member ?

Thanks,
Qu

>=20
> 1. It is incremented when we start to create a snapshot after
> triggering writeback and before waiting for writeback to finish.
>=20
> 2. This new atomic is now what is used by writeback (running delalloc)
> to decide whether we need to fallback to COW or not. Because we
> incremented this new atomic after triggering writeback in the snapshot
> creation ioctl, we ensure that all buffered writes that happened
> before snapshot creation will succeed and not fallback to COW
> (which would make them fail with ENOSPC).
>=20
> 3. The existing atomic, will_be_snapshotted, is kept because it is
> used to force new buffered writes, that start after we started
> snapshotting, to reserve data space even when NOCOW is possible.
> This makes these writes fail early with ENOSPC when there's no
> available space to allocate, preventing the unexpected behaviour
> of writeback later failing with ENOSPC due to a fallback to COW mode.
>=20
> Fixes: e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
> Signed-off-by: Robbie Ko <robbieko@synology.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/ctree.h   |  1 +
>  fs/btrfs/disk-io.c |  1 +
>  fs/btrfs/inode.c   | 26 +++++---------------------
>  fs/btrfs/ioctl.c   | 16 ++++++++++++++++
>  4 files changed, 23 insertions(+), 21 deletions(-)
>=20
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 118346a..663ce05 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1277,6 +1277,7 @@ struct btrfs_root {
>  	int send_in_progress;
>  	struct btrfs_subvolume_writers *subv_writers;
>  	atomic_t will_be_snapshotted;
> +	atomic_t snapshot_force_cow;
> =20
>  	/* For qgroup metadata reserved space */
>  	spinlock_t qgroup_meta_rsv_lock;
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 205092d..5573916 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1216,6 +1216,7 @@ static void __setup_root(struct btrfs_root *root,=
 struct btrfs_fs_info *fs_info,
>  	atomic_set(&root->log_batch, 0);
>  	refcount_set(&root->refs, 1);
>  	atomic_set(&root->will_be_snapshotted, 0);
> +	atomic_set(&root->snapshot_force_cow, 0);
>  	root->log_transid =3D 0;
>  	root->log_transid_committed =3D -1;
>  	root->last_log_commit =3D 0;
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index eba61bc..263b852 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1275,7 +1275,7 @@ static noinline int run_delalloc_nocow(struct ino=
de *inode,
>  	u64 disk_num_bytes;
>  	u64 ram_bytes;
>  	int extent_type;
> -	int ret, err;
> +	int ret;
>  	int type;
>  	int nocow;
>  	int check_prev =3D 1;
> @@ -1407,11 +1407,9 @@ static noinline int run_delalloc_nocow(struct in=
ode *inode,
>  			 * if there are pending snapshots for this root,
>  			 * we fall into common COW way.
>  			 */
> -			if (!nolock) {
> -				err =3D btrfs_start_write_no_snapshotting(root);
> -				if (!err)
> -					goto out_check;
> -			}
> +			if (!nolock &&
> +				unlikely(atomic_read(&root->snapshot_force_cow)))
> +				goto out_check;
>  			/*
>  			 * force cow if csum exists in the range.
>  			 * this ensure that csum for a given extent are
> @@ -1420,9 +1418,6 @@ static noinline int run_delalloc_nocow(struct ino=
de *inode,
>  			ret =3D csum_exist_in_range(fs_info, disk_bytenr,
>  						  num_bytes);
>  			if (ret) {
> -				if (!nolock)
> -					btrfs_end_write_no_snapshotting(root);
> -
>  				/*
>  				 * ret could be -EIO if the above fails to read
>  				 * metadata.
> @@ -1435,11 +1430,8 @@ static noinline int run_delalloc_nocow(struct in=
ode *inode,
>  				WARN_ON_ONCE(nolock);
>  				goto out_check;
>  			}
> -			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr)) {
> -				if (!nolock)
> -					btrfs_end_write_no_snapshotting(root);
> +			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr))
>  				goto out_check;
> -			}
>  			nocow =3D 1;
>  		} else if (extent_type =3D=3D BTRFS_FILE_EXTENT_INLINE) {
>  			extent_end =3D found_key.offset +
> @@ -1453,8 +1445,6 @@ static noinline int run_delalloc_nocow(struct ino=
de *inode,
>  out_check:
>  		if (extent_end <=3D start) {
>  			path->slots[0]++;
> -			if (!nolock && nocow)
> -				btrfs_end_write_no_snapshotting(root);
>  			if (nocow)
>  				btrfs_dec_nocow_writers(fs_info, disk_bytenr);
>  			goto next_slot;
> @@ -1476,8 +1466,6 @@ static noinline int run_delalloc_nocow(struct ino=
de *inode,
>  					     end, page_started, nr_written, 1,
>  					     NULL);
>  			if (ret) {
> -				if (!nolock && nocow)
> -					btrfs_end_write_no_snapshotting(root);
>  				if (nocow)
>  					btrfs_dec_nocow_writers(fs_info,
>  								disk_bytenr);
> @@ -1497,8 +1485,6 @@ static noinline int run_delalloc_nocow(struct ino=
de *inode,
>  					  ram_bytes, BTRFS_COMPRESS_NONE,
>  					  BTRFS_ORDERED_PREALLOC);
>  			if (IS_ERR(em)) {
> -				if (!nolock && nocow)
> -					btrfs_end_write_no_snapshotting(root);
>  				if (nocow)
>  					btrfs_dec_nocow_writers(fs_info,
>  								disk_bytenr);
> @@ -1537,8 +1523,6 @@ static noinline int run_delalloc_nocow(struct ino=
de *inode,
>  					     EXTENT_CLEAR_DATA_RESV,
>  					     PAGE_UNLOCK | PAGE_SET_PRIVATE2);
> =20
> -		if (!nolock && nocow)
> -			btrfs_end_write_no_snapshotting(root);
>  		cur_offset =3D extent_end;
> =20
>  		/*
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b077544..331b495 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -761,6 +761,7 @@ static int create_snapshot(struct btrfs_root *root,=
 struct inode *dir,
>  	struct btrfs_pending_snapshot *pending_snapshot;
>  	struct btrfs_trans_handle *trans;
>  	int ret;
> +	bool snapshot_force_cow =3D false;
> =20
>  	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
>  		return -EINVAL;
> @@ -777,6 +778,11 @@ static int create_snapshot(struct btrfs_root *root=
, struct inode *dir,
>  		goto free_pending;
>  	}
> =20
> +	/*
> +	 * Force new buffered writes to reserve space even when NOCOW is
> +	 * possible. This is to avoid later writeback (running dealloc)
> +	 * to fallback to COW mode and unexpectedly fail with ENOSPC.
> +	 */
>  	atomic_inc(&root->will_be_snapshotted);
>  	smp_mb__after_atomic();
>  	/* wait for no snapshot writes */
> @@ -787,6 +793,14 @@ static int create_snapshot(struct btrfs_root *root=
, struct inode *dir,
>  	if (ret)
>  		goto dec_and_free;
> =20
> +	/*
> +	 * All previous writes have started writeback in NOCOW mode, so now
> +	 * we force future writes to fallback to COW mode during snapshot
> +	 * creation.
> +	 */
> +	atomic_inc(&root->snapshot_force_cow);
> +	snapshot_force_cow =3D true;
> +
>  	btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
> =20
>  	btrfs_init_block_rsv(&pending_snapshot->block_rsv,
> @@ -851,6 +865,8 @@ static int create_snapshot(struct btrfs_root *root,=
 struct inode *dir,
>  fail:
>  	btrfs_subvolume_release_metadata(fs_info, &pending_snapshot->block_rs=
v);
>  dec_and_free:
> +	if (snapshot_force_cow)
> +		atomic_dec(&root->snapshot_force_cow);
>  	if (atomic_dec_and_test(&root->will_be_snapshotted))
>  		wake_up_var(&root->will_be_snapshotted);
>  free_pending:
>=20


--BAkLnErq4wIjEgrNJFIdi8OV5K1yBEKgD--

--u42MJZRqipcN99wcEdEFZM5hR0v8pesAv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlzBffgACgkQwj2R86El
/qhrgQf/SsGlP76kbuJ1A8ESI83O8OCIDk+CLbqOKlLwMB59BNiALPjJGmcBrXc4
SBLUxurGxJ3DR2qxNIMdpwqJtYP7nawgNopk6srtx5zVLmoQwZ1652cU/kBgYSPp
/GM5aw2Jjd98Xlly+RuA8EdVOvY+MAohrzws/gXQKL7PS3h5MqkI9gfY0b4CKkbi
L6Mk7EXhcWrP1dTEfs+DNySKaDnT05m6aKRswr4mUAJnmQkhgKlWVtXCgoqN1uzN
UTsRBqyZIZA5nnTKfF+OuPrXpKpISG0WXAN9dlBKKCTjMTDQkl42Q1C6y7GEBbQe
1bNat1/q/nR402gAK0BeiDZ2CdlDVw==
=rQtf
-----END PGP SIGNATURE-----

--u42MJZRqipcN99wcEdEFZM5hR0v8pesAv--
