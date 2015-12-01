Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37006 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbbLAUM0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Dec 2015 15:12:26 -0500
Received: by wmww144 with SMTP id w144so28934230wmw.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Dec 2015 12:12:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$29351$45c9e04c$34064b25$8daa651c@cox.net>
References: <CA+WRLO_k=jn1=dNPY8Cv-dFkM=Q2ge0tfX3HXVW9v9eGPhnS=Q@mail.gmail.com>
	<pan$29351$45c9e04c$34064b25$8daa651c@cox.net>
Date: Wed, 2 Dec 2015 07:12:25 +1100
Message-ID: <CA+WRLO_hx3u0wPy_GfguKmmXY4crxrRFx9TvuoLYh-Su0ju8ww@mail.gmail.com>
Subject: Re: utils version and convert crash
From: Gareth Pye <gareth@cerberos.id.au>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 2, 2015 at 2:14 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> So if you're running into the same problem gentoo's live-git build did,
> it's likely because you're building the devel branch cloned from
> kernel.org, which is no longer updated.


Woah, kernel.org is making a log that looks like it's up to date but
isn't that's awkward :(

Building now from the github you mentioned.

Also running a scrub, but I'm starting to suspect something else is
responsible. It ran fine overnight but crashed in less than a minute
after I logged back in on ssh this morning . . .

-- 
Gareth Pye - blog.cerberos.id.au
Level 2 MTG Judge, Melbourne, Australia
"Dear God, I would like to file a bug report"
