Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86274BD78A;
	Tue, 15 Sep 2026 18:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789497360; cv=none; b=NgeagkfmVv962+DVwKM0TFYF8alQWFs+0YAhXs1eEEV3vryvNaatOfgGcYsfTyq/TfH2vkDK8t9JPw/LG2OP2UML4gH36Vx8GmqmVoX1zZPIezYUuToZ40o6OiueSl2roSijdfMLr6VGR0N18cr9iLImvXiogq/FhejIi4zmhbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789497360; c=relaxed/simple;
	bh=c733wWpdqVIMRxnjGhWMjcyD+R56PTFs8Mhe2Se+6nA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Izdyyg7aSzluOstj+7BoEl3asBo5owV6JLqazJuRZfTjgJbeJRTtH6LkgRTn6Rl9nt9WaxSMV3DRoZFiYbLuLjnodiovaXT4pfiVSyKTh/dXrUBGHyJHnv7IFwId6E23V7lDPgN/fhdGVcDOOnsRyfhshhrb4GYrLanu679p8+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=kMw+/HxB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=x6fDP16m; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="kMw+/HxB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="x6fDP16m"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id F26801D00246;
	Tue, 15 Sep 2026 14:35:53 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Tue, 15 Sep 2026 14:35:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1789497353; x=1789583753; bh=Zc05Iayuo4
	SX7CCCsPqsDRbeAskqeBW4oEA8Lab4eRc=; b=kMw+/HxB7oN6Rm1ilv/ZXAtcS0
	zD+5LQQvJkGrWGSzjUuja1un4hyEqH8kM6ALBGrpzIARY3HbubjUY4BM8rLT222A
	7reik+scyoQHDyTYvje81lnhM5dVW3QbUO7982/u1egnXalLnKpKRhLubzNqjj9n
	lugoaDra7NO9S9whguKOBAQLQlNdgrI6VrDRakdPuqoPegV9UO+YnDh7dYbt2dWV
	iG3aeikN6m5FQraflZLYvUstgo76tJC1fkk38wqJ0YIwrkElPyNBAn4wq2YYpXbf
	bJ0Ptc9XRtLha00BKa50G4tmbyAiWscNnZNFVgN+jZ4zfO5U4b7BDFZhzOFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789497353; x=1789583753; bh=Zc05Iayuo4SX7CCCsPqsDRbeAskqeBW4oEA
	8Lab4eRc=; b=x6fDP16m+ZeBL2JPdI/XtmwZ92AvlMjewshGQS3gDJbiVaoGk1v
	bR3LF6TEMwJKKlfbudWlk43heSSq9KCjOqZP9H4F3/gnoCF50cOljxCThB0tdtfD
	creXBnRORDujpTHeAqKjDiHBH/sGpN1/OhcKES1HVuotni1L2YXwNg4hEcMgGKa4
	AkTBvS301gENuBc19m0hw2do/upF59B1yPdsTu4yKZU+TSCciKyBzCnVNZXcy67j
	pmycEXyz8yZfqTF4t1vJMtFBAvzctBM6yMF2ke+jOFTNIlIiXvIZ1+vtrB1JsM99
	FCRNONKMpnPtza6v9y3G+XBGtBcLa/efK9Q==
X-ME-Sender: <xms:CZCpanQc8qGjr8XGAQoiwPC5xxT2RVNKzz_xPwvZOyoyn_kcZgDB9w>
    <xme:CZCpajt0xtvmRuQzy_-P_C8EJOkmgqqYExnRyDaGfO9_HONBlslTGZEjgOU2geZbA
    9xhQKiy3jhOMf3tDD47tPpaATg7Fal-XmleDrqU3pzqCjRGjPaq8A>
X-ME-Received: <xmr:CZCpar31WD6i9ah6983HHjovdpEEUVm3f6tZXi6AkEo6SttRQrYlySU>
X-ME-Proxy-Cause: dmFkZTEbRu7TkIlj+u9bpDDUeAK++m5/0yOsqV7nrzAs43MgjmGUbxE/DvFWXxMgQZohnc
    0mCsPT5+e1VuN3skpzzuBj3JLXFu7XAolq/U4dST4uToLl7Rqr6DrwKSEAmWg07T8+lwOe
    /HRlcSuvBE5wkLZTU1nzKtOxittX0fDRnuxATY0Bhe6aCSaqu7qsAodiGNYC35uUmX4Mrw
    3Y8s47cCBSJkZn2jmmYJKDsY5zDGsHamv6oKK7kY1HuDcRZaQvzi3rM+hNMmZCOlJficSF
    /ez8VGEi+KpQAkSeI6yy4P1ZKDzqlP76ECTAK7Qyxi1sYHh+Am/NA9DcQWTZ+7y+3Xy4oq
    21HNP3txm7gCKai5QZ6KqL62YDp0elxNp7qSJbu3e24VKzIPx4uvsVJSfvAxXs1vJl3vbU
    k3FPJn+vedC90vOSxw4RzGnv/acMumrKBn1gBUKAHhTJnHQfaUKtDrBEcXUNY71bje3Qol
    SgaPWedBC+YLFN8oLicvsfnjhwfFc2MZdZcTp0KqZRSuve5oZWYy+1NcdvW8nXbhCMwyoP
    pKr4U4vG6NyPzZJ3xOHw6dO62B05a1/g+SdrqDiDfF6QlUDfxctTnsAQ3ezBh7TpAzPGHd
    lKavbLZ+ZTMV6eL27Stmg0+2YioRtanDz+EDanXrAcz9Qx87bpAqTGsAkqWw
X-ME-Proxy: <xmx:CZCpasVzsucHNEyLsfdgqh4wMe_VXPkxK2pPNSi4H5od347iCDSCkQ>
    <xmx:CZCpauIk3nUGE9ZYcVlB7wnaEPfLYVvSzhacL8fuwkYfHk0qcTfWpQ>
    <xmx:CZCpam0uwE8tfSxEKpFwsYrLNx2dobFhyBjhcxt6kELERFXMrETeOw>
    <xmx:CZCpas6GujjCM_7i7W0uSu5DpF02-kzKf8nM1jjye96z9h0bQSmtwg>
    <xmx:CZCpapZtsVxT6lnsJlIg4d0lljxBxGGGFDVUotxZ-FSd_bZN9DnrwU23>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Sep 2026 14:35:53 -0400 (EDT)
Date: Tue, 15 Sep 2026 11:36:10 -0700
From: Boris Burkov <boris@bur.io>
To: Guanghui Yang <3497809730@qq.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, mason@kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: clear free space tree state on rebuild failure
Message-ID: <20260915183610.GA910335@zen.localdomain>
References: <tencent_F71ECF81628C274CC89FDB3304420C2D1506@qq.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_F71ECF81628C274CC89FDB3304420C2D1506@qq.com>

On Tue, Sep 15, 2026 at 02:48:45PM +0000, Guanghui Yang wrote:
> btrfs_rebuild_free_space_tree() sets
> BTRFS_FS_CREATING_FREE_SPACE_TREE and
> BTRFS_FS_FREE_SPACE_TREE_UNTRUSTED before rebuilding the free space
> tree. Several error paths return without clearing these flags.
> 
> This leaves the flags set on the live filesystem and affects delayed
> reference processing and free-space caching. Clear both flags on all
> free space tree rebuild failure paths.
> 
> Fixes: 1d6a4fc85717 ("btrfs: make clear_cache mount option to rebuild FST without disabling it")

I don't think this fixes tag is correct. In that version of the code,
all error paths aborted the transaction at which point the bit being set
or not doesn't really matter, in my opinion.

Unless I am missing something about the importance of clearing the bit
on an aborted transaction, I think the better fixes tag is:
882af9f13e83 ("btrfs: handle free space tree rebuild in multiple transactions")

> Cc: stable@vger.kernel.org # 6.4+
> Assisted-by: Codex:gpt-5
> Tested: make -j$(nproc) fs/btrfs/free-space-tree.o

Is this all the testing you did or did you also run fstests on this
change?

Generally looks like a good fix for start_transaction() errors, though.

Thanks,
Boris
