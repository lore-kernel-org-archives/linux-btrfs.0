Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54009 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab2GRUEa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 16:04:30 -0400
Received: by pbbrp8 with SMTP id rp8so3087952pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2012 13:04:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120718181316.GD16899@merlins.org>
References: <20120202124241.GW16796@shiny>
	<20120202152722.GI12429@merlins.org>
	<20120201175624.GE16796@shiny>
	<20120218160702.GB32373@merlins.org>
	<20120215165540.GC4763@merlins.org>
	<20120213001400.GD31989@merlins.org>
	<20120212223242.GA31989@merlins.org>
	<20120202032345.GB31903@merlins.org>
	<20120130003754.GD4380@merlins.org>
	<20120718181316.GD16899@merlins.org>
Date: Thu, 19 Jul 2012 03:04:29 +0700
Message-ID: <CAG1y0seiFAWfcc0onUuK8K6+2sXkB-AAhe_okRDWaB9um97abA@mail.gmail.com>
Subject: Re: brtfs on top of dmcrypt with SSD -> Trim or no Trim
From: "Fajar A. Nugraha" <list@fajar.net>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2012 at 1:13 AM, Marc MERLIN <marc@merlins.org> wrote:
> TL;DR:
> I'm going to change the FAQ to say people should use TRIM with dmcrypt
> because not doing so definitely causes some lesser SSDs to suck, or
> possibly even fail and lose our data.
>
>
> Longer version:
> Ok, so several months later I can report back with useful info.
>
> Not using TRIM on my Crucial RealSSD C300 256GB is most likely what caused
> its garbage collection algorithm to fail (killing the drive and all its
> data), and it was also causing BRTFS to hang badly when I was getting
> within 10GB of the drive getting full.
>
> I reported some problems I had with btrfs being very slow and hanging when I
> only had 10GB free, and I'm now convinced that it was the SSD that was at
> fault.
>
> On the Crucial RealSSD C300 256GB, and from talking to their tech support
> and other folks who happened to have gotten that 'drive' at work and also
> got weird unexplained failures, I'm convinced that even its latest 007
> firmware (the firmware it shipped with would just hang the system for a few
> seconds every so often so I did upgrade to 007 early on), the drive does
> very poorly without TRIM when it's getting close to full.


If you're going to edit the wiki, I'd suggest you say "SOME SSDs might
need to use TRIM with dmcrypt". That's because some SSD controllers
(e.g. sandforce) performs just fine without TRIM, and in my case TRIM
made performance worse.

-- 
Fajar
