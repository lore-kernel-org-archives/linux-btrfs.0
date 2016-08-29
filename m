Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750786AbcH2RDj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 13:03:39 -0400
Date: Mon, 29 Aug 2016 19:02:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Lukas Lueg <lukas.lueg@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Multiple bugs found by fuzzing BTRFS
Message-ID: <20160829170220.GY16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJF-kYko=dSuCmxpj6uJmKRZtAOhYCzoK=8hoyqBAe5UA8nQUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAJF-kYko=dSuCmxpj6uJmKRZtAOhYCzoK=8hoyqBAe5UA8nQUg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

thanks for the testing and reports.

On Mon, Aug 29, 2016 at 08:06:24AM +0200, Lukas Lueg wrote:
> I've now spent around 160 hours of fuzzing BTRFS, here are the crashes
> I found so far. Every type of crash is reported only once although
> there are usually multiple locations where they show up (especially
> heap-use-after-free and calls to abort()).
> 
> The following bug reports have attached to them images of ±18kb which
> expand to 16mb and reproduce a crash when running btrfsck; they all
> have been revirginized so CRC- and FSID-checks pass by a vanilla
> btrfsck.
> 
> 
> Use-after-free, shows up all over the place:
> https://bugzilla.kernel.org/show_bug.cgi?id=153641
> 
> Segfault in memcpy, yeah: https://bugzilla.kernel.org/show_bug.cgi?id=154021
> 
> Run-off-the-mill buffer-overflow:
> https://bugzilla.kernel.org/show_bug.cgi?id=154961
> 
> Endless loop in btrfsck: https://bugzilla.kernel.org/show_bug.cgi?id=155151
> 
> Calls to abort() by lack of error paths:
> https://bugzilla.kernel.org/show_bug.cgi?id=155181
> 
> Division by zero, the old problem of computing stripe_size:
> https://bugzilla.kernel.org/show_bug.cgi?id=155201
> 
> 
> There are many more crashes like the above; how do you guys want them
> to be reported?

It's good to have them tracked in bugzilla, I'm CCed on all new
bugreports so I'll know about them and you don't need to post them to
the mailinglist. It'd be great to send a summary mail to the mailinglist
when you do the testing round.

Please give us some time to fix the issues before the next round, to
avoid reporting potentially fixed issues.
