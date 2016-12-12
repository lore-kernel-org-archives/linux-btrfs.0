Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53056 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752488AbcLLREi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 12:04:38 -0500
Date: Mon, 12 Dec 2016 18:04:31 +0100
From: David Sterba <dsterba@suse.cz>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [RESEND][PATCH v2] btrfs-progs: add dev stats returncode option
Message-ID: <20161212170431.GW12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161205183520.67039-1-ahferroin7@gmail.com>
 <20161208172030.GJ12522@twin.jikos.cz>
 <6eedaa73-2bb5-62aa-7570-4b836d589854@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6eedaa73-2bb5-62aa-7570-4b836d589854@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 08, 2016 at 12:54:14PM -0500, Austin S. Hemmelgarn wrote:
> On 2016-12-08 12:20, David Sterba wrote:
> > On Mon, Dec 05, 2016 at 01:35:20PM -0500, Austin S. Hemmelgarn wrote:
> >> Currently, `btrfs device stats` returns non-zero only when there was an
> >> error getting the counter values.  This is fine for when it gets run by a
> >> user directly, but is a serious pain when trying to use it in a script or
> >> for monitoring since you need to parse the (not at all machine friendly)
> >> output to check the counter values.
> >>
> >> This patch adds an option ('-s') which causes `btrfs device stats`
> >> to set bit 6 in the return code if any of the counters are non-zero.
> >> This greatly simplifies checking from a script or monitoring software if
> >> any errors have been recorded.  In the event that this switch is passed
> >> and an error occurs reading the stats, the return code will have bit
> >> 0 set (so if there are errors reading counters, and the counters which
> >> were read were non-zero, the return value will be 65).
> >
> > So a typical check in a script would look for either 64 or 65 returned
> > from the command, I don't think we can do it simpler. The option naming
> > is a bit confusing to me, as it duplicates the 'stats' from the command
> > itself. I'd suggest to use '--check' instead, does it sound OK to you?
> >
> > I'll apply the patch as-is for now (and maybe do some cleanups in the
> > surrounding code).
> >
> Yeah, --check is fine.  Like I said, I'm not too picky about the name as 
> long as it works.

Thanks. Changed to -c and added the long option --check for that.
