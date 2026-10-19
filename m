Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792437683;
	b=K87WbM2D8K30NH3cf+UBJamwoCX0NY6JTC1FBW0/eoVN4jbOdz1REsrLwEVGwbtBwACu
	 irJJSItCbtD8Wae7LhIIN6naNAMU2FzT12aRnh76SSNXgh1JFeCjQPP5SVESvHnZXE4DG
	 XUfNtexGwaiw0rVvELWbE+lvpu/g/c8gsuiE3+c3owZA6R/VeFQJraVWTIFaFFbHNk4Bo
	 LCjGc6T7OCm27/AbCVdM102+9+q+v1712GiZQRISteDRxKhmXlJDnVpM0ZTZRa/ASrrk4
	 kNuwSPJBhMFtkXhTGh3Xb8iS4tbRc6j9nKwqu0GcqH8htcAhlsA8SJ2+KGpBFXRFC1g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792437683;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=b6LnMpq+mD7n9lBh5jfe4gwFpq4HBsOW/X8QfL4Dwso=;
	b=l3m42EehVARqQytwz97yIMx0BspTs9FKTO3vugiHDJHLbceZI65Si3NRDqA/7FzNyhP4
	 +cynBU5yARDqi+9EZg0Vb9Xkr7VJPwgjMoa+ZdT/bJjSxtUGQu9z3KuIRlJ2OYaQHJ1v4
	 hzW8wewQyA6pMhrMlE3jcphYgVcApdCBc6CU94XqEYa0wn1qBaW9d1IM/ZJuSvRg1bOXf
	 XnFYOQzM91JUxKZYRYNAbk0dg6R8ZMTYuD1XBUyVG2ZfgmQsXOoqRL1U4M3xlSP+BDiWT
	 UArtfR/AkhLi7QTMDKykE4bN/wqQ8lnQ5mql1gok6WfbPVoMsiRrfxsg/n2vuCKmPWA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dc1cLgDT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ADD606A31D
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 19:21:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07ADD606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dc1cLgDT
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a1e3b87ac5so13328125e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 12:21:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792437681; cv=none;
        d=google.com; s=arc-20260327;
        b=H7fqr+3Lp9bkpKEpnherIdy7/ipjXUFSg5zL/6UQ1V5yRtcT8xPoAkdfKrm/57VzD6
         CZewpd2yuVdcwMzJZohMSgo7ZYXg6fxLI2c94511xsS100Yijr/GSKcfBp91aqAgT7sF
         ybqkeYcpjyuUA+61+i7aQOQACr2JsCp5JiMbCLIwOii+fgAZ1madRM8mUN9RfCvGltJE
         wltldOPWl9nkrMwf5RwNEv+DNHdDbnWWbA1Pdq6N8NchI+OHewNr6ys334Vqhuo6FvB2
         Wzbl3SITlZqVkBO3ux5G1pu4ikLXDj6wOOM5r041MPW1QZv9Uf2LVj5pQcXO659ppSX0
         oK1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b6LnMpq+mD7n9lBh5jfe4gwFpq4HBsOW/X8QfL4Dwso=;
        fh=ab9um+Edr/ehhe48uO2pX6Cm4sJr5NNVjCvRNWDkDdI=;
        b=Vf23QaVzwLPSKMtjirvBN3zIi7KflZ+nljRDYZnPkTpic+HAVh+3v8EjpLcrAGdDDD
         zP6SbZzY590oq3GbiV41GwpZR31rCRLkqwJVChwCrffniHgWfVLiUX2WPE/r3GU/cA3t
         Ysgw6nyNpk41/A3ou5UOuINUxF+/NBa3zPgzQKSqgjlwv817pNEc+WfvDn41sjgWHhC2
         DAP10C0+2wUjEbGbWLbzR1xwwbCI7BusQC35RCFp+vfuhRqxsipi5IDVz/Swso/hsEid
         vMi2jMCqaU2r5alsjLik4W9dK+uhkRatV5Am2P3kK/E1wZsm9lntmg8ODKPZOUGF0Ag+
         Y5iA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792437681; x=1793042481; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b6LnMpq+mD7n9lBh5jfe4gwFpq4HBsOW/X8QfL4Dwso=;
        b=dc1cLgDT0Ko8F2x7TMVyubI3iVJrOwG8T29lGw1TuPu0YwbvBpj5hARvYnDX0Iu8+Q
         WZdM/P3Ipg0Ah3Lds/TyjQdO2JAahEP0tAFLhGe8GBpmhWx9r1axz5RkgGPnpRrElJwy
         Dth/gqZcu3UgJGNTEn0s+4M6i5MNNGZjGXh4BS/z2HznR8J3OMp3Q9f6lQoy+NAZ6VQA
         tTqZKh4L2+jdz9CAlTPb27JIOJt2oNKjKq5NqDVpCg/eIRXgGiNBgx9JR6v7VYRWMmEZ
         DkR9rv2epibBVeTjri6g1kReSsvSGTtigzUBmW5r1fd3ZZM5uW5HfycFisT7vK9DmftT
         tjHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792437681; x=1793042481;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b6LnMpq+mD7n9lBh5jfe4gwFpq4HBsOW/X8QfL4Dwso=;
        b=KOWJ1A2oYUgqWOkKp9kr8ElYVI+NAJprz2vs2y6iJGeP1x+mfnkWwFvIq4N3jIUrRG
         ExN97CPeaeKYmP1qFZt3ssG/XKk2hLz5qFjdqGmN2qpue53SNJEK+UAdzuB2g7Pq9NEq
         iuGEZNAcZi7rGqDUP9pCcjeynAtZ5sGj9cOM1JdhDbQrYjC2PbNMKvagEpjFQ80gslFo
         64ZmEe8U412X3FafyMoov2D1gg242CFFHihfZBUrIusgnpt1Vd+RD8wVZrusd3DQufJm
         hTy+UbEuCLanrkjk8Pv1vqvHJkgxIYLkI5M+Qbn0c/P8kOfmJh/kuuW5KnzWFfZs+NNj
         dJZQ==
X-Forwarded-Encrypted: i=1; AKwUvBx4dc9ZR5zxNI+Hwabds4D6uA7eNLzuE30bGdLRtvfosEHVk29NxD0K0j4BBY0TB/Edhmh24SeMp3I0DA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLVx9Qu4Af2HLyINLdoMugnkmkTABz6s5PJawhnCkeNyxSKjii9
	khbasusVBa2YSjWPPYgv+mH5QUfmwbEMy7tLeP2+zffe9lpmeq7xWUD766fZhs/LnsEv4qpNRSq
	YYwI0zNmGtj6FY9lVoVvLtaKVKtaxCZ8=
X-Gm-Gg: AYBFou080VKNbEQKB6LEDT0lEizmKZqJ39+StwtqDsNXrj4xvd/XgdfKpRoEMFJxXtF
	b90YwUPw3P23D1wndChXZDN1YsvCnBySljLXhqGPuyedboEaKnMH4nvlowg0nbZn3YhDRq9JA5S
	lrKS5O+aikwf8TQXZ66ZSfwfqOYmhjVGNkuI902heug25Hn8I4YdRRxM/HigdNp6If8+jaFo1IA
	/ijjgjzyKblNjndkpV53HEQWXw2vQiC+LJPim/PMbAa3BK+6v8pBCn73Uu+vyCz+C4ZLZuQSmOZ
	ppgucmQ9F5AFHBaSALSf08L/6DrVCgmRVOwilDxuCvFSdPcCJ8GsjVTqE/TYUngSGgqH+fAyPXk
	6nV1UXaGcVwcmXgu6umlX3YF/q9rRCCUyvf/BQ9fxROo3EgLi
X-Received: by 2002:a05:600c:a46:b0:49d:1df6:2592 with SMTP id
 5b1f17b1804b1-4a1d7603dd1mr197271805e9.21.1792437681041; Mon, 19 Oct 2026
 12:21:21 -0700 (PDT)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260922201258.874070-1-joannelkoong@gmail.com>
 <CAJnrk1a4m-F0F=HbnaMT6+OFfTOv90Eu3JHwHe=EqEd+vO_SPw@mail.gmail.com> <cae42a9d-bb41-4ce4-8d71-84e7bbcb41a3@gmx.com>
In-Reply-To: <cae42a9d-bb41-4ce4-8d71-84e7bbcb41a3@gmx.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 19 Oct 2026 12:21:08 -0700
X-Gm-Features: AclHuK9WM0db-dyL5DHNNvn06-o_dipd5FyPGSQzi6gaDcW6VTOVJSQi1AQmmf4
Message-ID: <CAJnrk1ZrLB-6p_z67S19fMH_kFK1ZNe2=MG1M0vF5k9pFCqRVA@mail.gmail.com>
Subject: Re: [PATCH v1] btrfs: add LOGICAL_INO_V2 flag for avoiding the tree
 modification log
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.com, boris@bur.io, loemra.dev@gmail.com, fdmanana@suse.com, 
	wqu@suse.com, linux-btrfs@vger.kernel.org, ce3g8jdj@umail.furryterror.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 16, 2026 at 2:02=E2=80=AFPM Qu Wenruo <quwenruo.btrfs@gmx.com> =
wrote:
>
>
>
> =E5=9C=A8 2026/10/17 03:39, Joanne Koong =E5=86=99=E9=81=93:
> > On Tue, Sep 22, 2026 at 1:14=E2=80=AFPM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> >>
> >> At Meta, we use the LOGICAL_INO_V2 ioctl to estimate sharing-aware spa=
ce
> >> usage. We sample the logical address space and resolve each sample bac=
k
> >> to the inodes which reference it. The measurement is statistical, so
> >> with enough samples it gives good bounds on real usage.
> >>
> >> Currently in the LOGICAL_INO_V2 ioctl path, iterate_extent_inodes()
> >> (which can walk backrefs either against the current trees or against t=
he
> >> commit roots) acquires a tree modification log sequence number when
> >> walking the current trees, since those trees are being modified while
> >> the walk is in progress. The log is then enabled filesystem wide for a=
s
> >> long as any such walk is running, and is only disabled again once the
> >> last walk has finished.
> >>
> >> While it is enabled the cost impacts the whole filesystem, not only th=
e
> >> caller. Modifications of interior nodes of the extent tree and of
> >> subvolume trees have to be recorded, serialized on a single filesystem
> >> wide lock. Delayed refs with a sequence number at or above the oldest
> >> active one can not be run (the run path bails out with -EAGAIN in
> >> btrfs_run_delayed_refs_for_head()), and metadata refs above it can not
> >> be merged, so they accumulate and that work is deferred to transaction
> >> commit.
> >>
> >> Currently, userspace has no way to ask for anything cheaper. Whenever =
a
> >> transaction is running, the walk uses the tree modification log, even =
if
> >> the caller would tolerate results that could be up to one commit inter=
val
> >> stale.
> >>
> >> Give userspace this option by adding BTRFS_LOGICAL_INO_ARGS_COMMIT_ROO=
T,
> >> which makes the backref walk use the commit roots and therefore never
> >> enables the tree modification log. Behavior is unchanged unless the fl=
ag
> >> gets explicitly passed by userspace. iterate_extent_inodes() already
> >> takes a search_commit_root argument for this, which scrub, send and th=
e
> >> data relocation warning path all pass as true. The flag simply plumbs =
it
> >> through to userspace.
> >>
> >> Assisted-by: LLM
> >> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> >> ---
> >>   fs/btrfs/backref.c         |  6 ++++--
> >>   fs/btrfs/backref.h         |  3 ++-
> >>   fs/btrfs/ioctl.c           |  9 +++++++--
> >>   include/uapi/linux/btrfs.h | 10 ++++++++++
> >>   4 files changed, 23 insertions(+), 5 deletions(-)
> >>
> >
> > Hi David,
> >
> > Just wanted to follow up on this patch. It has received a review from
> > Qu, and I was wondering if there are any outstanding concerns or if it
> > could be included in for-next or for-7.4.
>
> My bad, I should have pushed this one to for-next.
> I hallucinated that Boris had also reviewed it and he would do the push,
> but that's not the fact.
>
> Will push it for the next release very soon.
>

Thanks, Qu! I see it in the for-next branch now. Thanks for your help with =
this!
