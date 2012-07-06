Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-2.hut.fi ([130.233.228.92]:33637 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab2GFXoM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 19:44:12 -0400
Date: Sat, 7 Jul 2012 02:44:05 +0300
From: Sami Liedes <sami.liedes@iki.fi>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120706234405.GB8933@sli.dy.fi>
References: <20120704001713.GA8986@sli.dy.fi>
 <4FF42876.8010309@jan-o-sch.net>
 <20120704160340.GA9770@sli.dy.fi>
 <4FF47168.9010405@jan-o-sch.net>
 <20120704202452.GA8996@sli.dy.fi>
 <4FF5998D.8020205@jan-o-sch.net>
 <20120705234739.GA9736@sli.dy.fi>
 <4FF6C12A.10305@jan-o-sch.net>
 <20120706143350.GA10427@sli.dy.fi>
 <4FF6FF8C.4010007@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FF6FF8C.4010007@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Retry: I think this mail didn't make it to the list, probably because
of the 73 kilobyte attached log. Here's a URL to the file:]

   http://www.niksula.hut.fi/~sliedes/btrfs-scrub-debug.log.gz

	Sami


------------------------------------------------------------
On Fri, Jul 06, 2012 at 05:09:00PM +0200, Jan Schmidt wrote:
> Oh I see. root->node can be NULL during mount. Please add this on top:

Ok. So, ran it with DEBUG_PAGEALLOC and slub debugging on. This time
it took half an hour to crash, and there's _lots_ of checksum mismatch
[234] messages even before the crash. gzipped dmesg attached.

At 781 seconds there's an "irq 17: nobody cared". That's a known bug
with this (and other Asus) motherboards and happens every now and
then. I doubt it has anything to do with this.

I think I might try running it overnight with KMEMCHECK to see if it
reports something. But for now, what there's in the log:

* lots of checksum mismatch [234], no 1s

* a fair number of "csum_tree_block: [0-9]+ callbacks suppressed"
  lines

* two "btrfs: node seems invalid now. checksum ok = 1" messages, one
  at 1499 seconds and another just before the crash at 1973

* Just before the crash:
  btrfs: invalid parameters for read_extent_buffer: start (32771) > eb->len (32768). eb start is 2261163409408, level 100, generation 4412718571037421157, nritems 538968254. len param 17. debug 2/989/538968254/4412718571037421157/0x0/0/0x0/0x0

* the oopses

> > By the way, something seems to be untabifying your patches. I don't
> > know if it's on my side or yours, but at least some other patches I
> > receive via linux-btrfs contain tabs. Doing a M-x tabify in emacs
> > mostly makes them apply cleanly for me.
> 
> Oh, I'm sorry. Should have been on my side. I hope it's better with the current
> diff?

Yes. No problem :)

[See attachment for dmesg log.]

	Sami
