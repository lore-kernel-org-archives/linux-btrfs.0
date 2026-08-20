Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62F141A4F7
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2026 11:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787225158; cv=none; b=lxy0xV5ua2C+tkBYlAazdTeUwWHCEeK/xL2KF8TGbkj4MYQzYU3rXoK1auHJo1hpqNMwQ9Y78uq+H3hVL2PMXlD/a/cPrZZNmrqo2W3QVX5PQW45I6F/9UsXzpT6S0vwV2oEVgsyo6Y1bObWI22wUSfphaNXGF9+yPOTW7ykK5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787225158; c=relaxed/simple;
	bh=pEeaGQ0Mdt1TA25PSLc7VPAWIjxPHlZzAjXBnPJKvTg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Udk/XXXgqlRcw2RpE45yrofzpB2J2sykluYo7hL0pFfc5ubTbBhw92je96sjHJoTEuva+gyTi319h57g3TvP/P3jg7brb9W9ETR48qFWdsqC0INUOn4pPXGi+XFMRCPb4lDEXscxlqgQ10Dg2jr0DXE+vqppBhCMutUC0Ebj2Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=KagFmqzZ; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="KagFmqzZ"
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67K38dZa3660030
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2026 04:25:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=Kr+K+zjOdEMK9wEKulfes8NAHCfzB3pGDnX9o
	xPQjJo=; b=KagFmqzZ951XX8MJF6VNCBjnks2ID1/DU+XapiW836v0LX372gJbr
	b1ixjExCDE6WSnT1a1jK4smxh22Y1/Ne8Pk0B3ZQf584hXCYYqoex27AkVPssae9
	VqLqRjjxPcU8bJnvBTkfEqvZvoIkEB5OOMuFCHVqWE9rnyuTbTnBb6TAQNk32jcj
	Z7G6hVl9fIAiJbtODijskdpUlVbE75pux+R7sLK0RaYGxxZ/eRHRR8BQ70XZBW1s
	dZCFKTkuij31TekhmRHStEm6/lZzp0Nwd6PmDajkqhIyAHmMb5UB+6Z6ux7cPekP
	hyygvMtl36VFutt1WNxZNcYcuV18SPHDA==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4g4yfx4vhg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2026 04:25:49 -0700 (PDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c0e702df8so27900751cf.2
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2026 04:25:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787225148; x=1787829948;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kr+K+zjOdEMK9wEKulfes8NAHCfzB3pGDnX9oxPQjJo=;
        b=g20PRplE3eCpcaJQaNh13LR/kqYqr8aEEcm8uKYmhKEf+it0oqmpM0bcuxboK40l+0
         Yeg3XSBcka2UbcNBtCztjRi626OK3qrvlJlKV5t2KDGRWSaA5sCzyr85wTLthMCir+Cq
         Ur7/Xy7MURqXA5iPdhlgyoHyw7smREd0bd9KBlKFQckQCqyXkCy+7KvO0V25jm2RsP4u
         W5EbpQl5PTTZSpsVyvsE98iE45GfSs7Y9ybRY9MG2/AiA3HxZSMsA8At4th/JUpZRUUP
         aloaDGo4PKROdcyxFPxLAhySZqxb5HxK7+Ld9htRtkNncMey5HNxI234goGJ8G0YhCws
         BDAg==
X-Forwarded-Encrypted: i=1; AHgh+Roe+HMpWdkZ137mA5HUTPHwJMtFpGVkLgAd5utx42RGicUCVJ0nC+OOuYGtG8DgC6R+vxaowxQ52YgLuw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxFet0BBFIWACpjvqk7u4xgt+a/d7eALFee01plynrdI35fLL8I
	g3fMgrj9lh7P1vIf1Y4FKpSiDVmz2JovmqSGUo6KgTJupkQlYc2RMsXCWy4kMTCWKXxdQpNIHMa
	MuUcxvFqd2WsbatZYkqkMNvmCabSgT8Idh+vA485b6sHJwZNS8O5s9Fw5IeR+v1U=
X-Gm-Gg: AR+sD10WOJPuyeXjvDxP+aMizDcqftjG92CWfOYVpPn6gIC65EUaJ+S+dPDbfCVdlG1
	lbmO8dPv3AwbH4XGvVJAV0MXHCDklWLp+Q0dR/Q/Q582FWjyWaJFZWDHeezYo748x/WCuEnVSz9
	T76xp5SpUjdFqnYh3j9J/IVDECstOqen380Z1U5dmhTnWk1tAUTQ+nDVHfOr2j7Su13ovzK7Obv
	aUq48xZRGmP/ubBC1twD7Kk/wywlXCaaidpOX61tWbvj8xNP8ey5KZs7h1mGl/cjLlEqLiXpNtq
	rPUV8Z5cY4TdMdz9sImIxubp8bOv23WerWsiv6svym9kMn9q1JfXgpwhMvYla8TR07aqeBH7xAr
	6
X-Received: by 2002:a05:622a:58cd:b0:51a:8696:cb38 with SMTP id d75a77b69052e-52dd57853damr115785051cf.7.1787225148404;
        Thu, 20 Aug 2026 04:25:48 -0700 (PDT)
X-Received: by 2002:a05:622a:58cd:b0:51a:8696:cb38 with SMTP id d75a77b69052e-52dd57853damr115784341cf.7.1787225147838;
        Thu, 20 Aug 2026 04:25:47 -0700 (PDT)
Received: from [192.168.77.173] ([68.20.15.154])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52dd872f61esm29031451cf.23.2026.08.20.04.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 04:25:47 -0700 (PDT)
Message-ID: <3a7777fb1f0678c88c2365a6a476167b5abc4e9d.camel@meta.com>
Subject: Re: [PATCH] btrfs: abort transaction before releasing
 tree_log_mutex on commit failure
From: "jlayton@meta.com" <jlayton@meta.com>
To: Leo Martins <loemra.dev@gmail.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Filipe Manana
	 <fdmanana@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 20 Aug 2026 07:25:46 -0400
In-Reply-To: <698c480ec13cd6e74c2175924f614b7e324e6cc3.1787099421.git.loemra.dev@gmail.com>
References: 
	<698c480ec13cd6e74c2175924f614b7e324e6cc3.1787099421.git.loemra.dev@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-GUID: Vshq9xP70I_27CLy-Syx9FLJwe4CN605
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA4NCBTYWx0ZWRfX3MFd3QnmLdhc
 9GO+l1YwsA/Z2QxV9T65mdt+LdKivHWGxnd0L6TUGducbKWJJ+kILZkt0YlMk8t1MFIw5soHvBl
 Su+PuZXN/5a8ClBaRDtpRX5Hss2wzTk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA4NCBTYWx0ZWRfX0IZnFW8nAega
 cuYV6ml5nvF/bmhJqPNDz2Hczf3+IEIekFlclgxJf4Cxjr6XIdXgz/1/qVGLRp+rgi7+Hwuz6ZU
 /U0hLDmoTfm/PQSF1zXvNVb6wfBpgCTHLQw1duv8kTs5cRqPqT24rRXJ8Kr3rwJIyr+13nt39/7
 PM8iAjKJF93w2xgPeUDdWE2YA436aYhtTNbuF2F1SWPF8a/d9J10HUoiOr9jetFxYMHqQU9Bt4U
 fDzWX6z9SmxYUSb8nfZW5ETKSaYHapXgB+qa8O1BoquuR5cmuc/pLfhSvo8ungk6+Yt9heOQddA
 4tHygMuwzkcI5UXuGlF0avW+5rzpfvpd27FCby1y9z/FRoxS/jIeK0LwQSBSd0pu9NlksXSB+iC
 fLoewZA/1RobvmWiV9Iy5fDP1uHh1cUMbg2oL9FNzou7UL+HrosD0Bg5rmdnjVGMxexbC6S+iBB
 G7wGHuwMBQ1MoWlI62g==
X-Authority-Analysis: v=2.4 cv=QpBuG1yd c=1 sm=1 tr=0 ts=6a86e43d cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=I8GJ1mTG6nUeI1lZk6893w==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7j0FZ4iXMVMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=PAz_-FQ8hEVmOPYdF0yf:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=VabnemYjAAAA:8 a=5xnzj68laMxwpfVuNd8A:9
 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: Vshq9xP70I_27CLy-Syx9FLJwe4CN605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01

On Tue, 2026-08-18 at 17:40 -0700, Leo Martins wrote:
> When transaction metadata writeout fails in btrfs_commit_transaction(),
> the current code only logs the error, drops tree_log_mutex and then goes
> through cleanup_transaction(), which aborts the transaction and records
> the fs error.
>=20
> That is too late for the tree log side. A log sync can already be
> waiting on tree_log_mutex, because the committing transaction is moved
> to TRANS_STATE_UNBLOCKED while that mutex is held, which lets fsyncs
> join the next transaction and queue up in btrfs_sync_log(). Once the
> failed commit drops tree_log_mutex, such a log sync acquires it, sees
> BTRFS_FS_ERROR() still clear, and writes super_for_commit. That
> superblock holds the roots prepared for the transaction that has just
> failed to write out its metadata, so it can point at tree blocks that
> never reached the disk, and the next mount fails with a parent transid
> mismatch.
>=20
> Commit 165ea85f1483 ("btrfs: do not write supers if we have an fs
> error") fixed this class of problem by making btrfs_sync_log() check for
> an fs error right after taking tree_log_mutex. That check only works if
> the commit path publishes the fs error before it releases the same
> mutex, and commit 68d4ece9c30e ("btrfs: don't call
> btrfs_handle_fs_error() in btrfs_commit_transaction()") removed the only
> thing that did so.
>=20
> Restore the ordering by aborting the transaction while tree_log_mutex is
> still held. We have a transaction handle here, so this does not need to
> bring back the btrfs_handle_fs_error() call: __btrfs_abort_transaction()
> records the fs error itself, which is all btrfs_sync_log() looks at, and
> the error message put in its place is kept.
>=20
> This is what commit 3810ab40afa5 ("btrfs: abort transaction on error in
> write_all_supers()") already does for the next call in this function.
>=20
> This is reproducible on an unmodified kernel by failing the first
> couple of bios of a transaction commit with fail_make_request while a
> concurrent fsync workload keeps log syncs queued on tree_log_mutex.
>=20
> Fixes: 68d4ece9c30e ("btrfs: don't call btrfs_handle_fs_error() in btrfs_=
commit_transaction()")
> Cc: stable@vger.kernel.org # 7.0+
> Signed-off-by: Leo Martins <loemra.dev@gmail.com>
> ---
>  fs/btrfs/transaction.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 13a7e5f4e08c..ed850bf0546a 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -2583,6 +2583,12 @@ int btrfs_commit_transaction(struct btrfs_trans_ha=
ndle *trans)
>  	ret =3D btrfs_write_and_wait_transaction(trans);
>  	if (unlikely(ret)) {
>  		btrfs_err(fs_info, "error while writing out transaction: %pe", ERR_PTR=
(ret));
> +		/*
> +		 * Abort before releasing tree_log_mutex, so a log sync waiting
> +		 * on it sees the fs error and skips writing super_for_commit
> +		 * for this failed transaction. See btrfs_sync_log().
> +		 */
> +		btrfs_abort_transaction(trans, ret);
>  		mutex_unlock(&fs_info->tree_log_mutex);
>  		goto scrub_continue;
>  	}

Reviewed-by: jlayton@meta.com <jlayton@meta.com>
