Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88773421F10
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 12:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780574833; cv=none; b=e5/M9uYLSyVt9ABY2o3Uf//JMfEM57xc/MiNgAlObH8ltxddjHGjC4mDLZJaIvpKnx5NxAZeQRUTbDj1PEOvaRMhK0GKzO3WnKT05apKGPgf8pHs+P2Zy+0zmllH58p1lOQuc4/f/RzW9uuac/i0jtxSf3KJV5MXNccBwwOEqJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780574833; c=relaxed/simple;
	bh=gwabwTh1oLc7n50t8M1tLL3SFy7kBT1az2bJBNlBnfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X08XzAmcEwRxoaoAM8TTw9v/gteqRm3rUedgidg7i/3+ryFcKEznVsxG7lffDMI99EEThjYG83xp9vXrZI6NtgSX9+O/kr2tWb9tgLfsHc+Ff6fJeHTsiT8n4km9fHyrpgl5YfIft491mU/5ywOvENb2dETZXB1ybl0z6wwY9QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PKlgbyUr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AU6s656z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PKlgbyUr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AU6s656z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780574829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vez+3z7s+CL1O/+Z7LdAw9UEUl93TBeC4vinR18yFpA=;
	b=PKlgbyUrijCDT7TNd+K6TEJ+OWo9tsKbtrlouGBKlarS0DKDEGEQn61Zub5rv1aPcMMcnc
	dOIBa8yQzgJxY7HQ/DCf0Y1eKqVDBIcRJY9Y5qpDNA/BLdmxpV3PnUtacRU+l1n1n9GdD/
	T8pWDbsxfmyD+34lVXaV8eU7BW931Y0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-mSeM2b5VMvSXwJBAJ2ftsQ-1; Thu, 04 Jun 2026 08:07:08 -0400
X-MC-Unique: mSeM2b5VMvSXwJBAJ2ftsQ-1
X-Mimecast-MFC-AGG-ID: mSeM2b5VMvSXwJBAJ2ftsQ_1780574827
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45eef10d5ebso328933f8f.0
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2026 05:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1780574827; x=1781179627; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vez+3z7s+CL1O/+Z7LdAw9UEUl93TBeC4vinR18yFpA=;
        b=AU6s656zQQRDxFDH45/vb75ALH+0Xe7ibpssaro4hL4Ka76JWwvEPi99e/7ODHkWEt
         qxjIYIH0cHoh7YTNjWQ+W1SD7AMnu4CmStiybpT+YKjhuTi4BjZreJQrWqrzgEEoVW+t
         f1PXbpj9KbR7/UFWyM6xd+/VqN/LkrCLC5PXqEiN4dFtUJ8DtWBGKTaGfBPcfFV4gLoU
         D+D1b1tgq2Rk9VKXfSeLwEuBYv31rTUwpNtujEbqnJnf2lHsI5axRLmDMaliLbUQmIos
         mb0YjW9llHypxnirzxNzqY2jBqyiNYr00NqUAIm2lagUbICHyOPRDI2yxaXa9kbETwyb
         p2HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780574827; x=1781179627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vez+3z7s+CL1O/+Z7LdAw9UEUl93TBeC4vinR18yFpA=;
        b=f8gRq9TI4ts+K2KiiobE6DrInkIz8CULLxy1EjDJDtdYrG5bWu/kgvt+AqXwpchw6E
         l3SsRH3bdQKm2vl//wRvLxD+Hzge+ZOOXNW00ENp4WJm8wS8BhmVslODmHjyUkejxMKa
         K0JyBPYh4OcgW+jfGBt6SIopzmCeqlkBC+ksGU1s0htjEhbUPtOvIBxw/qInSW07SDnT
         TocFI55ETSI23VFPCDEYkfXyzm6ZHhwgwt3I9AU6SRElBvMC3v4MwI688HJY5/Xf4E0i
         MDUkLW1dVvitl4avMRdmi0Mb0zJy/sHNoGYC46B0YfU4LV/iMogsnDGzSDTDgb9mUPO2
         RrOg==
X-Forwarded-Encrypted: i=1; AFNElJ/xpjht0ikzt65Lf2L8slyDUK1O9DctgF3od04aiGzgtXnY2c8hS0BiQ6INyvHjaqAjta/FDRvYz4nOjQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoX8fvYPT5k5rjWGOIPrIkya1QzOYy7byI7QmOz2pR1VyVYE0p
	pgn55PIbgf+XDUZwXoCPRocqfprivr5Jyb0T1vu+JiTlws6qIvkMpsJiba3RPV3kZfKhiTbfH/X
	eygNNqEId5K27VjP13cFkUyUvAiSpDGR+ZZON14wzhzZEMvDsMyxc90mMrELfLDo=
X-Gm-Gg: Acq92OHUw4iyqNwQs7zaCQjWfxq4bbc7WyMdlernVHp/QR1C6vFu6Xdm8HDTkIZveX0
	ZoZ6EDcjbXtNmS8ehPAagseZiFuWhvLn/bO/aBl3NIb9qL+gU4EZslr/s0/G7YCmSzTDkW64K7o
	40h1El1KqqLOJxfwTS6Mw41fSGYELj0kdKBFj+wlDyfAI5d+cIm81C35R2MC+hDnOmgDa4qpfeZ
	emeCro1+w7NtPXDoO5WD3LWJwdBqTXZYy5HqiH5c3d9kVKaps5rpgGe6fAYoX1WsDk0FTEid64V
	OWsc3UU/4d3q6/3JePLOdcgr/YOx2et6NWg1OlOaqtPuIlLoXTwW6C7NHWGSy4Bh3KnMUVsQZMo
	Y52eWKvl2MM44xugfDIFDqA==
X-Received: by 2002:a5d:6188:0:b0:45e:ea3a:47d6 with SMTP id ffacd0b85a97d-4602185fed6mr8733075f8f.32.1780574826825;
        Thu, 04 Jun 2026 05:07:06 -0700 (PDT)
X-Received: by 2002:a5d:6188:0:b0:45e:ea3a:47d6 with SMTP id ffacd0b85a97d-4602185fed6mr8733005f8f.32.1780574826279;
        Thu, 04 Jun 2026 05:07:06 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2e4004sm15892014f8f.9.2026.06.04.05.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 05:07:05 -0700 (PDT)
Date: Thu, 4 Jun 2026 14:07:05 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v10 00/22] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <yezqqgowgmbn2z42zvha7cfcprym5vnurb33brdmooab6csdks@a76a7v6rtywn>
References: <20260521090705.GA14254@lst.de>
 <gcw7zcg6p4s2egpufwizfig72g6ren7jfmuz5mqskkpb7xepww@e3v35j7bk7dc>
 <ag7uW7KQ5mVyCGEv@nidhogg.toxiclabs.cc>
 <20260522-unbehagen-baumethode-erlesen-811a4065eeac@brauner>
 <20260522120757.GA21041@lst.de>
 <ahVzkf8JoKP-kSC2@nidhogg.toxiclabs.cc>
 <20260528-offiziell-luftleer-misswirtschaft-3503bda2ad70@brauner>
 <fjdfwhwi4aogyiaoijwvw6w4npuu5mbt6ua6fkhwcp5ajlm543@ume2fkxg36cb>
 <aiE_YQc6SGSdWlcE@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260604-holen-rundum-ausfechten-2193b39da363@brauner>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604-holen-rundum-ausfechten-2193b39da363@brauner>

On 2026-06-04 14:00:07, Christian Brauner wrote:
> On Thu, Jun 04, 2026 at 11:04:32AM +0200, Andrey Albershteyn wrote:
> > On 2026-05-28 16:50:45, Andrey Albershteyn wrote:
> > > On 2026-05-28 14:20:08, Christian Brauner wrote:
> > > > On Tue, May 26, 2026 at 12:19:43PM +0200, Carlos Maiolino wrote:
> > > > > On Fri, May 22, 2026 at 02:07:57PM +0200, Christoph Hellwig wrote:
> > > > > > On Fri, May 22, 2026 at 12:03:20PM +0200, Christian Brauner wrote:
> > > > > > > > I was expecting this to come through xfs tree too if Eric and Christian
> > > > > > > > agree.
> > > > > > > 
> > > > > > > You may take it through the xfs tree if there are no conflicts with
> > > > > > > vfs-7.2.iomap. If there are I want to add the iomap changes into
> > > > > > > vfs-7.2.iomap that you can pull in.
> > > > > > 
> > > > > > Merging the iomap bits through the iomap branch might make sense, given
> > > > > > that iomap usually tends to see quite a bit of activity.
> > > > > > 
> > > > > 
> > > > > That sounds good to me. If you want to go ahead and pull in the iomap
> > > > > bits, do so, and give me a heads up when you do it so I'll pull your
> > > > > branch locally.
> > > > 
> > > > Great, can the series please be resent based on current vfs-7.2.iomap
> > > > then please? Because the iomap changes in this series don't apply
> > > > cleanly on vfs-7.2.iomap so we already have merge conflicts...
> > > > 
> > > 
> > > hmm do you mean this branch?
> > > https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs-7.2.iomap
> > > 
> > > patches 07..09 seems to apply cleanly. The only conflict I see is in
> > > the overlayfs patch 03. This is because [1] (is in -rc5) is missing
> > > in vfs-7.2.iomap.
> > > 
> > > [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/fs/overlayfs/util.c?h=v7.1-rc5&id=0c8c88b8eb82a2a41bec5f17c076d6312dc40316
> > 
> > Christian, ping
> > 
> > Would be nice to have iomap in vfs, so Carlos can pull and test the
> > rest
> 
> Applied but note IOMAP_F_FSVERITY
> changed from (1U << 10) to (1U << 11) since we have another flag
> addition this cycle.

Oh I haven't noticed that, thanks!

-- 
- Andrey

