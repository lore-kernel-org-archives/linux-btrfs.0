Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:52577 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755634Ab3L3RsR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 12:48:17 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131230171039.GC26054@merlins.org>
Date: Mon, 30 Dec 2013 10:48:10 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        hugo@carfax.org.uk
Message-Id: <95A29B65-87F9-4B73-9715-2BBC10833A64@colorremedies.com>
References: <20131228171943.GE19863@merlins.org> <20131228173730.GA7234@carfax.org.uk> <20131228180758.GF19863@merlins.org> <20131228182023.GG19863@merlins.org> <1388419531.11341.6.camel@ret.masoncoding.com> <20131230161729.GQ19863@merlins.org> <1388420830.11341.12.camel@ret.masoncoding.com> <20131230171039.GC26054@merlins.org>
To: Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 30, 2013, at 10:10 AM, Marc MERLIN <marc@merlins.org> wrote:
> 
> If one day, it could at least work on a subvolume level (only sync a
> subvolume), then it would be more useful to me. Maybe later…

Maybe I'm missing something, but btrfs send/receive only work on a subvolume level.


Chris Murphy