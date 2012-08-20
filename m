Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62241 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2HTSI4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Aug 2012 14:08:56 -0400
Received: by vbbff1 with SMTP id ff1so5607941vbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Aug 2012 11:08:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPkEcwgSZ8umbFeuZ-fQAFAprBubL58eFSf4TQ=Z13ks8i9DOQ@mail.gmail.com>
References: <20120401152749.61790@gmx.net>
	<CALJXSJpjOX3t6Xa=gFF2p13eSb+SJfRc_pc0d5ScShnK-5BwkQ@mail.gmail.com>
	<2272893.XFoXOC5Zif@bursa22>
	<op.wdjl3kx0r07q8e@tron.scheibner.rb>
	<CAPkEcwgSZ8umbFeuZ-fQAFAprBubL58eFSf4TQ=Z13ks8i9DOQ@mail.gmail.com>
Date: Mon, 20 Aug 2012 14:08:55 -0400
Message-ID: <CALJXSJphSSGaXjBhtrzNKk3-F_xw-PMzWLT3AW6CLDGGoAN_qA@mail.gmail.com>
Subject: Re: cross-subvolume cp --reflink
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        james northrup <northrup.james@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 16, 2012 at 5:41 PM, james northrup
<northrup.james@gmail.com> wrote:
>
> dunno if this thread is dead, but im inclined to patch in cp --reflink to "fdupes" prog.
>  It  currently does provide a poor-man's dedupe via md5sum and hardlink, or delete.
>
> all the better if the distro-kernels can backport cross-snapshot reflinks sooner than later.
>

I was also wondering if it is possible for a program like fdupes to
use BTRFS checksum to make searching for duplicates much faster as you
wouldn't need to calculate checksum if BTRFS own checksum was
mismatched between 2 groups of checksum blocks?
