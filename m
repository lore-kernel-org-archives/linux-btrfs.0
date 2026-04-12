Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379463563CD
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 05:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776229963; cv=none; b=clz3nSl9g3BV6tt9KIBdOXyz7PG5w9XYHRlQJa4iR7yTiBwFkyzbcOt03WLIO6wkoK2xQpBuB4Ab6EL8RDcBn+EcxSfEBVgsHeyOZv8NGdFLIqPLJJ6niJ1BDxull7fdtfz8XEiE/lLu5TjyDXIxpZbvZkZvgTt6u+fYncNoLMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776229963; c=relaxed/simple;
	bh=U4gjGm1rNkFVWBo9kVXj/HWPTYT7zbXcbh1lPwdInEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fMOcMqQ6m6Y+qcNNdBSamQmVDzBPInO5HtZSvbTm+ue1KZ7oHcep/PU2YWukaJExtINk5HjkbusLlkdiWFx789/Lx+/1+o7/mSWn7ecpWmOwEHl16PYJZQIf0vEO4l35KC/rcnbdVT64RksHAUfFHtxw1EX1fm/rqN7Aclu6J/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=W/Rr9uB3; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="W/Rr9uB3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Resent-To:Resent-Message-ID:Resent-Date:Resent-From:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Sender:Resent-Cc:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+L/xVEDFxSuhQ6ptGrvLZkj9A7JiKm9N8DWyQF9MU0c=; b=W/Rr9uB3a1V8fY0z2p04isXDTB
	j3FcFWKNpmYyen3ff4RPhf9GfxOUczhsMobAFndaRAzMcFv7i59OYVEjj1bIvYhCvY9FAtfSESkdt
	fXnnBzXjUb7OElNcMKWlzXH0JG4JF13uNCYkxPFOgvZm1xME3y+rS1NCHH5JUuR4yxVUSIa0DmkeF
	/T3Uy2Bz+xJv3SL8Y1Ue1E+17fvMjTLopIljns62OyshpvYUoH9Cel5Qc/r/JIQq2UYE4+B3rggCh
	mbLxAnactV/yN+pnDZ2U/dmdtrFMPH9GK2MqerHEom3wLYnzYe2ByN5bc9g8wnEUHWeBCqAYoKc6n
	8Dn9aEXg==;
Received: from [24.6.49.44] (port=35830 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wCsYL-00000004AUB-3Yi1 by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>;
	Tue, 14 Apr 2026 22:12:41 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <merlin@merlins.org>)
	id 1wCsYK-006sZi-1O
	for linux-btrfs@vger.kernel.org;
	Tue, 14 Apr 2026 22:12:40 -0700
Resent-From: Marc MERLIN <marc@merlins.org>
Resent-Date: Tue, 14 Apr 2026 22:12:40 -0700
Resent-Message-ID: <ad8eSFGG1gbiT-49@merlins.org>
Resent-To: linux-btrfs@vger.kernel.org
Date: Sat, 11 Apr 2026 19:28:21 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>, Boris Burkov <boris@bur.io>,
	Josef Bacik <josef@toxicpanda.com>, QuWenruo <wqu@suse.com>,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Filipe Manana <fdmanana@kernel.org>
Cc: Chris Murphy <lists@colorremedies.com>,
	Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
	Roman Mamedov <rm@romanrm.net>, To: Su Yue <Damenly_Su@gmx.com>,
	Su Yue <suy.fnst@cn.fujitsu.com>;
Subject: Re: BTRFS discard crash: failed to run delayed ref for logical
 15506102321152 num_bytes 16384 type 182 action 2 ref_mod 1: -2 6.11.2)
Message-ID: <adsDRShNS8OkIcbr@merlins.org>
References: <adnBhWfJQ1n3hZC8@merlins.org>
 <adr8DUbqkdFyvZsf@merlins.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adr8DUbqkdFyvZsf@merlins.org>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc@merlins.org
Message-ID: <20260412022821.TXLyGzvH3UoTqNC4LQzJq5nJ0lQ39WsMI0Y4a7bdf0g@z>

On Sat, Apr 11, 2026 at 06:57:33PM -0700, Marc MERLIN wrote:
> But this is strange lowmem is giving a totally different result, it may
> just be entirely trashing my FS as I write this, but if it doesn't
> succeed, I need to wipe it and start over anyway
> moremagic:~# btrfs check --mode lowmem /dev/mapper/crypt_bcache0
> Opening filesystem to check...
> Checking filesystem on /dev/mapper/crypt_bcache0
> UUID: a97dec85-a0d5-42ab-a0ef-e9b7479fbe43
> [1/8] checking log skipped (none written)
> [2/8] checking root items
> [3/8] checking extents
> ERROR: extent[16842752 168 4096] has unknown ref type: 172
> ERROR: extent[16855040 168 4096] has unknown ref type: 172
> ERROR: extent[1121296384 168 8192] has unknown ref type: 172
> 
> Gemnini said that's the simple quotas not supported in lowmem
> 
> moremagic:~# btrfstune --remove-simple-quota /dev/mapper/crypt_bcache0
> bad eb member end: ptr 0x4000 start 15495212859392 member offset 16384 size 1
> bad eb member end: ptr 0x4000 start 16568940527616 member offset 16384 size 1
> bad eb member end: ptr 0x4000 start 16133001379840 member offset 16384 size 1

I forgot to mention:
moremagic:~# btrfs --version
btrfs-progs v6.17.1
-EXPERIMENTAL -INJECT -STATIC +LZO +ZSTD +UDEV +FSVERITY +ZONED CRYPTO=builtin

And gemini could be completely wrong, but since I have no other source of help
while typing those commands, and I need that filesystem back up, or
ron the sameestoring from backup, this is what it says now

The error message bad eb member end: ptr 0x4000 start ... member offset
16384 size 1 is a smoking gun for an off-by-one bug in the tool's
bounds-checker:
0x4000 / 16384: This is exactly the default nodesize (16KB) for Btrfs.

Offset 16384, Size 1: The code is trying to read/write a 1-byte member
that starts at the very last byte of the buffer and ends at 16385.

The Conflict: Because the extent buffer is only 16384 bytes (0 to
16383), the strict validation in the btrfs-progs library (likely
check_eb_range in kernel-lib/extent_io.c) throws a warning and blocks
the operation.

Why this happened with Simple Quotas
The BTRFS_EXTENT_OWNER_REF_KEY (Type 172) that caused your lowmem check
to fail is relatively new (introduced in Kernel 6.7). The code for
--remove-simple-quota in btrfstune (v6.13+) has to iterate the extent
tree and delete these items.

(Speculation) There appears to be a bug in how the iterator handles the
"next item" pointer when a BTRFS_EXTENT_OWNER_REF_KEY is the last item
in a leaf, or when the leaf is being rebalanced after a deletion.

Suggestions/ideas welcome, including my previous question of is there
even really a way to do software raid5 on linux with btrfs without
getting those seemingly unfixable and unrepairable btrfs corruption
issues? (I say this because of that having been my experience over 11 years
of trying to do this and getting too many of these corruption problems,
almost all of which were unrepairable and required a very slow restore
process for terabytes of data)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
