Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37730 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933972Ab3GQAOU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jul 2013 20:14:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UzFNq-0006Qq-Fv
	for linux-btrfs@vger.kernel.org; Wed, 17 Jul 2013 02:14:18 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 02:14:18 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 02:14:18 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: [PATCH 4/4] btrfs: offline dedupe
Date: Wed, 17 Jul 2013 00:14:02 +0000 (UTC)
Message-ID: <ks4nka$o2d$2@ger.gmane.org>
References: <1370982698-757-1-git-send-email-mfasheh@suse.de>
	<1370982698-757-5-git-send-email-mfasheh@suse.de>
	<20130715205551.GT25414@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 15 Jul 2013 13:55:51 -0700, Zach Brown wrote:
> I'd get rid of all this code by only copying each input argument on to
> the stack as it's needed and by getting rid of the writable output
> struct fields.  (more on this later)

> As I said, I'd get rid of the output fields.  Like the other vectored io
> syscalls, the return value can indicate the number of initial
> consecutive bytes that worked.  When no progess was made then it can
> return errors.  Userspace is left to sort out the resulting state and
> figure out the extents to retry in exactly the same way that it found
> the initial extents to attempt to dedupe in the first place.
> 
> (And imagine strace trying to print the inputs and outputs.  Poor, poor,
> strace! :))

The dedup branch that uses this syscall[1] doesn't compare files
before submitting them anymore (the kernel will do it, and ranges
may not fit in cache once I get rid of an unnecessary loop).

I don't have strong opinions on the return style, but it would be
good to have the syscall always make progress by finding at least
one good range before bailing out, and signaling which files were
involved.  With those constraints, the current struct seems like the
cleanest way to pass the data.  The early return you suggest is a
good idea if Mark agrees, but the return condition should be
something like: if one range with bytes_deduped != 0 doesn't get
bytes_deduped incremented by iteration_len in this iteration, bail
out.
That's sufficient to guarantee progress and to know which ranges
were involved.

> I hope this helps!
> 
> - z

Thank you and everyone involved for the progress on this.

[1] https://github.com/g2p/bedup/tree/wip/dedup-syscall


