Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49549 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752277AbaFLAkC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 20:40:02 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Slow startup of systemd-journal on BTRFS
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5398CA16.3030609@libero.it>
Date: Wed, 11 Jun 2014 18:40:00 -0600
Cc: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <32BBFA99-1503-4068-8C74-D6C46187A862@colorremedies.com>
References: <5398CA16.3030609@libero.it>
To: kreijack@inwind.it, Goffredo Baroncelli <kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 11, 2014, at 3:28 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> 
> If someone is able to suggest me how FRAGMENT the log file, I can try to collect more scientific data.

So long as you're not using compression, filefrag will show you fragments of systemd-journald journals. I can vouch for the behavior you experience without xattr +C or autodefrag, but further it also causes much slowness when reading journal contents. LIke if I want to search all boots for a particular error message to see how far back it started, this takes quite a bit longer than on other file systems. So far I'm not experiencing this problem with autodefrag or any other negative side effects, but my understanding is this code is still in flux.

Since the journals have their own checksumming I'm not overly concerned about setting xattr +C.

Chris Murphy