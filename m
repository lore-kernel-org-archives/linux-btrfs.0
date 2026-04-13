Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389A03161BF
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 16:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.81.13.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099344; cv=none; b=b4Etn2I25atMRLgYlhUPOOUlpuo/GneWoyCLIYnbLlqZO1f12EqtXMp1hDA/vVqDqU8sFnfsjvyp2Wb1agBl+4pkNKG90a3gBCrQkqimoFW9AaY7X7BPVp+t1A4++LcvUXjP0o51ovX46BXYGV3HpILJ8EbiD2qN1Q2K8SA1JZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099344; c=relaxed/simple;
	bh=avKrMTBesjazp9kyAkuQJgfKt3jZUZFbGiRnEVVrfcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KaLTecy7wJQVq2zN/EslAo7B1aqT+T+T6qxviF8KhNOStAjw37nkhiQ6FCl4dZziUGqMzElqBbbL/j/M4/fuGp72jXJJ21JwF9bCe0uv+wL24NXz5+OOn6mqB16Cy4Pu7FsSGqjJm4/iS1GQe0J99jqf2JQzLXEq6AA/GajFpuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org; spf=pass smtp.mailfrom=merlins.org; dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b=dzf4JhvF; arc=none smtp.client-ip=209.81.13.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=merlins.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=merlins.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=merlins.org header.i=@merlins.org header.b="dzf4JhvF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=merlins.org
	; s=20251023; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LPcmPy8n+DrxtCdkBw/zrkPa18SGihuDz0B7VTStI9A=; b=dzf4JhvF1dqrp+LLldUJJCHPo8
	pdy1beIhD9iN9buAnzD4I6Dd4YjdTBNHTPq2zP1+YN/j/qynYiFF57ZwqHQcIC1e1vAImJgD8twcb
	kFWj21Qkgzjl1M8S21oxEGQOWWn13uuUDJrUOrpOYjWK98EP0mpe/3/3i4zu4TZ7W1SG4MBGuPJYI
	wPUpLzsCfF4i6fF54Dgi2lVYq/oEDlegYeSrbqSDktQdmsBu+8FP2bmgZCAKRwAsUl5gYSMA5Rc59
	fRHjTqKg5CMvcXkBwB7ETuh3z68LOeK5QmeCdmJLgqUhnIaV8cV+ez+sGggZ8vBLL0n6SAh8Gnd2D
	D5TVf3Zw==;
Received: from [24.6.49.44] (port=49276 helo=sauron.svh.merlins.org)
	by mail1.merlins.org with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__AES_256_GCM:256) (Exim 4.98.2 #2)
	id 1wCKZa-0000000Cy2h-1vRs by authid <merlins.org> with srv_auth_plain;
	Mon, 13 Apr 2026 09:55:42 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.96)
	(envelope-from <marc@merlins.org>)
	id 1wCKZZ-004fUw-02;
	Mon, 13 Apr 2026 09:55:41 -0700
Date: Mon, 13 Apr 2026 09:55:41 -0700
From: Marc MERLIN <marc@merlins.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: What's the status of BTRFS RST instead of linux md raid5?
Message-ID: <ad0gDVe4bwS-zBle@merlins.org>
References: <adbgT-3VINfJNctk@merlins.org>
 <955a6526-96a9-4282-895e-d881d0411dea@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <955a6526-96a9-4282-895e-d881d0411dea@wdc.com>
X-Sysadmin: BOFH
X-URL: http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.6.49.44
X-SA-Exim-Mail-From: marc@merlins.org

On Mon, Apr 13, 2026 at 01:37:30PM +0200, Johannes Thumshirn wrote:
> 
> RST is still considered experimental and the development on the RAID5/6
> support is unfortunately delayed due to different more urgent fires that
> have to be extinguished.
> 
> Note while RST can handle non zoned devices, it's primary focus always was
> always to enable RAID on zoned block devices. Which it does for RAID0, RAID1
> and RAID10.
> 
> As for RAID5 I have a prototype doing writes and reads for the trivial cases
> (i.e. full stripe write/read).
> 
> 
> My apologies to everyone waiting for this. I haven't abandoned the project,
> I just need more time to get it done.
> 
> If you're looking for documentation please have a look here: https://github.com/kdave/btrfs-progs/blob/devel/Documentation/dev/design-raid-stripe-tree.txt

Thank you so much for the status update, *much* appreciated.
As for when, this is all unpaid work I assume, so it gets done when it
gets done, no worries.

For what it's worth, I've ben doing mdadm raid5 with btrfs since 2014,
and unfortuantely it's failed in too many ways, almost each time causing
a btrfs filesystem that was impossible to recover (usually ro mount was
ok, but impossible to get back in read/write state, which is very
inconvenient for a 20TB+ filesystem dueto how long it takes to restore
backups)

As luck would have it, this just happened to me again
https://yhbt.net/lore/linux-btrfs/advYoKqUCUmD4oO6@merlins.org/

I know I don't know the deep insides of the btrfs code, but it's
unfortunately failed enough times on top of mdadm raid5 that I can't
wait to switch to RST when it's ready.  It's been 12 years already, so I
can wait a bit longer still :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
