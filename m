Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF4F39A4A7
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Oct 2026 16:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563420; cv=none; b=GfdbYcdaja4TnOnuw/v8QQWazoSACogxBEDTHR5d7Beyk1F/2fW4K2EsH//NY/zwoNYeyVuEa5ZKATucvr5dtzrK1gEsZgFDwN0oWgRaxa/l9Oeh6Zx/c0jtyyjFcyHQ20xPH9hB8NAeAusIVj9IpSqgGCGHFa2qMsAydjNPqSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563420; c=relaxed/simple;
	bh=2LpCRCF/B2VjwVBdyzxpo1+q3pH8b3+KYaS9M+RVBdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gm71gtVF5ohrFGKtnNgjxwAGB6QemcNK35QomM+TlgA6o+kYuvGhtPiViKYzsAES7yXQl9hMhggmPJB2Eft7qm5dkYwqKw0hJXHc7QufAgKVDDZy1XFgNpp53byYVH5bQ6gg1tCCg4ttHfW4uNBhhMfmDqHnWiGGeLlsa1b7Rgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=y4wmzeEe; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GySlmIL8; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="y4wmzeEe";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GySlmIL8"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id EBE0AEC0032
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Oct 2026 12:30:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 09 Oct 2026 12:30:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1791563417; x=1791649817; bh=Joij44HcLu
	6GxrZ0aBDbyp9YzZQ0mnEuufC0BFgbEqY=; b=y4wmzeEeHz4x98+UPXvdDsjD0O
	wpvr87JZVUAxvKq0vt15hGLA920FHCb3tn7vebPlYrIfZNl8U71RIpJ29CNHOFlS
	131+GoZkNkvszV46/sZgaWFX3R+s8k5HlhyffQujbjyzZbnAebWSmr2zziPETmv9
	8nggwAXplvVuXt4/tC19at4uudCYN6FdwjZc+WYHsjcKaOQ4BbIrKmWhij71BFYB
	cifScIAMnzWk6IBf7rTQqUX/tJxV7ed4+7/2/9kKGWg3BZNr9O0ukNhZfC0gEdLP
	R3sqD/UZb04994bUe5jE4/UYG9grtISMLmYPbBLD4VrSToCpc7AcB1OWhWnA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791563417; x=1791649817; bh=Joij44HcLu6GxrZ0aBDbyp9YzZQ0mnEuufC
	0BFgbEqY=; b=GySlmIL8RMyS5gvJDizNmAbDSB8FPeU5klCyXH2QBKy0ATPKARl
	ObIq5tKZlFxPV0zIiNH5HBrDXEDWTL+yToFNjcYEHd+Gb5/zmwpLwRWYAHoqGqvV
	TSjqR3sBFXZpQaP3n7//BNa5Ca0KtKcSi6HqR5BDcKVvE7+pB7qFuqhm5sIfLMle
	StgKSRAPbKXOQnYT1moRMsH6nSpGLkKK048oyBvKtKzUYIppKnbVp1dq/NWKcQmF
	j9LOTDdCAfKTsYNhG3yTmXgjOyfD92++OocIgZltRr3eYnYoUEVUdTJSjgb+CGtK
	TLc/Pc3QC0nASuyreOU0ha5o2L9pvArs+Gw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791563417; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm3:rsa-sha256:d+UP72eOgWcsETSVWmebUtXkKrsvuZ0Q9J6qHByFkdPKP4G
	HbqpDdaBQjLmo4c22hYD5g88vcZs9xOIEeeE29pwsWhlLaE+0wmuVaEBvj9KQq/K
	bos2TXRJGhEPyjRYM0PvAdSRxVTpVsn4qFUp2pbwjk9HDbGt4DjbApk1EQlwsO4P
	10bQ0dggoHP40KYzRmPy0xvfdj2NHvKfBruEcM3O2xQTkq1lIh/iNq+YSyqhfJ04
	2v+AeMGf28izMAy8Js4ch1+sG8a3PGvhIR47XjwpIMAy7h7kNowoZs59P85nSUN1
	BzxXn0KecfPwubWgPzfJ6lUvb/aO2o97MpJZ7Pg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:eYvsQMfxRswqrlTYzhbXbXDZ2/EEpNu2qUOTKor8h6c=:2LpCRCF/B2VjwVBdyzxpo1+q3pH8b3+KYaS9M+RVBdE=;
X-ME-Sender: <xms:mRbJakj0c4RTPnqZWJCG68lBZZNEyxgQzur-422U9PrlcgfXeDlbeQ>
    <xme:mRbJajBSyw3MAngpIIDyp8mG_XWozQuIO5o4ai_KFI2MHdxpeiGDS4arlMhxGxiI5
    bcXp84VIhJqYSC1cspL8KI9hWa4x9HMjdmEhJXl4Fye_yWVRwm0uBck>
X-ME-Received: <xmr:mRbJapsU8iN5OPFQyVwqQbvibh5kHfxtw5cxuGv_1BBBvIwWMx9J771G>
X-ME-Proxy-Cause: dmFkZTGFEK5rH97h/9ZXZjk0FqUSGlhgodGZIC9s4KXU9Sctt8+Vg4Jp3bm/A/kJumfN9b
    uZgJbQ5kTlK6YgeUH+ro+AWL6jmkovX5Jb5lc1xfzB9ER9CvxtxHl/Yo3o00tuEhgqX4Yu
    +1isvJo8jT9gh5dqGApIpv/1GBl+rFHiEyzda8ak2m7wZ9JwEzl0QwrUa8lagtPv0aMQfA
    H7+svfO5sxDfrCbfbeXm5BLECE/zP+REpLo9KaFzgDksykbDQQ+CYr9tIPxYx/D2tiI0IH
    wldDoVx7d3PmrhGyDEKiABoaiiTwW/eJf1azSTMqOoSfgPcP7gdAeyVN6cQ2n6OtbcpAp0
    Fd0caN90rBMoXjG3471+ZrvAuEhCmKE8EiNkmM7vk/6XTAZDIt7Qn7jG2KOi2+BODIMM7I
    NKSq6o+jgvOpVzyXXwxdBjww9cvfAeQR32L+YP+l+Q3P7CTzouGd2NFyOjb5tJgWQl2YOj
    J2LvihCS9AhBgf4wr70EG6mTm6TvsYgsJZF4HDfIHa25o2ysaBAlhgpt2Y2K+fOn/gMzJE
    Q7VLNjDex5RSlbII3vFGAF/rdMxb/XbEDt3WSPcn/HP4c3IUTHsA/MLXIPlp//Ts/s828f
    YQ2AUXV7jhm9CtkkK4HShQiSVM4M6RbMp4P6F6RDSvr01z7+kRGQ/+KrFQRQ
X-ME-Proxy: <xmx:mRbJagZRVF0KRf-jjfemU3uX57H3p0RU65fYGp6p-i_S3DqsVnW3ig>
    <xmx:mRbJakVhAE1fnS2uio5kie_r0IIDAXukE506A5LttO0Vxe6kxrRVVg>
    <xmx:mRbJas5TwT_ZXObpJesX61WgC-cTrgAUJ8waLDcx3gIto1m_pQ8tWg>
    <xmx:mRbJanh1GJjl3Zw9w9pWz5voIxuweckcZUKJGnoj-BleJv7deyZfmQ>
    <xmx:mRbJaitMs8_NgKuFv3i3jY_Mv8iv1wC7bVlio5j4OuW6Y-DanqIrHt-O>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 9 Oct 2026 12:30:17 -0400 (EDT)
Date: Fri, 9 Oct 2026 09:30:51 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/3] btrfs: fix a UAF where btrfs_root::dirty_list is
 freed but still referred
Message-ID: <20261009163051.GA2648158@zen.localdomain>
References: <cover.1791497576.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1791497576.git.wqu@suse.com>

On Fri, Oct 09, 2026 at 08:43:37AM +1030, Qu Wenruo wrote:
> [CHANGELOG]
> v4:
> - Also cleanup qgroup swapped blocks and dirty_log_pages
>   Which are only released during switch_commit_roots().
> 
> v3:
> - Use Yalagada's v2 fix as the final UAF fix
>   The delayed list_del_init() call inside btrfs_put_root() is not
>   safe as another racing ioctl can grab the quota root, extending
>   its lifespan.
> 
> v2:
> - Add extra patches to address Sashiko's comment
>   * Make all root->dirty_list users to hold trans_lock
>   * Release root->dirty_list from cur_trans->switch_commits during
>     transaction cleanup
> 
> The first patch is to make lock consistent when accessing
> btrfs_root::dirty_list, btrfs_fs_info::dirty_cowonly_roots and
> btrfs_transaction::switch_commits.
> 
> Normally it's not a big deal as the existing lock-holding callers are
> also holding a trans handle, thus they can not race with transaction
> committing.
> But the last commit will change the cleanup timing, and Sashiko is not
> happy with that, so make it more consistent and shut Sashiko up.

As far as I can tell, it is possible but unlikely (rescan + squota?) for
the new callsite to actually do the removal outside a trans handle. Is
that your understanding?

I would prefer to have the bar for "shutting sashiko up" to be at real
bugs, even if they are sort of unlikely. If I misunderstood and it's
fully a false alarm, I would sort of rather not make changes to satisfy
its misconceptions.

Fixes look good overall, thanks.
Reviewed-by: Boris Burkov <boris@bur.io>

> 
> The second patch is an existing bug exposed by Sashiko, which also
> affects the last UAF fix.
> 
> The last one is the final UAF fix for the bug reported by syzbot.
> 
> Qu Wenruo (2):
>   btrfs: protect dirty_cowonly_roots, switch_commits and
>     root->dirty_list
>   btrfs: prevent use-after-free in btrfs_transaction::switch_commits
> 
> Yalagada Pavan Kumar (1):
>   btrfs: fix use-after-free on quota enable allocation failure
> 
>  fs/btrfs/disk-io.c     | 14 ++++++++++++++
>  fs/btrfs/qgroup.c      |  7 +++++++
>  fs/btrfs/transaction.c | 30 ++++++++++++++++++++++++++----
>  3 files changed, 47 insertions(+), 4 deletions(-)
> 
> -- 
> 2.55.0
> 
