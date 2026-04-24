Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E792E1746
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 02:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776999328; cv=none; b=QMbbxcQexP9vMUTB5i5WpBByH1FZThcPbt0IKG6dX2D3g/X68SmOEAvAgsswqUWvj4UdCSS+ipBSOiSfiESv3ScB0xcrYNGBypyOtAAHpzhqr7lIykqf/L5kq429BIJBwyyGgh5XlwNczcRL8cIsMltyqk0SZePZgpvq1VwYoEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776999328; c=relaxed/simple;
	bh=E8F7eSum21+JphJVvADSd/oRw1h7RYMMqNESrnaMCnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O5vdD9rsDlc3MTCrPApxlzhHTreh0JMT9+acZpPK0AnWMFkjpoKrGbe47qNyL2VtV4WalNKuFcQVafjD0kfuswEzf/4nlFbbyYBJCw2RYHt9C38+apRu6pHAKuIcUMAErSk/m/e7FK56PElkK66dKFQd88CQLPszxlAsbHuPKPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=KYSNOIDM; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="KYSNOIDM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=i9Lc5bjCWBpmSdW9nN9RgiTHN1DPzph5FIYvuO4gg74=; b=KYSNOIDMmUiPOcz8fa5GPK4Grg
	vNbpNcxggcKMhYBE+O7060+0BfGYtUxPTLVpOQg2RMX+f6pJDKZOAUVtyJg0z8D2t9dSv+l6a3PSf
	2d5Z9QBu1px76oZGHGisjk8viHBAzjQx4tCid/ly2qrZaTX/HToubeebu/k+IzpvB5Xws7Hyajxyb
	I1V31eLUnxLFwjNR07DrhDmgUatRpajNCN+llAOLMXINVUHWTGWQZXjtHnyNmngg1e0gqhs7mq5Sa
	Je87+Eeb8Nn8ztd6MpDsIHw+xPfxU0wiOrsmxr9XQIGPymnHYtjKvtDBGLAtuVXSZrqeG0+lM17Hm
	847I9BFg==;
Received: from [24.6.49.44] (port=46972 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wG6hQ-0000000ECdA-2fja by authid <merlins.org> with srv_auth_plain;
	Thu, 23 Apr 2026 19:55:24 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wG6hP-00Bwuj-0e;
	Thu, 23 Apr 2026 19:55:23 -0700
Date: Thu, 23 Apr 2026 19:55:23 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Deleted snapshots stay in squota, mayube because of bees?
Message-ID: <aerbm1ARY2hERpOv@merlins.org>
References: <aeK2QgUCefpVY4KX@merlins.org>
 <20260417231603.GA2376753@zen.localdomain>
 <aeLNxjmUGGhnW5ss@merlins.org>
 <20260422022627.GA1034721@zen.localdomain>
 <aekA8mS4hppTjbA-@merlins.org>
 <20260422192344.GA1392535@zen.localdomain>
 <aekh8CX_LmbtMbQ_@merlins.org>
 <20260422193853.GA1478152@zen.localdomain>
 <aekrVJnCaGkYWeBp@merlins.org>
 <20260423192831.GA2096001@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423192831.GA2096001@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

On Thu, Apr 23, 2026 at 12:28:31PM -0700, Boris Burkov wrote:
> My proposal for repair was to clean up clearly broken states like
> scrubbing off the owner_refs for missing subvols (basically
> conditionally do what the btrfstune did when you notice leaked
> extents)

Ack.

> > Is that possible at all? (separately from being worth your time, which
> > I'd understand). The biggest plus I see is allowing many people to
> > switch to squotas on existing FS without having to wipe and start over
> > just to benefit from squota.
> 
> I think the tricky part is deciding who should own data blocks. It is,
> in my opinion, impossible to arrive at a given FS and properly account
> each data block to its originating subvol, with the same result as "as

In the case of blocks that are owned by multiple subvols, no need to be
fancy, it's fine to just assign them to the subvol with the lower number
and be done with it.
The main idea being to clean up unowned blocks and the state I just
reported (see end of this mail), which I can reproduce pretty much at
will (start btrfs receive, let it run, have bees run at the same time,
kill btrfs receive, delete subvoll, and up with unowned blocks forever).

> You could pick arbitrarily, or you could try to make educated guesses
> based on the owner of the enclosing metadata tree blocks and their
> generations or something, but I think fundamentally it would be a lossy
> process.
 
This doesn't need to be perfect, nor can you guess who to assign if
there are multiple others, just pick the lowest id one, and that's fine.

> Perhaps we could add an ioctl that was something like "assign extent E
> (or maybe file F's extents) to subvol S" and then userspace could assign
> how they want. Or maybe even something subvol oriented like "squota
> account subvol S" which would mean "S takes ownership of all unowned
> extents reachable by S". And you could iterate your subvols in the order
> you wanted. I like those ideas more than the kernel making fundamentally
> arbitrary picks.

That is even btter if it's not too much work and you don't mind that.

> Ultimately, I would still be sort of worried about the resultant weird
> state where you could have a shared metadata block owned by S1 and
> shared with S2 (so S2 is a snapshot of S1 and the data must be from S1)
> but then the data is accounted to S2. Nothing would freak out about this
> now, I don't think, but it's sort of sloppy.

So let me give my outside view and opinion :)
s in squotas stands both for simple and sloppy :)
When I took them, I accepted that in the name of performance. 
"good enough" that I can live with performance wise, 1000x beats
"perfect but I can't deal with the performance hit"

I already accepted that accounting won't be perfect and it's not true
reality with shared blocks, never mind snapshots of snapshots, but even
more so with bees. I'm ok with that.
I just want to know that this 10 million file subvol is around 7.2TB
without spending hours and hours running a du -sh on it.
And let's be honest, even with du -sh, shared blocks can be an issue, so
really it's not really worse.

But I do want to fix this is very very vexing to see forever unless I
wipe the filesystem and start over:

Qgroupid    Referenced    Exclusive   Path 
--------    ----------    ---------   ---- 
0/5            4.78GiB      4.78GiB   <toplevel>
0/256         16.00KiB     16.00KiB   backup
0/258         16.00KiB     16.00KiB   backup-btrfssend
0/260          1.06GiB      1.06GiB   .beeshome
0/261         63.74GiB     63.74GiB   backup/win_kodi_ro.20260328_21:48:59
0/262        229.51GiB    229.51GiB   backup/ubuntu_kodi_ro.20260328_10:19:47
0/263        297.04MiB    297.04MiB   <squota space holder>   <-- be gone
0/264        187.38GiB    187.38GiB   backup/0Notmachines_kodi_ro.20260325_20:08:49
0/266         10.37GiB     10.37GiB   backup/1Appliances_kodi_ro.20260325_23:22:32
0/268        294.27GiB    294.27GiB   backup/debian32_kodi_ro.20260325_23:43:06
0/269        287.84MiB    287.84MiB   <squota space holder>a <-- be gone too ;)

I think it's pretty obvious where to assign them, it's the other
subvolume that didn't get deleted, and if there are 4 that these blocks
are shared against, any of the 4 will do, I truly don't care :)

hope that makes sense.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
