Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56150 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaEFMUf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 08:20:35 -0400
Date: Tue, 6 May 2014 05:19:37 -0700
From: Marc MERLIN <marc@merlins.org>
To: Brendan Hide <brendan@swiftspirit.co.za>,
        Calvin Walton <calvin.walton@kepstin.ca>,
        Russell Coker <russell@coker.com.au>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Please review and comment, dealing with btrfs full issues
Message-ID: <20140506121937.GD10159@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <34134059.SEVPBPKYjM@russell.coker.com.au>
 <1399314969.4155.1.camel@sasami>
 <5367C5C2.9070808@swiftspirit.co.za>
 <5367C551.6020604@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 05, 2014 at 07:07:29PM +0200, Brendan Hide wrote:
> "In the case above, because the filesystem is only 55% full, I can
> ask balance to rewrite all chunks that are more than 55% full:
> 
> legolas:~# btrfs balance start -dusage=50 /mnt/btrfs_pool1"
> 
> "-dusage=50" will balance all chunks that are 50% *or less* used,

Sorry, I actually meant to write 55 there.

> not more. The idea is that full chunks are better left alone while
> emptyish chunks are bundled together to make new full chunks,
> leaving big open areas for new chunks. Your process is good however
> - just the explanation that needs the tweak. :)

Mmmh, so if I'm 55% full, should I actually use -dusage=45 or 55?

> In your last example, a full rebalance is not necessary. If you want
> to clear all unnecessary chunks you can run the balance with
> -dusage=80 (636GB/800GB~=79%). That will cause a rebalance only of
> the data chunks that are 80% and less used, which would by necessity
> get about ~160GB worth chunks back out of data and available for
> re-use.

So in my case when I hit that case, I had to use dusage=0 to recover.
Anything above that just didn't work.

On Mon, May 05, 2014 at 07:09:22PM +0200, Brendan Hide wrote:
> Forgot this part: Also in your last example, you used "-dusage=0"
> and it balanced 91 chunks. That means you had 91 empty or
> very-close-to-empty chunks. ;)

Correct. That FS was very mis-balanced.

On Mon, May 05, 2014 at 02:36:09PM -0400, Calvin Walton wrote:
> The standard response on the mailing list for this issue is to
> temporarily add an additional device to the filesystem (even e.g. a 4GB
> USB flash drive is often enough) - this will add space to allocate a few
> new chunks, allowing the balance to proceed. You can remove the extra
> device after the balance completes.

I just added that tip, thank you.
 
On Tue, May 06, 2014 at 02:41:16PM +1000, Russell Coker wrote:
> Recently kernel 3.14 allowed fixing a metadata space error that seemed to be 
> impossible to solve with 3.13.  So it's possible that some of my other 
> problems with a lack of metadata space could have been solved with kernel 3.14 
> too.

Good point. I added that tip too.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
