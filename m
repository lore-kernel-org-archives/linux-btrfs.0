Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAD9C10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6349206BA
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:08:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="gNZZT8iT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbfDYKIN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 06:08:13 -0400
Received: from mout.gmx.net ([212.227.17.22]:46895 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfDYKIN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 06:08:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556186878;
        bh=PIL0ZzOcXb41o0ZeRRbA0eWi6NeFbEDrbr9J+Wjo564=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=gNZZT8iTuKLgMxc3jNnNrK/ddmoLwjfmto0J6Z7FiM0meXCChuBPK97KycHYSkp4I
         z7wL/R7Y0/rsCgzkLZFESBEQy/0STNs2fsvGpOblwN/syuH2TqVQRX1kC8fgT6Uu58
         zmxC4tW8YmAlJWBKdNdkylU/2t58e2ZpFZz/T7Fc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MgoiC-1h6UFp0kEq-00M66k; Thu, 25
 Apr 2019 12:07:58 +0200
Subject: Re: [PATCH] Btrfs: fix unexpected failure of nocow buffered writes
 after snapshotting when low on space
To:     Nikolay Borisov <nborisov@suse.com>,
        robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>
References: <1533522630-21758-1-git-send-email-robbieko@synology.com>
 <afb5d89f-e1f9-351e-c789-ac291649d17b@gmx.com>
 <06b5b693-8017-7ec0-b17a-c723291f00c7@suse.com>
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
Message-ID: <950b2924-9edd-d9d7-ace0-bc3e2ab07a6a@gmx.com>
Date:   Thu, 25 Apr 2019 18:07:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <06b5b693-8017-7ec0-b17a-c723291f00c7@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SjA1+PZ4BbRwtTh5T7BbyJEl5P1TuN6U/bOxqMQ1RDf9IuQ2Xj8
 Ubm15vUcnlLqeH5KXapmenJyrAt28FdU73KtO8ljdCwpRBvc0hGYlBAKdNCnA5Tq88fpqzm
 uxE+cXrqD58RGmm2/v4ptHC6BQrY0dTjyTM09Br4cURtKgnToWRowF8tDuQ9SmWZHAuOosi
 Ihl1+xZoDzvodHTC7YEVA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:a3iy7PTEXhM=:8piXoA1pxEUaUXmscU31tj
 wxA7teaFKwrdV5oAIc64l3hpXBVXT0xinhNLb/KMJSEBmEufljpUgTlTrLdEG6MbnHwcVo9ca
 Pe7IYjozUWr6CyFYysvxfGbtWqzwQKd8ecSR5SNXV4p2FqBMlC09/zl4cM4GpzWGHe2r1MuGH
 tXaQOUNsnLD7UlESoRGZgrOAiW8JWoBrzjctQnW7Yu4CEYJ3iHZ9o2lW6odOmm3L5KHCNkpNF
 aKeQdpgrXDEIGz/2naYs1I8gi8k+sToUI4aS9tBIMDexKoBGVgUtRJ1CqWPLZyhkecjQxC61k
 wyWymtjLxRnWk9HUClsk5KASJudlQn9+mqRVHg+wNAohJnXvFEndCJcLAaZ2/yAyxZ13dAPfI
 pR6URCvS8jnDm9OkvceiAVSb9rwkNaAH2IOtchHLpdZZieL6QDu3WbSCCFvCx2tVyB17IHVL8
 d6umuM5s6C1te2C/ZdVfTBuF47IEeznJZd9Wbc8G8f1UQlYVY3HqErXWhigGExgdKvvY0JiGZ
 mVwETssPgx9O9OaXfrgENrswIYAXQnA6JWjYhQJ/WcHNqqmXN9qRTdICOTn9sXaXapU0tNr8R
 GKs5YqQ/Vv3lBPbknGeVaCcdwGqff2/a4gynrRLf05+SHvOSUTlQ0oG9YaMmIZgERTsSEg/kn
 WLHEdgcXbVUKYMp4qyiH/czSDZRgNjPKzoWX3ychCNTd85z6TtUtPg/FVO5ufKb3Q1wyHUyE5
 7/vHrWvHuGBIzKuyWrYe8I7YJUrgeIF5SnStETgUEvm4j7OXDpdipxg3G8wITWjgzxzDQp9VC
 qWkFTwaZ79RPM0UaPihseHo37BFf3ps3QxUa35LSklrivsQ92D9Dh5gZvQBHhmQok/QmTa2SN
 0yurRGjhD30HqI303k4BEk1Gc5KGbIVrxjFXepkJDHIiVdPllcjUhls0X4tu6xeT3D30wHvRP
 Wv58eUoeDIw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/25 =E4=B8=8B=E5=8D=885:37, Nikolay Borisov wrote:
>
>
> On 25.04.19 =D0=B3. 12:29 =D1=87., Qu Wenruo wrote:
>>
>>
>> On 2018/8/6 =E4=B8=8A=E5=8D=8810:30, robbieko wrote:
>>> From: Robbie Ko <robbieko@synology.com>
>>>
>>> Commit e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
>>> forced nocow writes to fallback to COW, during writeback,
>>> when a snapshot is created. This resulted in writes made before
>>> creating the snapshot to unexpectedly fail with ENOSPC during
>>> writeback when success (0) was returned to user space through
>>> the write system call.
>>>
>>> The steps leading to this problem are:
>>>
>>> 1. When it's not possible to allocate data space for a write,
>>> the buffered write path checks if a NOCOW write is possible.
>>> If it is, it will not reserve space and success (0) is returned
>>> to user space.
>>>
>>> 2. Then when a snapshot is created, the root's will_be_snapshotted
>>> atomic is incremented and writeback is triggered for all inode's
>>> that belong to the root being snapshotted. Incrementing that atomic
>>> forces all previous writes to fallback to COW during writeback
>>> (running delalloc).
>>>
>>> 3. This results in the writeback for the inodes to fail and therefore
>>> setting the ENOSPC error in their mappings, so that a subsequent fsync
>>> on them will report the error to user space. So it's not a completely
>>> silent data loss (since fsync will report ENOSPC) but it's a very
>>> unexpected and undesirable behaviour, because if a clean
>>> shutdown/unmount of the filesystem happens without previous calls to
>>> fsync, it is expected to have the data present in the files after
>>> mounting the filesystem again.
>>>
>>> So fix this by adding a new atomic named snapshot_force_cow to the
>>> root structure which prevents this behaviour and works the following w=
ay:
>>
>> This fix is a little out of dated now.
>>
>> Since 609e804d771f ("Btrfs: fix file corruption after snapshotting due
>> to mix of buffered/DIO writes") we will write back all dirty
>> inodes/pages back to disk before snapshot.
>>
>> This makes sure that all dirty inodes/pages before a transaction will
>> reach disk before snapshot  subvolume is created.
>>
>> Thus the whole will_be_snapshotted member no long makes sense, and in
>> fact it could cause more problem if we're going back to always check
>> NODATACOW at buffered write time.
>>
>> Can we just revert this patch and the will_be_snapshotted member ?
>
> I'm very much in favor of removing the whole will_be_snapshotted
> mechanism. In fact I have a series which replaces it with a rwsem
> essentially:
>
> 1. Serializing snapshots (acquiring write-side of the semaphore)

With the new btrfs_start_delalloc_snapshot() in
btrfs_commit_transaction(), do we really need to do anything special now?

Snapshot creation will only happen in btrfs_commit_transaction(), as
long as all dirty inodes/pages are written before pending snapshots,
we're completely fine.

Or did I miss something?

Thanks,
Qu

>
> 2. Nocow writers simply acquire the readsize of the semaphore.
>
> the will_be_snapshoted thing is very convoluted relying on a percpu
> counter/waitqueue  to exclude snapshots from pending nocow writers. OTOH
> it depends on atomic_t and an implicit wait queue thanks to wait_var
> infrastructure to exclude nocow writers from pending snapshots. Filipe
> had some concerns regarding performance but if the patch you mentioned
> fixed all issues I'm all in favor of removing the code!
>
>
>>
>> Thanks,
>> Qu
>>
>>>
>>> 1. It is incremented when we start to create a snapshot after
>>> triggering writeback and before waiting for writeback to finish.
>>>
>>> 2. This new atomic is now what is used by writeback (running delalloc)
>>> to decide whether we need to fallback to COW or not. Because we
>>> incremented this new atomic after triggering writeback in the snapshot
>>> creation ioctl, we ensure that all buffered writes that happened
>>> before snapshot creation will succeed and not fallback to COW
>>> (which would make them fail with ENOSPC).
>>>
>>> 3. The existing atomic, will_be_snapshotted, is kept because it is
>>> used to force new buffered writes, that start after we started
>>> snapshotting, to reserve data space even when NOCOW is possible.
>>> This makes these writes fail early with ENOSPC when there's no
>>> available space to allocate, preventing the unexpected behaviour
>>> of writeback later failing with ENOSPC due to a fallback to COW mode.
>>>
>>> Fixes: e9894fd3e3b3 ("Btrfs: fix snapshot vs nocow writting")
>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>>> Reviewed-by: Filipe Manana <fdmanana@suse.com>
>>> ---
>>>  fs/btrfs/ctree.h   |  1 +
>>>  fs/btrfs/disk-io.c |  1 +
>>>  fs/btrfs/inode.c   | 26 +++++---------------------
>>>  fs/btrfs/ioctl.c   | 16 ++++++++++++++++
>>>  4 files changed, 23 insertions(+), 21 deletions(-)
>>>
>>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>>> index 118346a..663ce05 100644
>>> --- a/fs/btrfs/ctree.h
>>> +++ b/fs/btrfs/ctree.h
>>> @@ -1277,6 +1277,7 @@ struct btrfs_root {
>>>  	int send_in_progress;
>>>  	struct btrfs_subvolume_writers *subv_writers;
>>>  	atomic_t will_be_snapshotted;
>>> +	atomic_t snapshot_force_cow;
>>>
>>>  	/* For qgroup metadata reserved space */
>>>  	spinlock_t qgroup_meta_rsv_lock;
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index 205092d..5573916 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -1216,6 +1216,7 @@ static void __setup_root(struct btrfs_root *root=
, struct btrfs_fs_info *fs_info,
>>>  	atomic_set(&root->log_batch, 0);
>>>  	refcount_set(&root->refs, 1);
>>>  	atomic_set(&root->will_be_snapshotted, 0);
>>> +	atomic_set(&root->snapshot_force_cow, 0);
>>>  	root->log_transid =3D 0;
>>>  	root->log_transid_committed =3D -1;
>>>  	root->last_log_commit =3D 0;
>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>> index eba61bc..263b852 100644
>>> --- a/fs/btrfs/inode.c
>>> +++ b/fs/btrfs/inode.c
>>> @@ -1275,7 +1275,7 @@ static noinline int run_delalloc_nocow(struct in=
ode *inode,
>>>  	u64 disk_num_bytes;
>>>  	u64 ram_bytes;
>>>  	int extent_type;
>>> -	int ret, err;
>>> +	int ret;
>>>  	int type;
>>>  	int nocow;
>>>  	int check_prev =3D 1;
>>> @@ -1407,11 +1407,9 @@ static noinline int run_delalloc_nocow(struct i=
node *inode,
>>>  			 * if there are pending snapshots for this root,
>>>  			 * we fall into common COW way.
>>>  			 */
>>> -			if (!nolock) {
>>> -				err =3D btrfs_start_write_no_snapshotting(root);
>>> -				if (!err)
>>> -					goto out_check;
>>> -			}
>>> +			if (!nolock &&
>>> +				unlikely(atomic_read(&root->snapshot_force_cow)))
>>> +				goto out_check;
>>>  			/*
>>>  			 * force cow if csum exists in the range.
>>>  			 * this ensure that csum for a given extent are
>>> @@ -1420,9 +1418,6 @@ static noinline int run_delalloc_nocow(struct in=
ode *inode,
>>>  			ret =3D csum_exist_in_range(fs_info, disk_bytenr,
>>>  						  num_bytes);
>>>  			if (ret) {
>>> -				if (!nolock)
>>> -					btrfs_end_write_no_snapshotting(root);
>>> -
>>>  				/*
>>>  				 * ret could be -EIO if the above fails to read
>>>  				 * metadata.
>>> @@ -1435,11 +1430,8 @@ static noinline int run_delalloc_nocow(struct i=
node *inode,
>>>  				WARN_ON_ONCE(nolock);
>>>  				goto out_check;
>>>  			}
>>> -			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr)) {
>>> -				if (!nolock)
>>> -					btrfs_end_write_no_snapshotting(root);
>>> +			if (!btrfs_inc_nocow_writers(fs_info, disk_bytenr))
>>>  				goto out_check;
>>> -			}
>>>  			nocow =3D 1;
>>>  		} else if (extent_type =3D=3D BTRFS_FILE_EXTENT_INLINE) {
>>>  			extent_end =3D found_key.offset +
>>> @@ -1453,8 +1445,6 @@ static noinline int run_delalloc_nocow(struct in=
ode *inode,
>>>  out_check:
>>>  		if (extent_end <=3D start) {
>>>  			path->slots[0]++;
>>> -			if (!nolock && nocow)
>>> -				btrfs_end_write_no_snapshotting(root);
>>>  			if (nocow)
>>>  				btrfs_dec_nocow_writers(fs_info, disk_bytenr);
>>>  			goto next_slot;
>>> @@ -1476,8 +1466,6 @@ static noinline int run_delalloc_nocow(struct in=
ode *inode,
>>>  					     end, page_started, nr_written, 1,
>>>  					     NULL);
>>>  			if (ret) {
>>> -				if (!nolock && nocow)
>>> -					btrfs_end_write_no_snapshotting(root);
>>>  				if (nocow)
>>>  					btrfs_dec_nocow_writers(fs_info,
>>>  								disk_bytenr);
>>> @@ -1497,8 +1485,6 @@ static noinline int run_delalloc_nocow(struct in=
ode *inode,
>>>  					  ram_bytes, BTRFS_COMPRESS_NONE,
>>>  					  BTRFS_ORDERED_PREALLOC);
>>>  			if (IS_ERR(em)) {
>>> -				if (!nolock && nocow)
>>> -					btrfs_end_write_no_snapshotting(root);
>>>  				if (nocow)
>>>  					btrfs_dec_nocow_writers(fs_info,
>>>  								disk_bytenr);
>>> @@ -1537,8 +1523,6 @@ static noinline int run_delalloc_nocow(struct in=
ode *inode,
>>>  					     EXTENT_CLEAR_DATA_RESV,
>>>  					     PAGE_UNLOCK | PAGE_SET_PRIVATE2);
>>>
>>> -		if (!nolock && nocow)
>>> -			btrfs_end_write_no_snapshotting(root);
>>>  		cur_offset =3D extent_end;
>>>
>>>  		/*
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index b077544..331b495 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -761,6 +761,7 @@ static int create_snapshot(struct btrfs_root *root=
, struct inode *dir,
>>>  	struct btrfs_pending_snapshot *pending_snapshot;
>>>  	struct btrfs_trans_handle *trans;
>>>  	int ret;
>>> +	bool snapshot_force_cow =3D false;
>>>
>>>  	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
>>>  		return -EINVAL;
>>> @@ -777,6 +778,11 @@ static int create_snapshot(struct btrfs_root *roo=
t, struct inode *dir,
>>>  		goto free_pending;
>>>  	}
>>>
>>> +	/*
>>> +	 * Force new buffered writes to reserve space even when NOCOW is
>>> +	 * possible. This is to avoid later writeback (running dealloc)
>>> +	 * to fallback to COW mode and unexpectedly fail with ENOSPC.
>>> +	 */
>>>  	atomic_inc(&root->will_be_snapshotted);
>>>  	smp_mb__after_atomic();
>>>  	/* wait for no snapshot writes */
>>> @@ -787,6 +793,14 @@ static int create_snapshot(struct btrfs_root *roo=
t, struct inode *dir,
>>>  	if (ret)
>>>  		goto dec_and_free;
>>>
>>> +	/*
>>> +	 * All previous writes have started writeback in NOCOW mode, so now
>>> +	 * we force future writes to fallback to COW mode during snapshot
>>> +	 * creation.
>>> +	 */
>>> +	atomic_inc(&root->snapshot_force_cow);
>>> +	snapshot_force_cow =3D true;
>>> +
>>>  	btrfs_wait_ordered_extents(root, U64_MAX, 0, (u64)-1);
>>>
>>>  	btrfs_init_block_rsv(&pending_snapshot->block_rsv,
>>> @@ -851,6 +865,8 @@ static int create_snapshot(struct btrfs_root *root=
, struct inode *dir,
>>>  fail:
>>>  	btrfs_subvolume_release_metadata(fs_info, &pending_snapshot->block_r=
sv);
>>>  dec_and_free:
>>> +	if (snapshot_force_cow)
>>> +		atomic_dec(&root->snapshot_force_cow);
>>>  	if (atomic_dec_and_test(&root->will_be_snapshotted))
>>>  		wake_up_var(&root->will_be_snapshotted);
>>>  free_pending:
>>>
>>
