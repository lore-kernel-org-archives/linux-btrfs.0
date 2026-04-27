Received: from mxex2.tik.uni-stuttgart.de (mxex2.tik.uni-stuttgart.de [129.69.192.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87867F9C0
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 00:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.69.192.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777248498; cv=none; b=aoiMfHP6i1Hz/PGC98MGd4TRrvz6+svEJdOFgiT1kUeNwUpfLdueaAN+MDlUxETniTsUM626a2LeClvtcyaDhYLdIq4H0vtS1qhpFqYpcnG5LAU7hoHpQw4c8aCbIAbvETmrSnZBweG1/TuLZuxfh2G4QdxGjwYyf+tHdwMFXIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777248498; c=relaxed/simple;
	bh=hOhR4LXpcz1XwoBq55FRDx6R76IMZ1slreQ+4qkg/vA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EdtP5iC7ka5sDUsrgOFYRA0vqNBX1opgsubbJamJqZ/Bb48ngUFaE7pXkx/2JH2oqIPD/UXS2Ig0Z+BUVvciLxEo7HfHX2zm8XQ3aLtqGrXUI/PIjKkKPjex2f1n6kklmjGFz1+YZQbalN4OT+KGCm3qoXK1K1fqLvYcsLT0qCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de; spf=pass smtp.mailfrom=rus.uni-stuttgart.de; dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b=hcD3GFKf; arc=none smtp.client-ip=129.69.192.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rus.uni-stuttgart.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=uni-stuttgart.de header.i=@rus.uni-stuttgart.de header.b="hcD3GFKf"
Received: from localhost (localhost [127.0.0.1])
	by mxex2.tik.uni-stuttgart.de (Postfix) with ESMTP id 3491860C07
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 02:08:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=uni-stuttgart.de;
	 h=user-agent:in-reply-to:content-transfer-encoding
	:content-disposition:content-type:content-type:mime-version
	:references:message-id:subject:subject:from:from:date:date; s=
	dkim; i=@rus.uni-stuttgart.de; t=1777248484; x=1778987285; bh=hO
	hR4LXpcz1XwoBq55FRDx6R76IMZ1slreQ+4qkg/vA=; b=hcD3GFKfpkEowBpuh4
	mlU2ZZfxexfoGwEKJFrJd+hRRTVCKCn8nfs6dscJPMb0NCLmg9KfiQwyPFgE7GfH
	0RpdS7Eibgjcwpth7nGEzNF86Nv3G6sUHKOxuUtgtyR1SmqTyCHozs4K4LpcMJYC
	0cR4agSotWyG4SJrrW+eAumGVQH+dt8sHgl1JxaPmbWPQcYCfBQcF8zynO4MD16i
	05tN+IbtZ7oiNYQfoV1q235Y10i8AgGQRqYOgRKce9UZiNdYV/YGq6lcdimCBlQd
	HJnaFKNB9FDDTcxV8qtJFTJu4S7guu6FYyDqDJ3Ij76HBvuN5Sfeflf0wlIcOwM8
	E7rA==
X-Virus-Scanned: USTUTT mailrelay AV services at mxex2.tik.uni-stuttgart.de
Received: from mxex2.tik.uni-stuttgart.de ([127.0.0.1])
 by localhost (mxex2.tik.uni-stuttgart.de [127.0.0.1]) (amavis, port 10031)
 with ESMTP id hc_MtOSyxBrM for <linux-btrfs@vger.kernel.org>;
 Mon, 27 Apr 2026 02:08:04 +0200 (CEST)
Received: from authenticated client
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxex2.tik.uni-stuttgart.de (Postfix) with ESMTPSA
Date: Mon, 27 Apr 2026 02:08:03 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: corruption after block-group-tree conversion, how to recover?
 (data is readable)
Message-ID: <20260427000803.GA879749@tik.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs@vger.kernel.org
References: <CALpuBKwmZRYX0Mag-gLSoL9NgBBR_D+iOeKX7sdhHtyAposGRg@mail.gmail.com>
 <07db83f8-5769-4aaf-9f54-2711ddad9eea@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <07db83f8-5769-4aaf-9f54-2711ddad9eea@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)

On Mon 2026-04-27 (07:48), Qu Wenruo wrote:

> 在 2026/4/27 06:53, Thomas Debesse 写�":
> 
> > Hi, I just did a `btrfstune --convert-to-block-group-tree` conversion

Why should one execute this command?
For what...?


> > The system is running Ubuntu 24.04.4 with Linux 6.8.0-110-generic and
> > btrfs-progs 6.6.3-1.1build2.
> 
> Unfortunately the btrfs-progs is too old, and possibility the root cause.
> 
> There are some fixes in progs v6.15, thus it's strongly recommended to
> use progs newer than v6.15.

I also run Ubuntu 24.04.4 on many hosts and btrfs-progs 6.6.3-1.1build2 is
the newest Ubuntu package for it.

Is it recommendable to put btrfs v6.19.1 from
https://github.com/kdave/btrfs-progs in a PATH element in front?

I have now:

root@fex:~# type -a btrfs
btrfs is /opt/btrfs-tools/bin/btrfs
btrfs is /usr/bin/btrfs

root@fex:~# /opt/btrfs-tools/bin/btrfs version
btrfs-progs v6.19.1
-EXPERIMENTAL -INJECT +STATIC +LZO +ZSTD +UDEV +FSVERITY +ZONED CRYPTO=builtin

root@fex:~# /usr/bin/btrfs version
btrfs-progs v6.6.3

root@fex:~# uname -a
Linux fex 6.8.0-110-generic #110-Ubuntu SMP PREEMPT_DYNAMIC Thu Mar 19 15:09:20 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux


And a addon question:

  Static binaries

  The btrfs.box is an all-in-one tool in the busybox style, the
  functionality is determined by the binary names (either symlink,
  hardlink or a file copy).

I found no list which names are useful. By try-and-error I have:

root@fex:/opt/btrfs-tools/bin# ls -li btrfs btrfstune mkfs.btrfs
3214654 -rwxr-xr-x 4 framstag users 3653384 Mar 18 18:34 btrfs
3214654 -rwxr-xr-x 4 framstag users 3653384 Mar 18 18:34 btrfstune
3214654 -rwxr-xr-x 4 framstag users 3653384 Mar 18 18:34 mkfs.btrfs


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    https://www.tik.uni-stuttgart.de/
REF:<07db83f8-5769-4aaf-9f54-2711ddad9eea@suse.com>
