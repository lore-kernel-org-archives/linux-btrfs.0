Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:42270 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932933AbcIUKZv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 06:25:51 -0400
Subject: Re: Status of free-space-tree feature
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com,
        osandov@fb.com
References: <20160921092406.GD16983@twin.jikos.cz>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <57E2602C.7050703@applied-asynchrony.com>
Date: Wed, 21 Sep 2016 12:25:48 +0200
MIME-Version: 1.0
In-Reply-To: <20160921092406.GD16983@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/21/16 11:24, David Sterba wrote:
> Hi,
> 
> as you might have noticed, the [1] wiki Status page lists the
> free-space-tree as 'Unstable', referencing a problem with the bitmap
> endianity. This will affect only bigendian systems.
> 
> There's one more problem that I overlooked but was pointed to by Omar
> recently.  The initial FST support in btrfs-progs is read-only,
> 
> https://marc.info/?l=linux-btrfs&m=144113538017042
> 
> "However, we're not adding the FREE_SPACE_TREE read-only compat bit to
> the set of supported bits because progs doesn't know how to keep the
> free space tree consistent."
> 
> Historically, the initial patchset version did not recognize FST feature
> and thus refused to write, but then it was pointed by Qu and Holger that
> the compat_ro bit is missing for FST. I've added it but this was a
> mistake. This change is going to be reverted.

I'm not sure I understand - can you explain why this is was so wrong?
Or Omar maybe?

If btrfsck wants to correct something (write), it can simply always
and unconditionally invalidate the fst instead of trying to "repair"
it..and I think that's what happens at the moment (at least I think
it did for me recently). That seems like a safe and simple way.

The fst by itself seems to be working really well even in extreme
scenarios (Stefan Priebe's 50+ TB filesystems come to mind, which fell
over on a regular basis before I merged the fst into my "stable++"
kernels), and considering how many bugs we've seen in the past from
the v1 cache, I was really hoping that we can make v2 the default
soon instead of skirting around the issue even longer.

Of course if there are plain old runtime bugs in the fst then they need
to be considered, but this seems to be about btrfs-progs support.

-h

