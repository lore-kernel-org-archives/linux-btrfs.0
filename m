Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51421 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2HUAUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Aug 2012 20:20:07 -0400
Received: by weyx8 with SMTP id x8so4235404wey.19
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Aug 2012 17:20:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALJXSJphSSGaXjBhtrzNKk3-F_xw-PMzWLT3AW6CLDGGoAN_qA@mail.gmail.com>
References: <20120401152749.61790@gmx.net>
	<CALJXSJpjOX3t6Xa=gFF2p13eSb+SJfRc_pc0d5ScShnK-5BwkQ@mail.gmail.com>
	<2272893.XFoXOC5Zif@bursa22>
	<op.wdjl3kx0r07q8e@tron.scheibner.rb>
	<CAPkEcwgSZ8umbFeuZ-fQAFAprBubL58eFSf4TQ=Z13ks8i9DOQ@mail.gmail.com>
	<CALJXSJphSSGaXjBhtrzNKk3-F_xw-PMzWLT3AW6CLDGGoAN_qA@mail.gmail.com>
Date: Mon, 20 Aug 2012 17:20:05 -0700
Message-ID: <CAPkEcwhr8BsAiKQ_Y-bZ4U_bO7Y65Kb_sUW1ps8kKh5hG1pB0Q@mail.gmail.com>
Subject: Re: cross-subvolume cp --reflink
From: james northrup <northrup.james@gmail.com>
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 20, 2012 at 11:08 AM, Jérôme Poulin <jeromepoulin@gmail.com> wrote:
>
> On Thu, Aug 16, 2012 at 5:41 PM, james northrup
> <northrup.james@gmail.com> wrote:
> >
> > dunno if this thread is dead, but im inclined to patch in cp --reflink
> > to "fdupes" prog.
> >  It  currently does provide a poor-man's dedupe via md5sum and hardlink,
> > or delete.
> >
> > all the better if the distro-kernels can backport cross-snapshot
> > reflinks sooner than later.
> >
>
> I was also wondering if it is possible for a program like fdupes to
> use BTRFS checksum to make searching for duplicates much faster as you
> wouldn't need to calculate checksum if BTRFS own checksum was
> mismatched between 2 groups of checksum blocks?

source in question is here..

http://code.google.com/p/fdupes/source/browse/trunk/fdupes.c

i consider cp --reflink an option for this code.  it doesn't strike me
as scalable at first glance and i wouldnt want to spend more than a
few minutes adding a  new option.

i like the idea of something a little more scalable to populate a
radix tree with extent-checksums abound and to link them without
regard to order or associative. i dont have this project in mind
myself.
