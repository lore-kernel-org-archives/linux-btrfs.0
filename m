Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:44698 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbaHNNYX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 09:24:23 -0400
Received: by mail-ig0-f177.google.com with SMTP id hn18so4931084igb.16
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 06:24:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADCGFBWSor1oZ7XzqcJZ4-4XwCS-TbMHmBRzezRi01=SRVjpQA@mail.gmail.com>
References: <CADCGFBVa42xr+4ie20GupFfZJzteihPNDnr4b_8_8UmfK_0M5w@mail.gmail.com>
 <CAKcLGm-JPT9XY7pS2Fv_G1RWXyovcYVQeO1WMR3a+DHm_PNoHg@mail.gmail.com>
 <20130710225454.GJ25386@twin.jikos.cz> <CADCGFBWSor1oZ7XzqcJZ4-4XwCS-TbMHmBRzezRi01=SRVjpQA@mail.gmail.com>
From: Roger Pack <rogerpack2005@gmail.com>
Date: Thu, 14 Aug 2014 07:23:53 -0600
Message-ID: <CADCGFBW8CiRB7j+jsiLtjuFdku24rvnSkENwv27+aDv0tG9=jQ@mail.gmail.com>
Subject: Fwd: lz4 status?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 10, 2013 at 4:54 PM, David Sterba <dsterba@suse.cz> wrote:
>
> On Sun, Jun 30, 2013 at 12:35:09PM -0500, Mitch Harder wrote:
> > There's been a parallel effort to incorporate a general set of lz4
> > patches in the kernel.
> >
> > I see these patches are currently queued up in the linux-next tree, so
> > we may see them in the 3.11 kernel.
>
> The patches are now merged into 3.11.
>
> > It looks like lz4 and lz4hc will be provided.
>
> Regarding HC mode, there are some core compression code changes needed
> in order to fully utilize the its potential, namely larger chunk size
> that's compressed at a time. There was some tiny yet measurable gain of
> HC against ordinary mode compared on current 4k-at-a-time
> implementation, but the space savings did not justify the speed drop of
> HC mode.
>
> I can't say if the patchset will be ready for 3.12 though.
>
> david


Any update here re: lz4 integration?
I noticed some people here saying they saw it not available yet?
http://www.phoronix.com/forums/showthread.php?94912-Btrfs-Gets-Big-Changes-Features-In-Linux-3-14-Kernel
Cheers!
-roger-
