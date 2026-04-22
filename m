Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210ED2D8DC2
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 06:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776838106; cv=none; b=Hf8054kWod0uE3XFlpb24FZJD0kJZdL5ttV67BOUdjeVXP95QMP1uiKpMchfb9P+3UTGdPzM6nByGGIl52yRhF3p6oBewNIoNDms7s67cXHc9GDAwzAp0Pqw11Xbe6D9bWQwSm19qZ2rGj5ieZ9dIwSDGDXXQN5ZgJ9SewHVJnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776838106; c=relaxed/simple;
	bh=lRZ4xR5dK9ATdx57kMxeGhvakIPsrNTXoKhunn2nGVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ipDNvDBR4YnpVBRZPZ2wC6B79l8Hie1+MNcS1aAUBgt5H/ogGT6aMxY0x/GFEnKROgljn6gV7GtgCaCjmhlW5TdCW5mkWwuMhiEOydMmVAKbWcHGymc0dfceYp2gWxjK3Lys8fG+XHF8eUVGRqwx4JIhT7qdMnjO/F0QfpFD9iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=DrTG6pq2; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="DrTG6pq2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xqcMoHzEsaN9+DvX5/2e2Bc5+jaYGyE5yuM14bgUxFM=; b=DrTG6pq2VB8TUSgDnjERtULqjP
	tKfK51H6Suabl8ILO0GNsaclU6hBc3wJfTw/ml7J+sMyz9lNcU+U/xuZq1b0wvQN0jSh9p2LfutBD
	uHsoEMt2OYrvxvhfDKFsQeS8bzJQ1jyZZtU1T1K7D7JcuGI0pgwK1/olbd+ePoA+6Sk5OkqOd5HEz
	iMyR6Dy6aTp7hrqd0mp6CjWLfgHu9efw5Jvv5nC3U2Ht2Gv16UbvqNMNcyPTvq2q9joVEh3l88sad
	+TwGevZ1a8zBpLQZFVI37tdV8rnbYlYiubgab1E22Lfe2erCan/pSbiigSfoFEQLbsTowFhESBT4p
	rRInLNDQ==;
Received: from [24.6.49.44] (port=44576 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wFQl6-000000058F5-1FQp by authid <merlins.org> with srv_auth_plain;
	Tue, 21 Apr 2026 23:08:24 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc_btrfs@merlins.org>)
	id 1wFQl4-009l76-2o;
	Tue, 21 Apr 2026 23:08:22 -0700
Date: Tue, 21 Apr 2026 23:08:22 -0700
From: Marc MERLIN <marc_btrfs@merlins.org>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Simple quota unsafe? RIP:
 0010:__btrfs_free_extent.isra.0+0xc41/0x1020 [btrfs] /
 do_free_extent_accounting:2999: errno=-2 No such entry
Message-ID: <aehl1o7AAeU17yoW@merlins.org>
References: <aeA2c8V4FgCctUPG@merlins.org>
 <20260416012535.GB1065998@zen.localdomain>
 <aeEaqCJAWaWbz1vO@merlins.org>
 <20260416213632.GA1654609@zen.localdomain>
 <aeFY4uSTSIz4Ccat@merlins.org>
 <20260417215127.GA2310330@zen.localdomain>
 <aeK2QgUCefpVY4KX@merlins.org>
 <20260417231603.GA2376753@zen.localdomain>
 <aeLNxjmUGGhnW5ss@merlins.org>
 <20260422022627.GA1034721@zen.localdomain>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422022627.GA1034721@zen.localdomain>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc_btrfs@merlins.org

On Tue, Apr 21, 2026 at 07:26:27PM -0700, Boris Burkov wrote:
> I believe I have reproduced the balance bug, and in my reproducer, the
> fact that the subvolume predated squota was critical.
> 
> reproducer sketch:
> - create subvol
> - write stuff
> - snapshot subvol
> - enable squota (usage = 0)
> - delete subvol (leave snapshot)
> - run a data balance that hits an extent in the snapshot (owned by subvol)
> - balance double counts extents in squotas (valid interpretation) but
>   critically, creates a new tree block with the old dead owner but a
>   fresh generation.
> - run_delayed_refs happens now, say from a commit running (important race),
>   writing that dangerous tree block to disk (in the reloc root)
> - we do the pointer swapping and drop the reloc root. the nodes of the
>   reloc tree are of this bogus form and cause your abort
> - I believe the snapshot also has some bogus leaves and would abort
>   later, too.
 
That does sound like my situation, yes.

> So the thing that is definitely dangerous, as far as I can tell, is
> running balance on a filesystem where squotas was enabled after any
> subvolume owning a shared extent (snapshot or reflink) was deleted.

so that's also good news where if I enable squota on a new FS at
creation time, that's supposed to be safe.
It would also explain why no one saw this bug since squota is only very
marginally useful when enabled way later on a filesytem which has seen a
lot of use.

> Now that I am at least clear on the more sophisticated bugs we have, I
> think that I am ready to put in some fixes and some defense in depth. I
> was feeling sheepish about just wallpapering over it without explaining
> your actual bug. So I think you should wait for that, to be safe with
> your big FS, even if it happens to not *need* the fixes.
 
I appreciate that, while I don't know the btrfs code, as a sysdadmin I
do not want to paper over anything without understanding the root cause
and applying a wrong or incomplete fix, so thank you.

> FYI
> I believe that when btrfs mounts a filesystem with qgroup trees present
> it will enable quotas, so you don't need to manually enable them if it
> was created with squotas.
 
It now looks like it, because I didn't find good documentation at the
time I tried to turn them on, I didn't know it could be done clearly at
mkfs.btrfs creation time.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
