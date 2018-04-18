Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32987 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752757AbeDRN3q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 09:29:46 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 84F73AEA1
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 13:29:45 +0000 (UTC)
Date: Wed, 18 Apr 2018 15:03:24 +0200
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?Q?Ren=E9?= Rebe <rene@exactcode.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Kernel unaligned access at ... btrfs_real_readdir+0x51c/0x718
 [btrfs]
Message-ID: <20180418130324.GM21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CF3AC07F-83D7-41FE-ABE5-C442DAB29292@exactcode.com>
 <20180416164805.GQ21272@twin.jikos.cz>
 <83e9ab82-1ee8-11ac-6987-127722aaba69@exactcode.com>
 <20180416191533.GZ21272@twin.jikos.cz>
 <40C44E95-3281-4E2C-83F6-CF6139FC4D19@exactcode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <40C44E95-3281-4E2C-83F6-CF6139FC4D19@exactcode.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 17, 2018 at 12:18:45PM +0200, René Rebe wrote:
> On 16 Apr 2018, at 21:15, David Sterba <dsterba@suse.cz> wrote:
> > On Mon, Apr 16, 2018 at 09:55:45PM +0200, René Rebe wrote:
> >> On 04/16/2018 06:48 PM, David Sterba wrote:
> >>> The warnings are valid, there's unaligned access introduced by patch
> >>> 
> >>> 23b5ec74943f44378b68c0edd8e210a86318ea5e
> >>> btrfs: fix readdir deadlock with pagefault
> >>> 
> >>> The directory entries (struct dir_entry) are copied to a temporary
> >>> buffer as they fit, ie. no alignment, and the members accessed in
> >>> several places.
> >>> 
> >>> The following patch adds the proper unaligned access, only compile-tested.
> >>> Please test and let me know, thanks!
> >> Would have loved to immediately give it a try, however, sorry,
> >> I forgot to mention I'm on the latest stable release -4.16.2-
> >> on a first glance this does not look like it does just apply.
> >> 
> >> I would re-base myself if I would not also have a glibc initialization 
> >> bug to hunt and debug, too :-/
> >> 
> >> If you happen to also rebase it for current -stable, ... ;-)
> > 
> > Sure, attached a 4.16.2 version.
> > <0001-test-readdir-unaligned-access.patch>
> 
> Cool, thanks, built and so far it works, the warnings are gone.
> 
> 	https://www.youtube.com/watch?v=XYsKct4T2xk

Thanks for testing on a real hardware! I'm not aware of regular runtime
testing on sparc, the other architectures with strict alignment
requirement have probably the emulation turned on by default so the
warnings do not appear. Or nobody bothers to report them though the
fixes are typically simple.

I like your vintage hw videos, keep going!
