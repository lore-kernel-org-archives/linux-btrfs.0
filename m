Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbbC0Uv4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Mar 2015 16:51:56 -0400
Date: Fri, 27 Mar 2015 13:51:55 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs dedup - available or experimental? Or yet to be?
Message-ID: <20150327205155.GF17170@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <meq6hm$lbh$1@ger.gmane.org>
 <20150323232212.GL31762@carfax.org.uk>
 <CAGfcS_=6iHH+4T6CH8ag6MSf2N5n37pE6USSOjDTv=BMmFHQaw@mail.gmail.com>
 <mf2701$d5k$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <mf2701$d5k$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 27, 2015 at 12:07:29AM +0000, Martin wrote:
> Excellent and very rapid packaging, thanks!
> 
> 
> Already compiled, installed, and soon to be tried on a test subvolume...
> 
> 
> Anyone with any comments on how well duperemove performs for TB-sized
> volumes?

https://github.com/markfasheh/duperemove/wiki/Performance-Numbers

That page has some sample performance numbers. Keep in mind that the tests
were done on reasonably nice hardware.

TB-size is definitely on the larger end of what I expect it should handling
these days. The biggest problem you would see is memory usage - versions
0.09 and below will be storing all hashes in memory so if everything else is
fast enough that's likely the first bump you'll hit.

Master branch has some code which reduces our memory consumption
dramatically by using a bloom filter and temporarily storing them on disk.
That branch needs some more features and bug fixing before I'm ready to call
it stable.


> Does it work across subvolumes? (Presumably not...)

Yep it will dedupe across subvolumes for you!
	--Mark

--
Mark Fasheh
