Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7222E1DBB3A
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Apr 2026 16:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776358278; cv=none; b=Lzx/VSCJpmDV49ViMM7fd5Sj7KZK5SpoOOi+PphxuGa2TTRpBaTmALQAGfg0E9ZnGDS1WUpoIDKTbYwRINut3S9pNNS1nibSD3AKD3MUkPeB7cvotlucP5l4bIf3Yg7R8bNBM6hAznp1TRhodg10q4FDbLNEUoP4Eogjo3CGxlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776358278; c=relaxed/simple;
	bh=evivXYlIZBFR2Wo50OyRmktzeSvz7IJsKKUeTsoFCps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LLkUQYoRCDG+uXR0yH3m+5d5fqyBhAZL/I6JBZOghny3V3gT+0UquSm65Ro5PGW4ndb/e6uvV2/+vxDdVouUbHPvBZq32J/y2x5feY7lq3W9QK1lgXSeRIBG9x2QR41UV+R85xgf9o6x41df0c3Y9dWgdLRwcaBtkiXBeCLKeZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=I7i1wHCp; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="I7i1wHCp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HYcULDv7Di7RlsFXQOSpgNFoohjnerrD0tLXCQVPUkM=; b=I7i1wHCpW2xc4wrBvql661a9DI
	jpZGaRsuFx4v99XKYbrfj4BtNykYYaWLv0DMgYN6/ByDRez3eQOY7Kb2rC2MSVftlaGXcWQ6Dxyb5
	57jVlf74JrLpCV1soZVoFjk12Wa75JAP7IcI5Se0EOMs2N+YVjB+7oxFYm+QaA9PYfq9Fm/KijT4T
	UuBX0hk2WDhTW5xXrHz1R8OWwAmxdc5C5dB4WJQQi6f0pwmm/Nu9F4xKzfCtqII2zU89SxHlrD2zg
	LY6QUWhfvohhzcdtSfEq0m1HS0f+O49KLYe4CWGW4NZ4rLoO4WJANy24v5A3kfqGc3n3yd36TZl8n
	fR9XnEjg==;
Received: from [24.6.49.44] (port=44696 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wDPvw-0000000CfES-3FHl by authid <merlins.org> with srv_auth_plain;
	Thu, 16 Apr 2026 09:51:16 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wDPvv-000xx4-0o;
	Thu, 16 Apr 2026 09:51:15 -0700
Date: Thu, 16 Apr 2026 09:51:15 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Simple quota unsafe (FIXED: btrfstune --remove-simple-quota
 worked)
Message-ID: <aeETg6aCrBSHkxM-@merlins.org>
References: <ad8gcwTFOLUhBHGA@merlins.org>
 <20260415170510.GA780391@zen.localdomain>
 <ad_SEOvBQtzsxWkY@merlins.org>
 <20260415184427.GA842130@zen.localdomain>
 <ad_zkh47QZZnns7x@merlins.org>
 <20260415223629.GA956756@zen.localdomain>
 <aeAXawJ9F9K28shr@merlins.org>
 <20260416004552.GA1045221@zen.localdomain>
 <aeA2c8V4FgCctUPG@merlins.org>
 <20260416012535.GB1065998@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416012535.GB1065998@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

Ok, we have a winner!

> > > I also think "btrfstune --remove-simple-quota" may fix your fs. It will
> > > have to do work in O(extents), and might fail in its fake mount, though.
> >  
> > moremagic:/tmp# btrfstune --remove-simple-quota /dev/mapper/crypt_bcache0
> > bad eb member end: ptr 0x4000 start 15495725432832 member offset 16384 size 1
> > bad eb member end: ptr 0x4000 start 16568941559808 member offset 16384 size 1

Took a while to remove the quota, but once it did:

moremagic:/tmp# mount -o rw,enospc_debug,skip_balance /dev/mapper/crypt_bcache0 /mnt/btrfs_bigbackup
moremagic:/tmp# cd /mnt/btrfs_bigbackup
moremagic:/mnt/btrfs_bigbackup# btrfs balance cancel `pwd`
BTRFS info (device dm-0): setting compat-ro feature flag for FREE_SPACE_TREE (0x1)
BTRFS info (device dm-0): setting compat-ro feature flag for FREE_SPACE_TREE_VALID (0x2)
BTRFS info (device dm-0): balance: resume skipped
BTRFS info (device dm-0): checking UUID tree
BTRFS info (device dm-0): enabling ssd optimizations
BTRFS info (device dm-0): enabling free space tree
BTRFS info (device dm-0): balance: canceled

And now I'm good. I can re-re-convert to block group trees (took hours
overnight to go back):
moremagic:~# btrfstune --convert-to-block-group-tree  /dev/mapper/crypt_bcache0
Converted the filesystem to block group tree feature

moremagic:~# mount /dev/mapper/crypt_bcache0 /mnt/btrfs_bigbackup
BTRFS: device label DS6 devid 1 transid 298273 /dev/mapper/crypt_bcache0 (251:0) scanned by mount (1030419)
BTRFS info (device dm-0): first mount of filesystem a97dec85-a0d5-42ab-a0ef-e9b7479fbe43
BTRFS info (device dm-0): using crc32c (crc32c-generic) checksum algorithm
BTRFS info (device dm-0): forcing free space tree for sector size 4096 with page size 16384
BTRFS warning (device dm-0): read-write for sector size 4096 with page size 16384 is experimental
BTRFS info (device dm-0): bdev /dev/mapper/crypt_bcache0 errs: wr 0, rd 0, flush 0, corrupt 5074, gen 0
BTRFS info (device dm-0): checking UUID tree
BTRFS info (device dm-0): enabling ssd optimizations
BTRFS info (device dm-0): enabling free space tree

I'm back in business, thank you.

Will definitely keep squota off for this one. Thanks again about the
--remove-simple-quota suggestion, of all the things I tried, this is one
I hadn't.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
