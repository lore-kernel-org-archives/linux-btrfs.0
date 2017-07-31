Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49873 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbdGaVSD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 17:18:03 -0400
Date: Mon, 31 Jul 2017 14:17:50 -0700
From: Marc MERLIN <marc@merlins.org>
To: Ivan Sizov <sivan606@gmail.com>
Cc: Martin Steigerwald <martin@lichtvoll.de>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Duncan <1i5t5.duncan@cox.net>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a
 more recent gen (33682) compared to the found root node (0)
Message-ID: <20170731211750.bpo4roiqkr4t5iae@merlins.org>
References: <20170501170641.GG3516@merlins.org>
 <20170707163834.GA6083@merlins.org>
 <20170709043417.GE6704@merlins.org>
 <21425367.VGcO8ck7Vu@merkaba>
 <CAMG9ccyWS87NwUrJGNvF6Dt440yhCp_P9_-hFeJE70YDRwpfNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMG9ccyWS87NwUrJGNvF6Dt440yhCp_P9_-hFeJE70YDRwpfNg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 01, 2017 at 12:07:14AM +0300, Ivan Sizov wrote:
> 2017-07-09 10:57 GMT+03:00 Martin Steigerwald <martin@lichtvoll.de>:
> > Hello Marc.
> >
> > Marc MERLIN - 08.07.17, 21:34:
> >> Sigh,
> >>
> >> This is now the 3rd filesystem I have (on 3 different machines) that is
> >> getting corruption of some kind (on 4.11.6).
> >
> > Anyone else getting corruptions with 4.11?
> Yes, a lot. There are at least 3 cases, probably I've missed something.
> https://www.spinics.net/lists/linux-btrfs/msg67177.html
> https://www.spinics.net/lists/linux-btrfs/msg67681.html
> https://unix.stackexchange.com/questions/369133/dealing-with-btrfs-ref-backpointer-mismatches-backref-missing/369275

Indeed. My main server is happy back on 4.9.36 and while my laptop is
stuck on 4.11 due to other kernel issues that prevent me from going back
to 4.9, it only corrupted a single filesystem so far, and no other ones
that I've noticed yet.
Hopefully that will hold :-/

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
