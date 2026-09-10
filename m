Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF2951FCAB
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 17:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789059631; cv=none; b=bKOHYXA6pEYmlmeJN4R5vJzdlP3/TAVkiLgL2g+FRyNnYtmfYqZiIMYnMRDHh863XzQzAmd9BG9r9CcjiVUBQmvof59Akhx1XcqPC8iq9HE2/sFidoe0GQ+nvj6qnu3NMpAvOemi3tdvwG7vAQ/HxQ7WD5/sKccwosa8uLMKWOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789059631; c=relaxed/simple;
	bh=Y9hI2gPbrVC7MCgVbCVTPMVPUCBc7XVs1hxcHGrKcTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j4nnfiVlf+KNCuVi+cDdPmihmeVZ+2qnfZuYGfwnQ3oljfRDTG/ZEi61sgpEsdfNGRuCiT6IKu7OgEoJFTK7cx800TjinzSTEgzAeKcGpP76CUKXi8r/YA2dxop40D7h8m9Id3ae458U2wOazY19WibXm8M08Bfz3Z6JlanKdrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Kn7RO8gX; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kC8eF6vJ; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Kn7RO8gX";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kC8eF6vJ"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 91EFEEC00EB;
	Thu, 10 Sep 2026 13:00:07 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 10 Sep 2026 13:00:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1789059607;
	 x=1789146007; bh=Qt45clUYipW9QGy3HQ/Fzh0Cy6Gfsydjya4ZZeN8gTc=; b=
	Kn7RO8gX723fIu6Vs3wcuUqiG2znH87oTCRZXLf3vXUWTrbvni50eYpPPaaX4nZ6
	T/liGKj/0fFYLKTR8xtqxPKcuU4X+RnOu/lycxmWgZnntGxOBFYpl6XVK9jTn1Bq
	5hKs37YhhEG4UhxNU8qPEzW1ZGaZsdPqimFlCL7EyX9YQnK4+3Lu0cHMLK/4GJdV
	r58JbIFQF0XxXidp3cZ89aKfZ6wCbN3GO2XzgWzR6gP646UW8rmLBfr3+j1jvfc5
	cq0Yq2GxPukcbl4+SKjtyOfl/e4Sv6Ypz48Wp0u9sjdPR5CspszSDRvn48TH5zEe
	j3fp48ZMEWKG7sHIvekXVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789059607; x=
	1789146007; bh=Qt45clUYipW9QGy3HQ/Fzh0Cy6Gfsydjya4ZZeN8gTc=; b=k
	C8eF6vJUCtcD493GVMAdQjulP2h18eWnfrKQ6wtU8c/SSL13j9LiAxSWqoBqlK8U
	D33OnLknnSEXz3uEOG86BS98cTK3IwDNjOlflKEiCA2RqF12iJ4XN/9Wn1uEju/C
	YAx7H+G+1FMtM0uoHl0U+e2S8wdnZIwCZixtJT/HYqRifmBq85PTI5EPPjg2+58Q
	A8/MMI3pjlv+e2+6TSB2vRrcM2rq9el0ibYYJZkY1Uy6hRywzxH20YFrz0f2pBlA
	PuQ++2jeKZqeyorJQu0hLXlFUQK7L9Ad4gUdNhTLYVorOoWj1ZvgtgkHHK7Nwv4W
	wb+kl+/cfUgj3Ii5FRt6Q==
X-ME-Sender: <xms:F-KiaqseCAA9zCPvseYC0r7PrkofdpNhIB_C3eU1FdhQp0r1iaFZCg>
    <xme:F-Kiam6oeJBwLwxSzw6nS9iuffyJIuSrqDFyFpvaTIo3egtxqUF4OnoKG_668NMtP
    F1vMnT1bePz45sN3tkut6bcawvzpfG2N6z5Yu3umYmzfWbPlcwlk3Q>
X-ME-Received: <xmr:F-KiajKTmMgNv_Gbzlg1pbabcWufJcCIEp5Kph-b8mLAno_SIVUILi4>
X-ME-Proxy-Cause: dmFkZTEa5T4xrvmuu/bzUQKpB7q7fu3P0dj+CFMFcJgBi4LpGkBb8cKPsZ23pkpHScoGQp
    NWoPzC2Kh/O652djK3vM5dBEoDeCy+EGZ3xcAO51QjlcJeiGt2swRMESUMhP8TrRQl0p3g
    tQO5sze88zdGzF0Wf3UP6DnukzMKeHPXcoxnGKPwHAW4hT/T4uU9d+zR8c9aD6tAYzs9ZT
    nQzVYeuXEgl9caZAtDDAQOp7D2AhkCYnzHU+2SnLDlNqy4Bu1qnfTSLw+j1HRxuukYjL43
    vJK5G6GODFN0TnrUUPTTgtvKkfNVk04WgYTE5p7VHKGEQ5Gfyhg6v+ZDo9mpzYqupQVPbh
    8JC2B9dgjNBeBLbmDpLeN1FtakyZEAH1WMpfbEib4+M7zLF6Js6/Tf5S49DQUbCZMjTfvQ
    Rh7Mc76h2nhrh6hekfhR/s3zWYKG0h0rUkDmB7y88MqJdlwxjS9BHwd8FCGhfTVbkBU8rU
    pCg/wPgPmuXW6ccpi8LOKmAxwyXOZ7+htkjSR97WDDn7YdkouVGaN02Ac9BhkZ1m0Ltm+v
    igNvNRlbdVv6OAOlptwJNKWTiI/M2BrBWHr7lPdNucmcmfddX/2a/rqErilDozUXLCOYYR
    FQgnPPoFcj9CSKmP7kpBkp1F4EY68PlMRDKSxxwAlFrYzENmeRXGLlbvzsww
X-ME-Proxy: <xmx:F-Kiau4bGHT1dqe1biY3SBUnoNcX9CdC1hWL6UZ-muJU_WBSL_sx5w>
    <xmx:F-KiauwzJaU_mOgSDM_dZhhL0XiTaokV3Q6Ugw-gq9E_Fhg6Td61Jg>
    <xmx:F-Kiaqaknk0inJQyESebA5BvHAAinx8R4h3-hb2_Ef8kLEhAdN2yiA>
    <xmx:F-KiaoRIVL9jtFEZ9PKsJuCvB3uElHYl6nDQNASWsI-8UQ5cj3x-pw>
    <xmx:F-Kian61SfOgsWiXcbhbtD311j--OfIuuVSr-ZacS7FMeoiJDQdpk7DI>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 13:00:06 -0400 (EDT)
Date: Thu, 10 Sep 2026 10:00:33 -0700
From: Boris Burkov <boris@bur.io>
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: downgrade the reflink source inode lock
Message-ID: <20260910170033.GA1435303@zen.localdomain>
References: <65fa79581e1d29d6d6fabae71d23e741bff0ddf9.1788974902.git.boris@bur.io>
 <CAL3q7H5hG8MKbf4O5LhUJxg38BToPuOY69gjfc2tQdeUM5PYjA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL3q7H5hG8MKbf4O5LhUJxg38BToPuOY69gjfc2tQdeUM5PYjA@mail.gmail.com>

On Thu, Sep 10, 2026 at 03:31:57PM +0100, Filipe Manana wrote:
> On Wed, Sep 9, 2026 at 8:54 PM Boris Burkov <boris@bur.io> wrote:
> >
> > When doing a reflink, we are not writing to the src inode or modifying
> > it in any way, so it is counter-intuitive to have to lock it
> > exclusively. This has the cost of blocking other shared lock users of
> > the src file for the duration of all the writeback and reflinking.
> >
> > One sort of counter-intuitive exception is that dio writes that come in
> > under EOF try to take inode->i_rwsem shared, which would result in
> > messed up views of the extents in the reflinked file. Therefore, add
> > "being used as a reflink src" as another inode flag exception for the
> > dio write shared tests that already exist to check for other dangerous
> > conditions. In order to ensure that this flag is visible to the dio
> > writer, reflink must first take i_rwsem exclusive, then set the flag,
> > then downgrade to shared.
> >
> > I tested this with a concurrent reader on a 4G dirty source file
> > concurrent with a reflink and saw the read operation go from a ~1s
> > latency to milliseconds.
> 
> You mean a direct IO read operation happening in parallel with a
> reflink using the same file as a source right?
> And reflinking the entire file?

yes, or doing lseek on the src, another i_rwsem shared user.

> 
> Because we only take the VFS lock (rwsem in struct inode) for direct IO reads.
> 
> However during reads (both direct IO and buffered) we always lock the
> extent range in the inode's extent io tree, and the reflink also locks
> the range.
> So taking the rwsem in shared mode won't help much unless we are not
> reflinking the whole file and direct IO reads happen on a different
> range.
> I think that should be explicit in the change log.

I will make the test cases much more explicit in future versions of this
work, if something else comes together that makes sense in light of the
bug below.

> 
> 
> >
> > Note: if a writer arrives mid-clone it queues on the rwsem and later
> > readers will block behind it due to the rwsem fairness implementation.
> > Therefore this change does not rule out all possible reader blocking.
> 
> There is also an issue pointed out by sashiko that seems valid to me:
> 
> https://sashiko.dev/#/patchset/65fa79581e1d29d6d6fabae71d23e741bff0ddf9.1788974902.git.boris%40bur.io
> 
> As every direct IO read and write increment i_dio_count with a call to
> inode_dio_begin() in iomap.

Unfortunately, I think this bug is fully disqualifying for this
exact approach. I didn't notice that (or test it, clearly..)

I started this line of reasoning with pre-flushing the src outside the
lock, then found I wanted to downgrade the lock for the extent writing
after the prep stuff, then had the "insight" that just downgrading would
have the same effect but missed this detail. So I will try again with
the pre-flush + smaller scoped downgrade.

> 
> Thanks.
> 

Thank you for the review.
