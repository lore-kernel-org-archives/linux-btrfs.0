Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40116 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbcG2W5n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 18:57:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bTGir-00011d-TQ
	for linux-btrfs@vger.kernel.org; Sat, 30 Jul 2016 00:57:41 +0200
Received: from p579d0472.dip0.t-ipconnect.de ([87.157.4.114])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jul 2016 00:57:41 +0200
Received: from holger by p579d0472.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jul 2016 00:57:41 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger@applied-asynchrony.com>
Subject: Re: memory overflow or undeflow in free space tree / space_info?
Date: Fri, 29 Jul 2016 22:57:36 +0000 (UTC)
Message-ID: <pan$37980$c346042$59d16808$deaf83b2@applied-asynchrony.com>
References: <229a1d13-32f1-cd4c-975f-2db6796eb6c7@profihost.ag>
	<20160729191153.GA28505@vader> <20160729191459.GB28505@vader>
	<40a46d57-fe32-e745-9897-8f5c6ca2b33e@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 29 Jul 2016 17:03:43 -0400, Josef Bacik wrote:

> On 07/29/2016 03:14 PM, Omar Sandoval wrote:
>> On Fri, Jul 29, 2016 at 12:11:53PM -0700, Omar Sandoval wrote:
>>> On Fri, Jul 29, 2016 at 08:40:26PM +0200, Stefan Priebe - Profihost AG wrote:
>>>> Dear list,
>>>>
>>>> i'm seeing btrfs no space messages frequently on big filesystems (> 30TB).
>>>>
>>>> In all cases i'm getting a trace like this one a space_info warning.
>>>> (since commit [1]). Could someone please be so kind and help me
>>>> debugging / fixing this bug? I'm using space_cache=v2 on all those systems.
>>>
>>> Hm, so I think this indicates a bug in space accounting somewhere else
>>> rather than the free space tree itself. I haven't debugged one of these
>>> issues before, I'll see if I can reproduce it. Cc'ing Josef, too.
>>
>> I should've asked, what sort of filesystem activity triggers this?
>>
> 
> Chris just fixed this I think, try his next branch from his git tree
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
> 
> and see if it still happens.  Thanks,
> 
> Josef

Hi Josef,

can you say which patch you have in mind? The tree in question
doesn't have any of Chandra's pagesize/sectorsize patches (carefully
patched around, for stability and LTS patchability) so I hope it's
not the recent commit

8b8b08cb "fix delalloc accounting after copy_from_user faults"

because that would be too fiddly (at least for me) to backport
correctly.

The only other patch I just found missing and which looks like it
could/should (I think?) work on top of the 4.4.x pagesize-based
calculations in file.c is:

a2af23b7 "__btrfs_buffered_write: Pass valid file offset when
releasing delalloc space"

Would that make sense? Neither I nor any other users of that tree
have observed weird space-info underflows so far (and I use my
fs daily), so it's definitely something peculiar Stefan is doing
with his weird compressed rsync-inplace workload. Odd sector offsets
causing slowly creeping space_info underflow sounds to me like it
just might be the problem.

thanks,
Holger

