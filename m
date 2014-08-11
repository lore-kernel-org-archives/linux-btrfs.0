Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:51164 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753790AbaHKPzo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 11:55:44 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [BUG] btrfs send/receive, page allocation failure
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAL3q7H5rpoPFBKjLD9F0_4UdBcG8BgzKUQGGTzbmBmdkG2_Jwg@mail.gmail.com>
Date: Mon, 11 Aug 2014 09:55:42 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <51F1A674-280C-4AF9-93BD-82B38F8E9C92@colorremedies.com>
References: <2BBB0EBF-DD55-45B4-8BF5-F8DAA9398A4F@colorremedies.com> <CF539008-5930-447D-B26C-2A2BBE9337EA@colorremedies.com> <CAL3q7H591BbVenxFn_EiBDyqmJEcwgOKjw0Xv2J+jkgic+3dxQ@mail.gmail.com> <16C9BBD0-FD7B-488B-A77F-E937007F292F@colorremedies.com> <CAL3q7H5rpoPFBKjLD9F0_4UdBcG8BgzKUQGGTzbmBmdkG2_Jwg@mail.gmail.com>
To: fdmanana@gmail.com
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 11, 2014, at 2:46 AM, Filipe David Manana <fdmanana@gmail.com> wrote:

> On Mon, Aug 11, 2014 at 4:07 AM, Chris Murphy <lists@colorremedies.com> wrote:
>>> 
>>> 
>>> Can you try the following patch and confirm if it helps?
>>> https://patchwork.kernel.org/patch/4705171/
>> 
>> This one applies without problems, I didn't build it because I saw v4. The v4 patch I get:
>> 
>> + patch -p1 -F1 -s
>> 4 out of 4 hunks FAILED -- saving rejects to file fs/btrfs/send.c.rej
>> 
>> Should v4 alone be applied over 3.16.0? Or each version in succession?
> 
> Alone. How did you try to apply it to 3.16?

rpmbuild
https://fedoraproject.org/wiki/Building_a_custom_kernel

Gist is, save the patch, create patch filename entry into kernel.spec, then run rpmbuild. rpmbuild uses 'patch -p1 -F1 -s' to apply the patch. The v1 patch applies, as does Liu Bo's patch from July 29 "Btrfs: fix regression of btrfs device replace" which I was also going to test. But the v4 patch isn't applying.

> Try "cd source_dir && git
> am patchfile" if you didn't (e.g. you used patch command directly).

I'd kinda prefer to build an rpm since I need to test it on baremetal for this bug, and a VM for the device replace bug.


Chris Murphy