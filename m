Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A038A34F24A
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 22:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775600014; cv=none; b=YW+pcbMlvC2y0455llBgwb/31Fgzc4ipUfOFAkq+Nr6zOh1MRsgORg6mTzzY2bB00T5qNkBMVrVLN4qdWJgeXa9PWYYRjUxeVlBTtcpsWbeP5ObNVPoKAfnqAWsDvf5o8b3gVRzw/XpH8xN4iZPxB5GmC0MqrvdBHic3qVIm0MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775600014; c=relaxed/simple;
	bh=x4aFynfTWIUv1ijYr1z7y+swso0jAQIVlWIxPPF5NBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uIqx3rmdBAF6v9+7f1lC0p8dDLKEYSKvFivJWX0H/PWrBEbvxOviCUXAvlpBqQUBc7045TVDC9X7lFaqGicksvlTV9aPLYQXnGyCcsL9l3l7bN/ZWZWoymJRusVbDEXxUm563pciRUNPhRYfcLMBl1sTmPSiCBtQAhOV7TlS61o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=fR18/MIO; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ZGzliE8j; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="fR18/MIO";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZGzliE8j"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id DDC4BEC0110;
	Tue,  7 Apr 2026 18:13:32 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 07 Apr 2026 18:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1775600012;
	 x=1775686412; bh=qFcC1LnwKu/aXuhdqlg0OuDGnqIHqbiawpCkiylC+TI=; b=
	fR18/MIO18qHfzjQ2wDdsv/Yrd+LvpB0GQSj7VsWn1YdATnpVrcUUI2c92jv/f/u
	rwPHhHVDGkaf7fBJPib45Q1wfO33Lkv91iOTN4QEjW2dty84Ngs8SpHeHevG+na0
	TgrDJdWWZcJbU+ipRxPBUwwsDodTMuhw/BskXKNSliLsDm/ehVkYOGl68ZbeiB2h
	jp7y+KlGpmbrr34fUsZlHsXBOK8UkC1YHhiQnFRpAf+Mxx2qf48ES0pImMazYmtS
	+zopys4NJl9F7Xy5H1+4xDncC0a4bJngfxhcZejT9ozCVL39magrDeLGg+MucAY+
	BhQUwTZgS8wnUOsV7eusDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1775600012; x=
	1775686412; bh=qFcC1LnwKu/aXuhdqlg0OuDGnqIHqbiawpCkiylC+TI=; b=Z
	GzliE8jmaD0OnOktIs4r+bDHO6PnhFU9molfazgMI+7RJyHjW6tnMRCMgPoxQ7RV
	k7KOFPX1g43lWjvntnyKVqBK2zYeGbw/F9aQPDHZy52FgMcbCSyxP6YzgAj3Sute
	te5/ZleFLChXUlSzOMstsLp/+25KMNC/3+QFBGBDJUFeIF7hKMR9Xu/NfyYsKVKQ
	/v7vLbwHNlrbvIRpwSmlAwKlyctkpavmm2vofhpJ+GLLRrdIXyekpNs6X3pHrxZP
	NExPTz05mKMyVStqgF0Qq3XnO1WFmnnCcNPWSSPvtO6s7pECVUorb/PN4Dj5djqo
	GA/rJqZaJ3pvBWIH2SCeg==
X-ME-Sender: <xms:jIHVaa9WsEWKiJxrclMTOqM3OVeiNfrlTXa2Tn9_f4k-5Ft09tpoOg>
    <xme:jIHVaSIaHHdXKv6j042kebCZMU76FlCNvtwuWeU7XrUPHPhM8glCE7SHb_RVDJ_xu
    g9J2nSmDt_uoiBpY14Q02acoxeK9-I6mTOpBI5YxFck0uyVKnw-PQ>
X-ME-Received: <xmr:jIHVada0R76aPywSHE7oPL8Y-IEJdYBGGTlb4Bm9yseR1Tl5xjikVGCC-WazfC3chsOK2dfA1JTgYTMgkM7KN2Dh76o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvudekgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpedule
    fhtdfhteduvdethfeftdeitdethedvtdekvdeltddvveegtdeuuddtiedtieenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepqhhufigvnhhruhhordgsthhrfhhssehgmhigrdgtohhmpdhrtghpthhtohepmhgrrh
    hksehhrghrmhhsthhonhgvrdgtohhmpdhrtghpthhtoheplhhinhhugidqsghtrhhfshes
    vhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:jIHVacLGEqOzg1NyWOvI1Oeh-pZ-QwrTkMBafjGfCjAyilzdBYSCWA>
    <xmx:jIHVaTBoyi60f9BfNARraPn_2f-knScBfgeKr_ZbH21QKqbidftt2w>
    <xmx:jIHVaZr9mnzO1C2SyIV-v5svQZrhH66hiDyQ_DYRy0-S24Z6uxrXdg>
    <xmx:jIHVaWhgoREVPIOB9u3EyRoo0SOnm4QDDYqaVi7_oJxB39CbxQuOfQ>
    <xmx:jIHVabaMjtQuje17KAfSnkt8BryN2ZC_OKIeZJDOvYGY4q7xaV10wiYZ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Apr 2026 18:13:32 -0400 (EDT)
Date: Tue, 7 Apr 2026 15:13:22 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
Message-ID: <20260407221322.GA1579772@zen.localdomain>
References: <07cf5ebc-ac52-4fd9-82c5-404c0f4d6056@gmx.com>
 <3ad267b6-cc59-495f-b385-9b4b4686a473@gmx.com>
 <39496ce5-74c2-4300-ba39-032edace4cfe@harmstone.com>
 <a1675480-628b-46ba-95c7-f5ee29d6bf14@gmx.com>
 <97ff76b9-5c07-4083-a020-3499ff595460@harmstone.com>
 <e6b4ae42-8b83-487c-92b7-6f91c70e1b6f@gmx.com>
 <20260403224449.GA1806609@zen.localdomain>
 <2bb3df33-a9e0-48fc-bff4-957c7d7cb8eb@gmx.com>
 <a40afd17-bfb6-486d-8632-9663d6cf7ce3@harmstone.com>
 <7c2377be-ceca-44ce-8bcb-e201d142b4f8@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c2377be-ceca-44ce-8bcb-e201d142b4f8@gmx.com>

On Wed, Apr 08, 2026 at 07:22:44AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/4/8 03:43, Mark Harmstone 写道:
> > I think all three of us are confusing each other a little here.
> > 
> > The ioctl answers the question: if I were to read X bytes of data from a
> > file at Y offset and calculated the csums manually, what would the value
> > be? To which the kernel responds either with the values, that the read
> > is guaranteed to return zero and thus we can use the precomputed csum
> > for the zero sector, or that the value isn't known and userspace has to
> > do it anyway.
> > 
> > The value isn't known if it's a nodatasum file or if it's compressed. We
> > store the csums of compressed extents, but crucially it's over the
> > compressed data. So there's no one-to-one mapping between file blocks
> > and compressed sectors (by definition, because it's compressed), and
> > bookending means that it might be data we don't have access to.
> > 
> > We absolutely can't give non-root users csums to arbitrary data, that's
> > definitely a security breach.
> 
> If getting csums for random logical is a security breach, I do not think the
> new GET_CSUM ioctl is any better.
> 

Isn't it better because you have to use a file we do permissions checks on?

So it's not an arbitrary logical, it's a logical used by a file you have
access to? That might still be insecure against some attack, though, what
do I know..

> > 
> > Userspace can already obtain the csums from the disk for a file by using
> > FIEMAP and the tree search ioctl. But I believe the consensus around the
> > tree search ioctl is a) that it's very difficult to use, as you need to
> > know the internals of btrfs,
> 
> I completely agree with this part, furthermore due to the layout of csum
> tree, one has to workaround by searching with a much smaller value than the
> bytenr as the min_key, which means possible unnecessary reads of previous
> leaves.
> 
> Thanks,
> Qu
> 
> > and b) it requires CAP_SYS_ADMIN, at a time when containerization and
> > finer-grained access controls means this is frowned upon.
> > 
> > This ioctl is a simpler way of doing the csum lookup, and without
> > requiring root.
> > 
