Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7144E54A7C9
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 17:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792170570; cv=pass; b=eyx/0kA1vSErST9bT+0JMcAPe+BNQgZALYxqqWY24j9kyV57o9Jm+pwuVZF7rvQwl7nHkJaG4E4dwMJWJVCxqJ1H3FjNmQlRjO8upSA69qXFUYpsEh+mOeVLNQ+ln31QTN3EnNU5fVPmuiEAOKBPanH9hOVTlOHqc8Tn/9y6NpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792170570; c=relaxed/simple;
	bh=3XLpnbVSB+fMUbPlLy8NSzyQdO1Lwz+pBslA0k4keK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ALwqY15pjsEnQrch/tVdJf0XAkzhXfuKbrY8GqoaC13lf0iGJyQa+81kYHn55bHEa6cgUVyH4qQR0wI82emVn8yJWgGQuAmDR83Rbts+psDrq3JzIYPMiu89wrsM0mEP8p/FTu9GhoLT0LBKga4Pvxs+gxdqvsl2iPicrT8vepY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PuI5Q9aG; arc=pass smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PuI5Q9aG"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48afbd2c386so28993f8f.3
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 10:09:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792170566; cv=none;
        d=google.com; s=arc-20260327;
        b=S2F/MTODshiYzYPwHT6L4goGRaNEvTpP/x0maR3o3+HxF5n3u0xktj76ZV+xYlDL9q
         sLBltHLNFPGGL0XmFuYYhW0DvoVbDZ453FHViWtlM6T2plJQO4PJDYc8XzywZJXbwYUB
         d6HsfahZyrg6/vB1cnRxmM+oEpD9dV29rQ0F7CBGjgsbvsTnYDX27dqXFOGZg8ur9/g1
         7uyS/hA5LHq0WhtCtOSbc0Kev6J19Cpe4Wfjc7eZDjKxAzCJFdzywyYsaNIvXxLqF/Cz
         gLSU69y35ttxsC74O6fa2Ijcr9LlzeRl8/zgkXpd4oNKBbCpeH8KaJSuIPJZmFW1ynaN
         Q5Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=enl7x47igE+NqB7LOagQGUFh9kmIAnjII0ZDJZ7466U=;
        fh=+xXrM4OmDaKCs5uVNcRww/Us+B6PuYMX/sdFg0GIW0k=;
        b=QDzV2cs2DShyLDlgRqeyhtPoKjP14XxMjx6YvEwg8W5EqBxWzaGnL/sIm4LiEtGsBM
         JNhQYfqma/uR/XQj62zuqN9j/OcBU185JYBFeaays1zAxeU+s86q2/vLESo8t8HbM2nV
         xzdcE+4I5EriuvWmw/idcJABDgaoHkxZv4MAHXJwUtqCenFyJtmfCyBd1Fx7RmqpYAOV
         8k34lXOL+HI1Yd2KDuXrjYZr/pmc0jiz/XrLQZGlRJcW7sFWbnuzbFUrC8x63U4rMq94
         IPQd6rEgEdJsb8mpOfhME/VDjwLMVnjnn8ve0+qX+X7yYQPMbd6ts4tcznF0BWhVAiHj
         F1LA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792170566; x=1792775366; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=enl7x47igE+NqB7LOagQGUFh9kmIAnjII0ZDJZ7466U=;
        b=PuI5Q9aGD1qcIYd4t4jNtZU7BORwJRlEzSsf0ypDou7mj7nsyG6PINXEbe531TlWPV
         LCh5JLsmH6P9w4DEkSiJkK6VaIhBJLYQvYVFWFIGc/k7NLQagaCxMHw1AsO6PogDWN9G
         Wk5kWuEqG7PUzIDLQF+70s7un9OjgYMmIv5OzkkuqzMJEOTEgfQP2IcQfK40rx7UeESt
         vjpyjO42jgVGza1QPImrFHDQ4hQBBhtiUx/+XXxvOjh3rCO2d3gO4/o1LhEgZbm6yVr/
         R0HVVPmSs+gavBiqHnQtbJNsjQ2MyA4Pg9t/yE87dryGV+kSaJILtKPD7G+BFRppgVoO
         y30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792170566; x=1792775366;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=enl7x47igE+NqB7LOagQGUFh9kmIAnjII0ZDJZ7466U=;
        b=h64YQZtfogvLZcYGkjOVD9qvK8MGk1P8RQRTb9kbjvGCPqebCHqlqhlGTrhKW6eTtt
         lS3AKNJZW5sUp6zwopwuHeBPIZYkN0RCvBP12DzI7XT1ycv01oK3HvsdrgcTaVZZZZmt
         G8R/hP4eMplLwngGBm4igql5S7Zwh9sN5X6Ft21LamsAP5Hls9Fqev5ehAAevQezLz8L
         2cboKgLxM867GuMTNbmsTS1C5NyFwKtOH3Gv9FcTONVtTMrrBifuRkJC+m8aAosM4oBY
         gugrIRNvREw4lBPIovEejGzuetz7y1ZEZLB+vHN5CVbkl5HnZsUgxbYGRCRY26UTN/Ik
         dWWw==
X-Forwarded-Encrypted: i=1; AKwUvBwMDFb87Z7SBu+PmSYCLx4CKWR+04w+TJ6kWq6IGQNyyiRvSEduYHb/V4j0mlyLw7xDPUh/AlqDKzO9eg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJuG+nuW2KkOTB3q5VtC/4Jt32jXvXBCbd6Rs9zvVdAdoL91e/9
	V4iDX6Jq53onD9rrKXyCsOrtX3BT3SJAqPRnq0fXpGAm20qkU1hextejH55h7J9S/KccZR+wBmO
	rwMF4lJsvpqDwldycgCh66WIOPhwPI78=
X-Gm-Gg: AYBFou1kGMVNiTazroXWiSPHcBZmCYrJsGqjxs0DLr1t2XnhXyWjclM3ecOr3eF5NrP
	dQBISTERhxA4T4XcWqpgRg+AM0LoeG7FsKQ6MI7BljlNs2Dyfwo4BjZPC21E3tQOu+nlpF+pIMl
	rTdhzVOnv8B62DULi7MPk6l6t4i67XFDiyWIVFceQvWloobW79dK3p/vKF2SaADyM1HPjjxeT+4
	/zlL2c4gwYfvp/wXhyzdrPSN1MkZfYuU9qsf69xAagZcA0nkZE3DyMUt5P5xmzviQIXz6/QwQnK
	KQP5nnc872k4bT64yR6CQZfXiHZcUp8weqrNy/rLA6x4G7ox//7XCw+vWqxM449HAe3csHx0qyZ
	5041tQeY7/01QK3HuosO+1Y2qbyQ9mWMZ5hwj
X-Received: by 2002:a5d:604d:0:b0:48d:ff06:c634 with SMTP id
 ffacd0b85a97d-48e07fb7375mr339783f8f.54.1792170566408; Fri, 16 Oct 2026
 10:09:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260922201258.874070-1-joannelkoong@gmail.com>
In-Reply-To: <20260922201258.874070-1-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 16 Oct 2026 10:09:13 -0700
X-Gm-Features: AclHuK9XRf2UkgVDWxmHa9a-oA4RpfwEOTu-TeqwKECp0r13pDWQsJniHLYO6jg
Message-ID: <CAJnrk1a4m-F0F=HbnaMT6+OFfTOv90Eu3JHwHe=EqEd+vO_SPw@mail.gmail.com>
Subject: Re: [PATCH v1] btrfs: add LOGICAL_INO_V2 flag for avoiding the tree
 modification log
To: dsterba@suse.com
Cc: boris@bur.io, loemra.dev@gmail.com, fdmanana@suse.com, wqu@suse.com, 
	linux-btrfs@vger.kernel.org, ce3g8jdj@umail.furryterror.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2026 at 1:14=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> At Meta, we use the LOGICAL_INO_V2 ioctl to estimate sharing-aware space
> usage. We sample the logical address space and resolve each sample back
> to the inodes which reference it. The measurement is statistical, so
> with enough samples it gives good bounds on real usage.
>
> Currently in the LOGICAL_INO_V2 ioctl path, iterate_extent_inodes()
> (which can walk backrefs either against the current trees or against the
> commit roots) acquires a tree modification log sequence number when
> walking the current trees, since those trees are being modified while
> the walk is in progress. The log is then enabled filesystem wide for as
> long as any such walk is running, and is only disabled again once the
> last walk has finished.
>
> While it is enabled the cost impacts the whole filesystem, not only the
> caller. Modifications of interior nodes of the extent tree and of
> subvolume trees have to be recorded, serialized on a single filesystem
> wide lock. Delayed refs with a sequence number at or above the oldest
> active one can not be run (the run path bails out with -EAGAIN in
> btrfs_run_delayed_refs_for_head()), and metadata refs above it can not
> be merged, so they accumulate and that work is deferred to transaction
> commit.
>
> Currently, userspace has no way to ask for anything cheaper. Whenever a
> transaction is running, the walk uses the tree modification log, even if
> the caller would tolerate results that could be up to one commit interval
> stale.
>
> Give userspace this option by adding BTRFS_LOGICAL_INO_ARGS_COMMIT_ROOT,
> which makes the backref walk use the commit roots and therefore never
> enables the tree modification log. Behavior is unchanged unless the flag
> gets explicitly passed by userspace. iterate_extent_inodes() already
> takes a search_commit_root argument for this, which scrub, send and the
> data relocation warning path all pass as true. The flag simply plumbs it
> through to userspace.
>
> Assisted-by: LLM
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/btrfs/backref.c         |  6 ++++--
>  fs/btrfs/backref.h         |  3 ++-
>  fs/btrfs/ioctl.c           |  9 +++++++--
>  include/uapi/linux/btrfs.h | 10 ++++++++++
>  4 files changed, 23 insertions(+), 5 deletions(-)
>

Hi David,

Just wanted to follow up on this patch. It has received a review from
Qu, and I was wondering if there are any outstanding concerns or if it
could be included in for-next or for-7.4.

Thanks,
Joanne
