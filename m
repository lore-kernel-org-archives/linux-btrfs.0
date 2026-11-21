Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795295365;
	b=M5B8enSTBmFUCxYQNtJBg2sVZKFhhQJBNybLf6JQJmnHOXkS1+5UuLF97FOuPtOP3l57
	 d7Pp/bz0MSlql+kqUvkJidGGClm2XjzB3nn8HZiYhy9DX8seW59vVRMiebLL3AROfkgjG
	 RbhncP1wb0tFGCFC/SzEjRy1sasyK/uZhqgC2FewT8GpzLPH4zZCf098xgNeuGUvUx9PQ
	 tEYtz1SmLZi8MGlDqNMLStXVWBZKtlr2dbRCE6GAKgzVi4t047JdenWJ6vlBgcDPz9d4P
	 fUhYT4deFvlU/us2Bix/rmYHJUHLB9BIlHJ4ek3M9rootPZIZuLi+H/p5UH0qwFNg2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795295365;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=9faj9D/B0BsEMSd9HOE18xmvHGSzdgXWKqlq/2YLRL4=;
	b=ATOHUmDmIsQheA90FqEJweis99eZSDBAeNg7DrmiDFIN4qe+6sfrTjVIkqE7urX7O3Tq
	 G7f/UrQ1+dDf4EKur+AcOky5WJcJtH+CS05ugDcXrz3ZgLNpEXaSQ3ZLQ1aLF/16oXtNj
	 Nlq6bSV5yB85oYXGkEms3Fi8LlpGDIuigWk/JUSD7BPEMlgHu9c5FN9s+iy7W5XET3+q8
	 ZYnw84+kmTIqQje19IMXZkPA3RaWxbT/8QaLzuNIjnkTfFNOWrdbrvfe0aCeyfxq9ZtkB
	 n5gq5i1aQbt1yFySUe3yZLV6bw5BCtUFDiSqgyYaMKpvZQ9DkJGOSnanrdzG+e9DJrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=oIVcR+At;
	arc=none smtp.remote-ip=212.227.17.20
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9621C606A331
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2026 21:09:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9621C606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=oIVcR+At
DKIM2-Signature:  i=1; m=1; t=1795295362;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:fMifUtn7XlGLb6ZKdRqu7L5XHqyp
   1aOeM+1EfvqeZj7bZ6ZKmaVJIcZq5rtLExcw+LVD3eoRbIWBDj7mxUx7Fn93vuemuAjY6ZoyfH3
   jBhobzF/CzUHNPGh2HVCO6bvJzjmMUHIOoWMm8zuAIE4XHxS3K1xd55OGjpVxEnZw1qGyqoL5KT
   mgiPFAe98BNujPWmwn1QN63LdLjlD/C6n5YtqxcWUhLkA5pbA2+KL1jepACdr2+oPmuaEM+QSEq
   5QT9HTXCAsFdeh10p729dveiFhh+DGZ5A/OOtIWY1f1HA2j59kvFE6H7LZ60XcvMEXv38zw/Rtd
   bRVJgb+PvnsEBA==;
Message-Instance:  m=1;
 h=sha256:
   a/5gKxafea16CPbsXpUuokFyDfbigqBFUY9az8pGkdE=:
   hkAxSGeMWu0y87vuZP6pEgYmY3L7xKltacH0yQxoJLA=,
  sha512:
   yTuR9ajtCn+ySK+2QrDc2R1ILkcWYOd49sD+f1Cys0wu/cctWX3OD4ppBnBtyiXFSRLtFhOLqlMprUdl3hRW3g==:
   s8fLsLa9IRgeX2sxcLnXNshxLxlMbMDFxJpwZdUxITwStQ112R/kPXCAbJOlWRccIA0PZvY7Dq6t1nLWrYWnng==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795295351; x=1795900151; i=quwenruo.btrfs@gmx.com;
	bh=9faj9D/B0BsEMSd9HOE18xmvHGSzdgXWKqlq/2YLRL4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=oIVcR+AtJORePUv7EVKecf02lPaH4vY6heXh0xjnc81h9qNPkiL7axrb3pH3QAjD
	 9wSvqbow4+EHli35aCHdtGb51bTmaE1TeNH4Zh09zdwyUwNHhJ6+xppi0XTHNVaSh
	 Qd4KILPCENHlIPdR8ZtYjGArBvj7oSDwVxoexOySoZihFIsLPsVD+1WPwpkaVL2TZ
	 XomsaIntbuheGSbvCcTkcGNiau/QaqDTeQuJuQS8veRMBB4pSVmDKI+dVaVOlmqYr
	 xkLkehOAiZ8a2rDTRtHu6pXrGbgMHhPLE6l0dbJjKkDaqZggoF3Sdni/1EUgsSvUy
	 UWCv1p2ROmEQPGD/xA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MD9T7-1xdz8R0t9N-00A6SC; Sat, 21
 Nov 2026 22:09:10 +0100
Message-ID: <4aa0cdbf-98a4-4d44-887e-3924cd075c27@gmx.com>
Date: Sun, 22 Nov 2026 07:39:04 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] btrfs: wait for ordered extent IO in fast fsync
To: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>,
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261120-b4-btrfs-data-integrity-v3-0-4de4b91b826e@toxicpanda.com>
 <20261120-b4-btrfs-data-integrity-v3-4-4de4b91b826e@toxicpanda.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7o8gUJFKS8
 OQAKCRDCPZHzoSX+qAogB/9C5ErH7KGAGpcLPte3Wcfdt3acCkGAuMpCjqOt8BVw30mX0kmF
 SRo2nODjz8YsYhWR1T8L3ylANAS/IGIJ64idBmObaqGHQn845nXLIvG33LqMsAGXmOJdRgTT
 BnBA+QFCEIZpo7L9Qt1dOQdHSpHT31Ta1kKsbDm582KPVBl6KRcJJBnjudIerOA1/L/zEyDa
 YjIfHIcvuM3Xm8AS00iBpsmc151QgCPljqnSRXBiup9C1oMgVlaROhY1iDam4UIQB6glkHQs
 LZhUmFDNimX5LxfOzi2pFJSjJvPclRZVX7Sq6XhK/OFb6IvswN7i0nUYZMQfuGDNqGn70ic3
 AQImzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCat7pCgUJFMw7KQAK
 CRDCPZHzoSX+qEjbB/9crFFjips2NKxkt2XUutUIKjBoUlg/xCeFIj8PsTuJePhrV9HzgKsa
 rJgSqo3t78oQWmeaP9WPoDYjfhOkQXEs+G9UwHe/LENm70+Q1jrwY3nlcR3YrkDCJ+EvMZOW
 ackgcOYn46Iri9DN91FbSTszPMnwHi/nf0aeJXicO9krrY5C8mUxv4CSKeKSRg/5BR59uDiy
 9CMRHDtIDnpDWaLOXtUeowCdiC5O/jA571PMFx3Aolc7g4SSyNbYodblCBOdJrh0CVm2LlQW
 3SXrvFpSAw7LMVDgsS8pTRt4A11eTIS7mz0zqafTohXP1wt+575IBHK5ZpThQb+PzSQmxAqa
In-Reply-To: <20261120-b4-btrfs-data-integrity-v3-4-4de4b91b826e@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:dM5QtWiI7iSfhwJ4gPsOxjV45iAN93vFi9vAEzSCC2G+pUiou5A
 HXUT6yACPr3xDAPzzGuzCkWSMnddBBnUXaAcSV8uD6wVAgBWDpzIN4onYWompayJjbPIDcb
 JqrYWxrL96rbOI7obmLGtPpz/8DW5VzvhPxMJuhhA1M+J6yDDYfJ3sEXXM+3jxdp8EfjCM4
 9ArUU4c1vMqhjTUyRjlQg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:1Y0pb07OaN8=;WOXjb6VsTxQhAn839c/1pMa3Mp9
 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
 jFAwZ99rsGRiwhehnw==



=E5=9C=A8 2026/11/21 07:21, Josef Bacik =E5=86=99=E9=81=93:
> A fast fsync waits for writeback and then checks whether a write failed
> or was truncated, in which case it waits for the ordered extents to
> complete. The check can come too early, because end_bbio_data_write()
> clears writeback before it finishes the ordered extent, which is where
> a failure is recorded:
>=20
>    end_bbio_data_write()            fsync
>=20
>    btrfs_folio_clear_writeback()
>                                     filemap_fdatawait_range()
>                                     BTRFS_INODE_INCOMPLETE_COW_WRITE cle=
ar
>                                     btrfs_log_changed_extents()
>    btrfs_finish_ordered_extent()
>      set BTRFS_INODE_INCOMPLETE_COW_WRITE
>=20
> A direct IO write has no writeback for the fsync to wait for at all, so
> the failure of an asynchronous direct IO write still in flight is missed
> too.
>=20
> The buffered case comes from commit a11d6912fdd9 ("btrfs: remove folio
> parameter from ordered io related functions"), which moved the call to
> btrfs_finish_ordered_extent() after the loop that clears writeback. The
> direct IO case has been there since commit f13e01b89daf ("btrfs: ensure
> fast fsync waits for ordered extents after a write failure") added the
> flag.
>=20
> Fix by having a fast fsync wait for BTRFS_ORDERED_IO_DONE on the ordered
> extents it collected for logging before it checks. Since "btrfs: make
> fsync wait for all incomplete COW writes", a failure or truncation is
> recorded before that bit is set, and a barrier in
> can_finish_ordered_extent() now orders the two, pairing with the fully
> ordered test_and_clear_bit() of the flag in fsync. For a buffered write
> the bit is set right after writeback is cleared. The writeback of a
> buffered write that is not done yet is started first, and fsync returns
> the error if that fails, since the rest of the ordered extent may then
> not be submitted.
>=20
> This depends on "btrfs: make fsync wait for all incomplete COW writes".
>=20
> Fixes: a11d6912fdd9 ("btrfs: remove folio parameter from ordered io rela=
ted functions")
> Fixes: f13e01b89daf ("btrfs: ensure fast fsync waits for ordered extents=
 after a write failure")
> CC: stable@vger.kernel.org # 6.10+
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

This also fixes a potential race with async data csum generation from=20
experimental features, where a data write bio can be submitted but=20
without its csum generated.

Without the wait, fast fsync can log the OE without unpopulated csum and=
=20
after a power loss, the unpopulated csum will be inserted and cause=20
future csum mismatch.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/file.c         | 67 ++++++++++++++++++++++++++++++++++++++++-=
=2D-------
>   fs/btrfs/ordered-data.c |  6 +++++
>   2 files changed, 61 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 4208587abff1..ee09c4ecbd4c 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1512,8 +1512,8 @@ static inline bool skip_inode_logging(const struct=
 btrfs_log_ctx *ctx)
>   	 * If we are doing a fast fsync we can not bail out if the inode's
>   	 * last_trans is <=3D then the last committed transaction, because we=
 only
>   	 * update the last_trans of the inode during ordered extent completio=
n,
> -	 * and for a fast fsync we don't wait for that, we only wait for the
> -	 * writeback to complete.
> +	 * and for a fast fsync we don't wait for that, we only wait for the I=
O
> +	 * of the writes to complete.
>   	 */
>   	if (inode->last_trans <=3D btrfs_get_last_trans_committed(fs_info) &&
>   	    (test_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &inode->runtime_flags) ||
> @@ -1523,6 +1523,41 @@ static inline bool skip_inode_logging(const struc=
t btrfs_log_ctx *ctx)
>   	return false;
>   }
>  =20
> +/*
> + * Wait for the IO of the ordered extents collected for logging to be a=
ccounted,
> + * starting IO on the dirty folios of a buffered write that is not done=
 yet.
> + *
> + * Waiting for writeback is not enough: the end IO handler clears write=
back
> + * before it finishes the ordered extent, and a direct IO write has no
> + * writeback. A failed or truncated write sets BTRFS_INODE_INCOMPLETE_C=
OW_WRITE
> + * before BTRFS_ORDERED_IO_DONE is set, see can_finish_ordered_extent()=
.
> + *
> + * If starting IO fails, the rest of the ordered extent may never be su=
bmitted,
> + * so return the error instead of waiting.
> + */
> +static int wait_ordered_io_done(struct btrfs_inode *inode,
> +				struct list_head *ordered_extents)
> +{
> +	struct btrfs_ordered_extent *ordered;
> +	int ret;
> +
> +	list_for_each_entry(ordered, ordered_extents, log_list) {
> +		if (test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags))
> +			continue;
> +		if (!test_bit(BTRFS_ORDERED_DIRECT, &ordered->flags)) {
> +			ret =3D btrfs_fdatawrite_range(inode, ordered->file_offset,
> +						     ordered->file_offset +
> +						     ordered->num_bytes - 1);
> +			if (ret)
> +				return ret;
> +		}
> +		wait_event(ordered->wait,
> +			   test_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags));
> +	}
> +
> +	return 0;
> +}
> +
>   /*
>    * fsync call for both files and directories.  This logs the inode int=
o
>    * the tree log instead of forcing full commits whenever possible.
> @@ -1626,11 +1661,11 @@ int btrfs_sync_file(struct file *file, loff_t st=
art, loff_t end, int datasync)
>   	 * IO of a lower priority task while holding a transaction open.
>   	 *
>   	 * For a full fsync we wait for the ordered extents to complete while
> -	 * for a fast fsync we wait just for writeback to complete, and then
> -	 * attach the ordered extents to the transaction so that a transaction
> -	 * commit waits for their completion, to avoid data loss if we fsync,
> -	 * the current transaction commits before the ordered extents complete
> -	 * and a power failure happens right after that.
> +	 * for a fast fsync we wait just for the IO of the writes to complete,
> +	 * and then attach the ordered extents to the transaction so that a
> +	 * transaction commit waits for their completion, to avoid data loss i=
f
> +	 * we fsync, the current transaction commits before the ordered extent=
s
> +	 * complete and a power failure happens right after that.
>   	 *
>   	 * For zoned filesystem, if a write IO uses a ZONE_APPEND command, th=
e
>   	 * logical address recorded in the ordered extent may change. We need
> @@ -1650,13 +1685,21 @@ int btrfs_sync_file(struct file *file, loff_t st=
art, loff_t end, int datasync)
>   		if (ret)
>   			goto out_release_extents;
>  =20
> +		ret =3D wait_ordered_io_done(inode, &ctx.ordered_extents);
> +		if (ret)
> +			goto out_release_extents;
> +
>   		/*
>   		 * Check and clear BTRFS_INODE_INCOMPLETE_COW_WRITE now after
> -		 * starting and waiting for writeback, because it may have been
> -		 * set while we waited, and if a write failed or was truncated
> -		 * we need to wait for ordered extents to complete so that any
> -		 * extent maps that point to unwritten locations are dropped and
> -		 * we don't log them.
> +		 * waiting for the IO of the ordered extents, because it may
> +		 * have been set while we waited, and if a write failed or was
> +		 * truncated we need to wait for ordered extents to complete so
> +		 * that any extent maps that point to unwritten locations are
> +		 * dropped and we don't log them.
> +		 *
> +		 * test_and_clear_bit() is fully ordered, which pairs with the
> +		 * barrier before BTRFS_ORDERED_IO_DONE is set in
> +		 * can_finish_ordered_extent().
>   		 */
>   		if (test_and_clear_bit(BTRFS_INODE_INCOMPLETE_COW_WRITE, &inode->run=
time_flags))
>   			ret =3D btrfs_wait_ordered_range(inode, start, len);
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 1a4e3e34ec11..728e73baf15e 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -420,7 +420,13 @@ static bool can_finish_ordered_extent(struct btrfs_=
ordered_extent *ordered,
>   	/*
>   	 * All the IO of the ordered extent is finished, we need to queue
>   	 * the finish_func to be executed.
> +	 *
> +	 * Order BTRFS_INODE_INCOMPLETE_COW_WRITE, if set above, before
> +	 * BTRFS_ORDERED_IO_DONE, as a fast fsync tests the latter without
> +	 * the ordered_tree_lock. Pairs with the test_and_clear_bit() in
> +	 * btrfs_sync_file().
>   	 */
> +	smp_mb__before_atomic();
>   	set_bit(BTRFS_ORDERED_IO_DONE, &ordered->flags);
>   	cond_wake_up(&ordered->wait);
>   	refcount_inc(&ordered->refs);
>=20

