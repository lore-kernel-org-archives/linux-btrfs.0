Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:34366 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbcFCTuO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 15:50:14 -0400
Received: by mail-qg0-f52.google.com with SMTP id p34so17001406qgp.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 12:50:14 -0700 (PDT)
Subject: Re: btrfs
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <1464819934.6742.71.camel@scientia.net>
 <d500a743-7a39-8ec5-c6ce-e5a3c70ede91@nv-systems.net>
 <1464975482.6679.11.camel@scientia.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <6f18c0d1-8ac5-c325-0ba8-ffb949c54554@gmail.com>
Date: Fri, 3 Jun 2016 15:50:10 -0400
MIME-Version: 1.0
In-Reply-To: <1464975482.6679.11.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-03 13:38, Christoph Anton Mitterer wrote:
> Hey..
> 
> Hm... so the overall btrfs state seems to be still pretty worrying,
> doesn't it?
> 
> - RAID5/6 seems far from being stable or even usable,... not to talk
>   about higher parity levels, whose earlier posted patches (e.g.
>   http://thread.gmane.org/gmane.linux.kernel/1654735) seem to have
>   been given up.
There's no point in trying to do higher parity levels if we can't get
regular parity working correctly.  Given the current state of things, it
might be better to break even and just rewrite the whole parity raid
thing from scratch, but I doubt that anybody is willing to do that.
> 
> - Serious show-stoppers and security deficiencies like the UUID
>   collision corruptions/attacks that have been extensively discussed
>   earlier, are still open
The UUID issue is not a BTRFS specific one, it just happens to be easier
to cause issues with it on BTRFS, it causes problems with all Linux
native filesystems, as well as LVM, and is also an issue on Windows.
There is no way to solve it sanely given the requirement that userspace
not be broken.  Properly fixing this would likely make us more dependent
on hardware configuration than even mounting by device name.
> 
> - a number of important core features not fully working in many
>   situations (e.g. the issues with defrag, not being ref-link aware,...
>   an I vaguely remember similar things with compression).
OK, how then should defrag handle reflinks?  Preserving them prevents it
from being able to completely defragment data.  It's worth pointing out
that it is generally pointless to defragment snapshots, as they are
typically infrequently accessed in most use cases.
> 
> - OTOH, defrag seems to be viable for important use cases (VM images,
>   DBs,... everything where large files are internally re-written
>   randomly).
>   Sure there is nodatacow, but with that one effectively completely
>   looses one of the core features/promises of btrfs (integrity by
>   checksumming)... and as I've showed in an earlier large discussion,
>   none of the typical use cases for nodatacow has any high-level
>   checksumming, and even if, it's not used per default, or doesn't give
>   the same benefits at it would on the fs level, like using it for RAID
>   recovery).
The argument of nodatacow being viable for anything is a pretty
significant secondary discussion that is itself entirely orthogonal to
the point you appear to be trying to make here.
> 
> - other earlier anticipated features like newer/better compression or
>   checksum algos seem to be dead either
This one I entirely agree about.  The arguments against adding other
compression algorithms and new checksums are entirely bogus.  Ideally
we'd switch to just encoding API info from the CryptoAPI and let people
use wherever they want from there.
> 
> - still no real RAID 1
No, you mean still no higher order replication.  I know I'm being
stubborn about this, but RAID-1 is offici8ally defined in the standards
as 2-way replication.  The only extant systems that support higher
levels of replication and call it RAID-1 are entirely based on MD RAID
and it's poor choice of naming.

Overall, between this and the insanity that is raid5/6, somebody with
significantly more skill than me, and significantly more time than most
of the developers, needs to just take a step back and rewrite the whole
multi-device profile support from scratch.
> 
> - no end-user/admin grade maangement/analysis tools, that tell non-
>   experts about the state/health of their fs, and whether things like
>   balance etc.pp. are necessary
I don't see anyone forthcoming with such tools either.  As far as basic
monitoring, it's trivial to do with simple scripts from tools like monit
or nagios.  As far as complex things like determining whether a fs needs
balanced, that's really non-trivial to figure out.  Even with a person
looking at it, it's still not easy to know whether or not a balance will
actually help.
> 
> - the still problematic documentation situation
Not trying to rationalize this, but go take a look at a majority of
other projects, most of them that aren't backed by some huge corporation
throwing insane amounts of money at them have at best mediocre end-user
documentation.  The fact that more effort is being put into development
than documentation is generally a good thing, especially for something
that is not yet feature complete like BTRFS.
