Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C63839EF0A;
	Mon, 31 Aug 2026 22:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788216488; cv=none; b=IKsUloDfErANVXIRfvmfWsitNl5A6P5ouWzw45A2C37aVaJYHy38H8UnTu+reI+ny2hABF90564/Pq94rHBINlnL0fBEp9Axsa/3UF6YOT0wM8ECVnaXxKfcWVt9hfZVuMuhHxRXt9ORZ6ZE2LOntcTIX0dp2mnEcZ9o99oklMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788216488; c=relaxed/simple;
	bh=uLHglZLNnriFy98FkYTVFUzawqLjZu2w1dX7Yspiz20=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=LBc5VugQxNKbjP7HkPTozZ0Avop1pdnJFE8ODV52gptaur0kHPOOvkKYX0nQbPADHxi8mwo1UH7si/jda9R8CI8rZdApJ1z7PvB4e1x/f5FM2uFbTCSUi2daXhXqfHrtdSIH5gUusCiPT2wgdp4yhDT7AKhio2s1GqO4rK/+ses=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=GEf/wxIv; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jn62l5lw; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="GEf/wxIv";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jn62l5lw"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4ECCD7A0172;
	Mon, 31 Aug 2026 18:48:05 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 31 Aug 2026 18:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm3; t=
	1788216485; x=1788302885; bh=+VhNKuFMalEnZumYxKzwX1twJM9G1Su8XVF
	rWyfCT8o=; b=GEf/wxIvrfd61DREs0gT37jMTXz2FK2LJPR++0AZLVn4jGeQvhy
	qgG8lB47LL65HM9DIs4DFFCFtkAPoEVSKDyj9a1Od80D2tUkviNTKZ2uiak7gAVU
	Kzof1jvz2HN5S00OXztXOChyphaXvoZF+oKU7lspofs+FcRalCqYrvqi2SKRxRld
	MKQ5LUa0u/DP9Q+hps9J4pC+nGW5jiX71zGLfncCW+yXesa2F37dpD+etQII2JRM
	F906FRV+A1X8B/qqjlMi5Zvkg8NYb4AjIzRAyvvgekSFPPqIKGeCm2Q+vxyDNV8J
	2DrS8D8BwVNPHaRy989UY7KbPbQ9d0dVdsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1788216485; x=
	1788302885; bh=+VhNKuFMalEnZumYxKzwX1twJM9G1Su8XVFrWyfCT8o=; b=j
	n62l5lw62QF16Bx7DO7VyrR1yu+7TghtVZIQFbxtbZ3bo+TH+tF/Czu4ZIYlFncD
	S5xEUH9Ivj7Jx7sDFEb9lo4dzla6FMpMijNrdMyxeh136PMxMl8mVX5agFyGXF7u
	cCxemRISS4dtrbgTYSL6pDTcIeT0674IDb53NKo+UHoMaTafxl9ys05Vy6cULPU1
	XwB8dZXGjHU6jJdIPOsrSWo2ZFIuZQKGwt/0vwKkG7i7nX2h36c4rKFEARfCPgqi
	qDHs8dokJcvwfYJglRFEYBEQEt85+asSnVNfF39vxOQgAKDzS2RD7P/UQhvobobM
	mLiRncJduxUVXHDxoSG+g==
X-ME-Sender: <xms:pQSWam30iccz3IcnQSxNX8k-wP_w8kXaEqaMbl7m4GJaVFxQnG8dYw>
    <xme:pQSWaiBaz8VC-KKJKZ3sgmbDzp3qaqoDWbvsrV2B93e8_yK5rNe_cwvhQRKADYIzQ
    wKvpl9w_JMimljqxphLvZY5l3Tccx6wEGsEwFrGXwNephkDUk0>
X-ME-Received: <xmr:pQSWaqdn-6_eAjvA2kirJb9HakCrzFiknjsfavxcel7CYIh2x6da95v4lUkshaonX6GxxKfCKNzjGAe268q1L6nqOCpJi_k>
X-ME-Proxy-Cause: dmFkZTFmivc/wJOUNTciG2iu8+Rtx2+CjLSj/FuxQl+aBzbcecalevRMv1c/BT7x1u2BBa
    US+N268rjjgeAlds2GsxSBcz9m432amQUEPk9lWBMJeJggPack9UqFo55Zm1hoTNDUOlAS
    nz2VUwgttneRryElKNKcqgQEPIU2UOZxIhptMm1mciEgD+GjyDuR8FgCnjNludEHWhjoFg
    TvWrz5djcOnh8PuZ4/cLDE061qrQmVUN6So7HrP8YE5ZhMLUm+dUl38SoOqIWz86NkMBQ2
    lYUlkyIG/JeW0Bo5mrvFvKoZgIWpbJ5LlXOvAXVNXJM73rXMYAQHpV1iJAXTAvmaTPdmk/
    jrAUGRuaACYZBhiQhUSsG7Tc7mW6sFLPLU0FApoZ8A2r4AflFM9ce1dBvCNYkZu7gZnZVI
    QhE7q6NouxwR4l8IE9CnImMasuOHoUaR3O0y+qxrmgMx4jCuQBKsz7uiX8HdP9hzekNJye
    GLC836bIZX10+vJMQeq3F6nwMQ3lF6uERCkW2N7JRuOCDzC1y/u54S4aY9yJY1mQlBITP6
    SaHeT8RjRJZePOKNMfLrBaGBAXsRyChVzrwLjrG4pO1J09zudCQfk4UU0VXsfbUamfLuap
    4VEIm/l87WrAgmyVj5tUBGq7rA8fv4SlyZ4el3oTrLulrwUQqPUG95IuH2pw
X-ME-Proxy: <xmx:pQSWan5tkCTW_Er4ODdsRjsbQAiJPxW7LJDWbjvRTkWE4pHx1w1sHQ>
    <xmx:pQSWalUtydAJu0SEa5urCnadYgJEY50O-rNpeLlHuDGwS9pSDfZBpg>
    <xmx:pQSWau4arAgoX4ZwS5m04ZoxTUgeccjGXXz7G56DsZ5pZc4aCszSIA>
    <xmx:pQSWaooaV-98G732Gc7r4Ai2f96T4VppE0QiKi6AH2cXE4wdHe_-ng>
    <xmx:pQSWaoR8ZdxDDu1YnDeRn3Df9Yb0HyC7d5gXFw-lHXds6OPhalwcvZz4>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Aug 2026 18:48:03 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Christoph Hellwig" <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 "Chuck Lever" <cel@kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic: Add test of seek in directories
In-reply-to: <apV6seOac1Ynq19a@infradead.org>
References: <20260827234743.2389778-1-neilb@ownmail.net>
  <20260827234743.2389778-2-neilb@ownmail.net>
  <apV6seOac1Ynq19a@infradead.org>
Date: Tue, 01 Sep 2026 08:47:58 +1000
Message-id: <178821647879.3510150.13369288580807708176@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Mon, 31 Aug 2026, Christoph Hellwig wrote:
> Please include the mainling list for the file system you think is
> buggy or at least odd.  Done now.

Thanks.

> 
> On Fri, Aug 28, 2026 at 09:36:10AM +1000, NeilBrown wrote:
> > The test then reads the directory to find the order of the stable name,
> > which should never change. It also find the "d_off" of all names.
> > These d_off should be usable as a "seek" offset to find at least all
> > the stable names that came after that point in the original listing.
> > 
> > After creating the names and finding the order, a loop which repeatly:
> >   - makes random changes to unstable names
> >   - checks the complete order of stable names in a new readdir
> >   - checks what appears after a seek() to a randomly chosen offet
> > 
> > In Linux 7.2 this test always passes for xfs and ext4 but fails
> > for btrfs unless we suppress renames with a "stable" name as target.
> > It also fails for tmpfs.
> 
> There is no requirement where the entry for a renamed entry is placed.
> Posix requires telldir/seekdir to provide a stable cookie, but how
> that cookie behaves when the directory is modified is completely
> undefined.  The same is true for NFS which requires basically the
> same, but more stateless than local telldir/seekdir.
> 
> 

I don't think the behaviour is "completely" undefined in the face of
change.

https://pubs.opengroup.org/onlinepubs/007908799/xsh/readdir.html

says the directory stream represents "all the directory entries in a
particular directory" and makes exceptions:

  If a file is removed from or added to the directory after the most
  recent call to opendir() or rewinddir(), whether a subsequent call to
  readdir() returns an entry for that file is unspecified. 

so "all" doesn't need to includes things that were added or removed.
Does a rename over an existing file "add" or "remove"?
It depends on how you understand "file".

We are told "Directory entries represent files" so we need to understand
"files" in that context.
If we considered "file" to mean "filesystem object", then the above
would allow readdir to ignore multiple hard-links to a file reporting
only one of them.  Hopefully we all agree that would be wrong.

So I think "file" in this context must mean "name" (that is the main
part of a "directory entry").

So, when we rename over an existing name, is that name added or removed?
I think not. It is critical to rename(2) that the replacement is atomic.

With btrfs at present, if a name is the target of a rename while a
readdir is happening, that name might not be reported.  This is because
btrfs iterate_shared deliberately skips any names that are "new" since
the start of the readdir, and it considers a name replaced in a rename
as "new".  I think this is incorrect behaviour and could be harmful.

Prior to 
Commit: 9b378f6ad48c ("btrfs: fix infinite directory reads")

btrfs could report the target of a rename twice in a readdir listing
(but always at least once).
While I think the duplication is unnecessary it is harder to criticise.

NeilBrown
