Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:59034 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753308AbcLIIoG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Dec 2016 03:44:06 -0500
Date: Fri, 9 Dec 2016 09:43:52 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: out-of-band dedup status?
Message-ID: <20161209084352.GB28652@angband.pl>
References: <1481222198.6563.3.camel@scientia.net>
 <539d7c1c-5041-fb99-0ec5-81291f9f6609@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <539d7c1c-5041-fb99-0ec5-81291f9f6609@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 08, 2016 at 03:15:38PM -0500, Jeff Mahoney wrote:
> On 12/8/16 1:36 PM, Christoph Anton Mitterer wrote:
> > I just wondered whether out-of-band/"offline" dedup is safe for general
> > use... https://btrfs.wiki.kernel.org/index.php/Status kinda implies so
> > (it tells about unspecified performance issues), but this seems again
> > already outdated (kernel 4.7)...
> 
> SUSE supports it in SLE12 using our 3.12 and 4.4 -based kernels.  There
> haven't been a lot of changes to the kernel component of it.  It's
> pretty simple: check to see if the ranges are identical between two
> files and then reflink between them.
> 
> > Any other things in terms of possible issues, data corruption, etc.
> > that one should know when using deduplication?
> 
> There shouldn't be.  We haven't had any bug reports at SUSE.

I use it on busy machines on ancient kernels (3.14, one 3.13) without any
hint of problems other than dedupe itself being slow.


Meow!
-- 
u-boot problems can be solved with the help of your old SCSI manuals, the
parts that deal with goat termination.  You need a black-handled knife, and
an appropriate set of candles (number and color matters).  Or was it a
silver-handled knife?  Crap, need to look that up.
