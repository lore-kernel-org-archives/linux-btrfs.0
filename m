Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.17.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795294815;
	b=cY11PI0FmA8iqosvxIER+uDXeOScl8ZgxQ3H8knDVv22pYc+awPPNdIH+Nv6uNDMZoSn
	 czoY7mJIdMofURQkLh3EI+wLrEyuE1vWCjdd8LyPzXo0pwH4tD4TlhWqeKWLnnH96mhht
	 3Uw3XMu6IYtWKC/S8ZXULnYSY8qDaG4eh4pi7OnWNgudZJGyx9lqv8v9VGLGi3qwZIaKO
	 05f+sTPih7tPEY2WLvgEyRAkycbURgn23fo9HyVfpcQn9TwCTRiyeiinWjTHe1nh6gV2X
	 6yYhZ3z75zfLDv3q2jHy3qaR7rypNzK+TdkfiJdTICwHDJe1xDsdQO4u5OdK4WDzpyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795294815;
	h=DMARC-Filter:DKIM2-Signature:Message-Instance:DKIM-Signature:
	 X-UI-Sender-Class:Received:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:
	 UI-OutboundReport;
	bh=tHDn2ySSVMB7ccjsJPwuxkW/ZChMFUVGUOKQM6uQrN8=;
	b=4TxzMOWy2rHUf7bquX7PpxFxsScZdwwUznTcQ6sVMTTxmkpeJLF412ZqvoKF6y8bin/h
	 8OPfriCCZQCB7l3moOyeZ05LG2GWkbk9G9aLJMnoIskL6S0Dm75TxRxd8XPuze5gGa2GG
	 DDH7cDY7vaDCHa8OA/eHBBlNCQmRfclaPNkZgFkWQtK7885Y+xk7Bnxkx2t9nY8hF6I3m
	 8tyGOFNRcc0Fu+WWR3ZsiHjb+wuUN6xW3UGe1TiEN4F3RUvUWKohWNp1GF10Gvz6GQZ8I
	 TD/5wYl6aAVocVjfO08hhicGUMyMs0t794uHWFurxvS6rTEz7Bjp6+3gIKflykIambA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmx.com;
	spf=pass smtp.mailfrom=gmx.com;
	dkim=pass header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=m+r1pQJU;
	arc=none smtp.remote-ip=212.227.17.21
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A92606A32A
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2026 21:00:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1A92606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.a=rsa-sha256 header.s=s31663417 header.b=m+r1pQJU
DKIM2-Signature:  i=1; m=1; t=1795294811;
 mf=PHF1d2VucnVvLmJ0cmZzQGdteC5jb20+;
 rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
 d=gmx.com;
 s=s31663417:rsa-sha256:pjf09ZYDTdgksbFMfOo+JPTVVqPa
   9YlN00fLzTzfe9U61rVrVCDW+mLuc0jNXG1oMRXIUD6Xidq4tVCH3r9sNFlJYdIdC1XWCxgg3n/
   ChyNeJ+sekF0QRaQ/sqYxC02Wd+cR3sHsvl1OFVbGBWlSfu0wjHSIy3xKdiQe0fDch2hI3Boa5w
   /ZjJK4xuNiIcWWLsdKJxhzGpOTVCyOrQQ2Dz/xKL/3A2pWKo8boz/zbRznVtXo5Tnx4AYr6PBS4
   oCGvfceK+DKOxFPtFYigNmksUQh8y7paSg2pSR3qPE/+XENiBFZAE6fcj1fblpiKN+5UkH0pS7P
   5mxr/GeJoo9kaw==;
Message-Instance:  m=1;
 h=sha256:
   K6aKtAMNoJfaeJx/s+lnV1WJrqhBSove70JKd0xmRU8=:
   Dvs7DN1yImMfFi8T7oy6KNKKMGc3ViltG5MDpYJcMpo=,
  sha512:
   /v0svq3P6BSMxc0D1tHOrLlEyqtJNpxp0RjSS63rSEuz/o6zw8JgDv56Ep5dRPPuEHKWsAe1jBYi8PyAm9vmGw==:
   X4UXr9IFsiabn6TlJE4N3RAtBp7wRHOaMcKXaqxAGJ0x3K8ZQ2mJdKxi6bgE2sQSSz12oo4t/NLlegnA8ElEvA==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1795294811; x=1795899611; i=quwenruo.btrfs@gmx.com;
	bh=tHDn2ySSVMB7ccjsJPwuxkW/ZChMFUVGUOKQM6uQrN8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=m+r1pQJU5RqIA+XOHVhDiOKZXcWApm4fxOqxBEKX3g9j9OJKAajwb4M/Xc+L/Qks
	 Vl7zbXzcmD6HKVJeTAm+YLmLFsW/LnzD8LtrAOYz+Eht+mlRwUdOvRoYGxiuVky9T
	 WzX9yfcYMc08EFyQDxfrDYYRMTHa0Z+t70wlRdI1z0reTZYvK95eccUoBH/VSFjwh
	 Iy+vceEf9sktOgPzcrzn1eCetfmtFO5z3wJj81Uz9/xgNRLkPx5aUNQTZAExieXAI
	 aRrLDhaGvXYnBUBDzda5X+8okpC5YD1u+RxT1XJgVohj6JQALB/4/Dy5WGWqI8h4p
	 HYqd5D3i/vGROox0DQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MxlzC-1yT2qi3NVO-010aGC; Sat, 21
 Nov 2026 22:00:11 +0100
Message-ID: <3fe960f6-7488-4352-ab9e-1c4884ff68b4@gmx.com>
Date: Sun, 22 Nov 2026 07:30:05 +1030
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
Subject: Re: [PATCH v3 3/6] btrfs: make fsync wait for all incomplete COW
 writes
To: Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>,
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261120-b4-btrfs-data-integrity-v3-0-4de4b91b826e@toxicpanda.com>
 <20261120-b4-btrfs-data-integrity-v3-3-4de4b91b826e@toxicpanda.com>
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
In-Reply-To: <20261120-b4-btrfs-data-integrity-v3-3-4de4b91b826e@toxicpanda.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:qwLWkrC30m2VewX4ikEQhYZn+d1nAQz50GHRv9q/XuhKLKMGia/
 0PGwpI3qzdc/vfvJXquEipIYvFl/xi9q1F+QDnY8Mlwr87+QXdW5Y2u7wSBBGcbCq05Bu6C
 3BMNZKqmdDjQ2ky5Q5A2P0Uak1HDz79WYKN1ASmhTeeKm3cksD6dYTXmmWL318Y2Zi4u/P+
 r6ucrIHkgMHEtHGCcmwbQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ENym3dpGbhk=;+g8IdX8VWHAom66hZ7bt8tuNKEG
 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
 gjcpIoLdNfNs8mnU7VIoRiwEQ



=E5=9C=A8 2026/11/21 07:21, Josef Bacik =E5=86=99=E9=81=93:
> If a COW write fails, or its ordered extent is truncated, the extent
> maps of the part that was not written still point to the newly
> allocated extent until the ordered extent completes. If a fast fsync
> logs those extent maps first, replaying the log after a crash replaces
> the file's old data with an extent that was never written.
>=20
> BTRFS_INODE_COW_WRITE_ERROR is meant to make a fast fsync wait for the
> ordered extents to complete in that case, but only
> btrfs_finish_ordered_extent() sets it. A write that fails before a bio
> is submitted, in writepage_delalloc() or submit_write_sector(), finishes
> its ordered extent through btrfs_mark_ordered_io_finished(), which does
> not set the flag. And since commit 66ff4d366e7e ("btrfs: fix false IO
> failure after falling back to buffered write"), a direct IO write that
> stops short truncates the rest of its ordered extent and finishes it as
> uptodate, so the flag is not set either.
>=20
> Fix this by setting the flag, renamed to
> BTRFS_INODE_INCOMPLETE_COW_WRITE, in can_finish_ordered_extent() when a
> write fails, and in btrfs_mark_ordered_extent_truncated(). Convert the
> open-coded truncation in extent_writepage_io() to that helper, so that
> every truncation sets the flag. Both places hold the inode's
> ordered_tree_lock and run before BTRFS_ORDERED_IO_DONE is set.
>=20
> The flag stays set until a fast fsync clears it, and that fsync then
> waits for all ordered extents to complete, even if the failed or
> truncated one completed long before. A direct IO write that stops short
> because its buffer was not faulted in costs the next fast fsync one
> such wait.
>=20
> Fixes: f13e01b89daf ("btrfs: ensure fast fsync waits for ordered extents=
 after a write failure")
> Fixes: 66ff4d366e7e ("btrfs: fix false IO failure after falling back to =
buffered write")
> CC: stable@vger.kernel.org # 6.10+
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/btrfs_inode.h  | 24 ++++++++++++++++--------
>   fs/btrfs/extent_io.c    |  7 ++-----
>   fs/btrfs/file.c         | 17 ++++++++---------
>   fs/btrfs/ordered-data.c | 46 ++++++++++++++---------------------------=
=2D----
>   4 files changed, 40 insertions(+), 54 deletions(-)
>=20
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index fbcf8ca05fb7..cd75c1a17e45 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -90,15 +90,23 @@ enum {
>   	/* Set when there are no capabilities in XATTs for the inode. */
>   	BTRFS_INODE_NO_CAP_XATTR,
>   	/*
> -	 * Set if an error happened when doing a COW write before submitting a
> -	 * bio or during writeback. Used for both buffered writes and direct I=
O
> -	 * writes. This is to signal a fast fsync that it has to wait for
> -	 * ordered extents to complete and therefore not log extent maps that
> -	 * point to unwritten extents (when an ordered extent completes and it
> -	 * has the BTRFS_ORDERED_IOERR flag set, it drops extent maps in its
> -	 * range).
> +	 * Set when a COW write failed, before submitting a bio or during
> +	 * writeback, or when a COW ordered extent was truncated. Used for bot=
h
> +	 * buffered writes and direct IO writes.
> +	 *
> +	 * The extent maps of what was not written point to blocks that won't =
be
> +	 * written until the ordered extent completes and
> +	 * btrfs_finish_one_ordered() drops them. Completion runs in a work
> +	 * queue, queued once the IO of the write is finished, and a fast fsyn=
c
> +	 * does not wait for it, to reduce latency. If a fast fsync logged
> +	 * those extent maps, replaying the log would put unwritten extents in
> +	 * place of the file's data, so this tells it to wait for the ordered
> +	 * extents to complete.
> +	 *
> +	 * It is set under the inode's ordered_tree_lock, before
> +	 * BTRFS_ORDERED_IO_DONE is set.
>   	 */
> -	BTRFS_INODE_COW_WRITE_ERROR,
> +	BTRFS_INODE_INCOMPLETE_COW_WRITE,
>   	/*
>   	 * Set by reflink while it holds the source's VFS inode lock shared.
>   	 * Direct IO writes also take that lock shared; one that finds this b=
it
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 036d8c0f04ae..58951a89bfc6 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1963,11 +1963,8 @@ static noinline_for_stack int extent_writepage_io=
(struct btrfs_inode *inode,
>   			 * there must be an ordered extent.
>   			 */
>   			ASSERT(ordered !=3D NULL);
> -			spin_lock(&inode->ordered_tree_lock);
> -			set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
> -			ordered->truncated_len =3D min(ordered->truncated_len,
> -						     cur - ordered->file_offset);
> -			spin_unlock(&inode->ordered_tree_lock);
> +			btrfs_mark_ordered_extent_truncated(ordered,
> +							    cur - ordered->file_offset);
>   			btrfs_put_ordered_extent(ordered);
>  =20
>   			btrfs_mark_ordered_io_finished(inode, cur, fs_info->sectorsize, tru=
e);
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 6f525ce42a2d..4208587abff1 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1638,7 +1638,7 @@ int btrfs_sync_file(struct file *file, loff_t star=
t, loff_t end, int datasync)
>   	 */
>   	if (full_sync || btrfs_is_zoned(fs_info)) {
>   		ret =3D btrfs_wait_ordered_range(inode, start, len);
> -		clear_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags);
> +		clear_bit(BTRFS_INODE_INCOMPLETE_COW_WRITE, &inode->runtime_flags);
>   	} else {
>   		/*
>   		 * Get our ordered extents as soon as possible to avoid doing
> @@ -1651,15 +1651,14 @@ int btrfs_sync_file(struct file *file, loff_t st=
art, loff_t end, int datasync)
>   			goto out_release_extents;
>  =20
>   		/*
> -		 * Check and clear the BTRFS_INODE_COW_WRITE_ERROR now after
> -		 * starting and waiting for writeback, because for buffered IO
> -		 * it may have been set during the end IO callback
> -		 * (end_bbio_data_write() -> btrfs_finish_ordered_extent()) in
> -		 * case an error happened and we need to wait for ordered
> -		 * extents to complete so that any extent maps that point to
> -		 * unwritten locations are dropped and we don't log them.
> +		 * Check and clear BTRFS_INODE_INCOMPLETE_COW_WRITE now after
> +		 * starting and waiting for writeback, because it may have been
> +		 * set while we waited, and if a write failed or was truncated
> +		 * we need to wait for ordered extents to complete so that any
> +		 * extent maps that point to unwritten locations are dropped and
> +		 * we don't log them.
>   		 */
> -		if (test_and_clear_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_f=
lags))
> +		if (test_and_clear_bit(BTRFS_INODE_INCOMPLETE_COW_WRITE, &inode->runt=
ime_flags))
>   			ret =3D btrfs_wait_ordered_range(inode, start, len);
>   	}
>  =20
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index df74c75d6c29..1a4e3e34ec11 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -367,6 +367,9 @@ void btrfs_mark_ordered_extent_truncated(struct btrf=
s_ordered_extent *ordered,
>   	spin_lock(&inode->ordered_tree_lock);
>   	set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
>   	ordered->truncated_len =3D min(ordered->truncated_len, truncate_len);
> +	/* As for a failed write, see can_finish_ordered_extent(). */
> +	if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
> +		set_bit(BTRFS_INODE_INCOMPLETE_COW_WRITE, &inode->runtime_flags);
>   	spin_unlock(&inode->ordered_tree_lock);
>   }
>  =20
> @@ -398,8 +401,18 @@ static bool can_finish_ordered_extent(struct btrfs_=
ordered_extent *ordered,
>   		ordered->bytes_left -=3D len;
>   	}
>  =20
> -	if (!uptodate)
> +	if (!uptodate) {
>   		btrfs_mark_ordered_extent_error(ordered);
> +		/*
> +		 * The extent maps of a failed COW write point to blocks that
> +		 * won't be written until the ordered extent completes and
> +		 * drops them. Make a fast fsync wait for that, before
> +		 * BTRFS_ORDERED_IO_DONE is set.
> +		 */
> +		if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
> +			set_bit(BTRFS_INODE_INCOMPLETE_COW_WRITE,
> +				&inode->runtime_flags);
> +	}
>  =20
>   	if (ordered->bytes_left)
>   		return false;
> @@ -436,37 +449,6 @@ void btrfs_finish_ordered_extent(struct btrfs_order=
ed_extent *ordered,
>   					uptodate);
>   	spin_unlock(&inode->ordered_tree_lock);
>  =20
> -	/*
> -	 * If this is a COW write it means we created new extent maps for the
> -	 * range and they point to unwritten locations if we got an error eith=
er
> -	 * before submitting a bio or during IO.
> -	 *
> -	 * We have marked the ordered extent with BTRFS_ORDERED_IOERR, and we
> -	 * are queuing its completion below. During completion, at
> -	 * btrfs_finish_one_ordered(), we will drop the extent maps for the
> -	 * unwritten extents.
> -	 *
> -	 * However because completion runs in a work queue we can end up havin=
g
> -	 * a fast fsync running before that. In the case of direct IO, once we
> -	 * unlock the inode the fsync might start, and we queue the completion
> -	 * before unlocking the inode. In the case of buffered IO when writeba=
ck
> -	 * finishes (end_bbio_data_write()) we queue the completion, so if the
> -	 * writeback was triggered by a fast fsync, the fsync might start
> -	 * logging before ordered extent completion runs in the work queue.
> -	 *
> -	 * The fast fsync will log file extent items based on the extent maps =
it
> -	 * finds, so if by the time it collects extent maps the ordered extent
> -	 * completion didn't happen yet, it will log file extent items that
> -	 * point to unwritten extents, resulting in a corruption if a crash
> -	 * happens and the log tree is replayed. Note that a fast fsync does n=
ot
> -	 * wait for completion of ordered extents in order to reduce latency.
> -	 *
> -	 * Set a flag in the inode so that the next fast fsync will wait for
> -	 * ordered extents to complete before starting to log.
> -	 */
> -	if (!uptodate && !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
> -		set_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags);
> -
>   	if (ret)
>   		btrfs_queue_ordered_fn(ordered);
>   }
>=20

