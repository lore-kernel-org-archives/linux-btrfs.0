Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbaESS1z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 14:27:55 -0400
Date: Mon, 19 May 2014 11:27:53 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Konstantinos Skarlatos <k.skarlatos@gmail.com>,
        Brendan Hide <brendan@swiftspirit.co.za>,
        Scott Middleton <scott@assuretek.com.au>, linux-btrfs@vger.kernel.org
Subject: Re: send/receive and bedup
Message-ID: <20140519182753.GP27178@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com> <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net> <CAPm-YUWryMcGFop+miu+dnMBac6gf-mdJCx07XHPxdr66h3Big@mail.gmail.com> <20140519010705.GI10566@merlins.org> <CAPm-YUVXGRA1AnXoJA5+7P_MhFweaw163+b1fA97VW4cLPS01g@mail.gmail.com> <537A2AD5.9050507@swiftspirit.co.za> <537A3B63.40806@gmail.com> <537A4665.9080202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <537A4665.9080202@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 19, 2014 at 01:59:01PM -0400, Austin S Hemmelgarn wrote:
> On 2014-05-19 13:12, Konstantinos Skarlatos wrote:
> > I have been testing duperemove and it seems to work just fine, in
> > contrast with bedup that i have been unable to install/compile/sort out
> > the mess with python versions. I have 2 questions about duperemove:
> > 1) can it use existing filesystem csums instead of calculating its own?
> While this might seem like a great idea at first, it really isn't.
> BTRFS uses CRC32c at the moment as it's checksum algorithm, and while
> that is relatively good at detecting small differences (i.e. a single
> bit flipped out of every 64 or so bytes), it is known to have issues
> with hash collisions.  Normally, the data on disk won't change enough
> even from a media error to cause a hash collision, but when you start
> using it to compare extents that aren't known to be the same to begin
> with, and then try to merge those extents, you run the risk of serious
> file corruption.  Also, AFAIK, BTRFS doesn't expose the block checksum
> to userspace directly (although I may be wrong about this, in which case
> i retract the following statement) this would therefore require some
> kernelspace support.

I'm pretty sure you could get the checkums via ioctl. The thing about dedupe
though is that kernel is always doing a byte-by-byte comparison of the file
data before merging it so we should never corrupt just because userspace
gave us a bad range to dedupe. That said I don't necessarily disagree that
it might not be as good an idea as it sounds.
	--Mark

--
Mark Fasheh
