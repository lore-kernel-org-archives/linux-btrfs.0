Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45607 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdILSr5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 14:47:57 -0400
Date: Tue, 12 Sep 2017 11:47:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Adam Borowski <kilobyte@angband.pl>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Marat Khalili <mkh@rqc.ru>,
        Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
Message-ID: <20170912184749.GA4359@infradead.org>
References: <69e843f4-1233-261a-3b88-306359ef20c9@rqc.ru>
 <pan$556a1$a0a94487$f12a0554$4371a5e6@cox.net>
 <20170912103214.6dzjlugcr7q47x6g@angband.pl>
 <2a0186c7-7c56-2132-fa0d-da2129cde22c@rqc.ru>
 <CAGqmi776z5DzXZbXF=mS6wtUGk4YMhcWT9uJUXOFzwAd5KMU3g@mail.gmail.com>
 <20170912111159.jcwej7s6uluz4dsz@angband.pl>
 <2679f652-2fee-b1ee-dcce-8b77b02f9b01@rqc.ru>
 <20170912172125.rb6gtqdxqneb36js@angband.pl>
 <d1f6450c-fc09-171c-82c8-32caa2cbd230@gmail.com>
 <20170912184359.hovirdaj55isvwwg@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170912184359.hovirdaj55isvwwg@angband.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 12, 2017 at 08:43:59PM +0200, Adam Borowski wrote:
> For now, though, I wonder -- should we send fine folks at util-linux a patch
> to make fallocate -d restore mtime, either always or on an option?

Don't do that.  Please just add a new ioctl or fallocate command
that punches a hole if the range is zeroed, similar to what dedup
does.  It can probably even reuse a few helpers.
