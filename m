Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47543 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbaIOASl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Sep 2014 20:18:41 -0400
Date: Sun, 14 Sep 2014 17:18:36 -0700
From: Marc MERLIN <marc@merlins.org>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Subject: Re: btrfs differential receive has become excrutiatingly slow on one
 machine
Message-ID: <20140915001836.GU8530@merlins.org>
References: <20140908015124.GA21441@merlins.org>
 <CAL3q7H70SGvWamdeuvF1id-pnP0o4PskgJMb7qE+CfGBB5vd1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H70SGvWamdeuvF1id-pnP0o4PskgJMb7qE+CfGBB5vd1w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 08, 2014 at 10:49:01PM +0100, Filipe David Manana wrote:
> Hi Marc,
> 
> Does the sum of all reads from the stream file (fd 3) gets anywhere
> close to the total btrfs receive time? (or even more than 50%)
> Can you paste somewhere the full output of strace (with -T option)?

Sorry for the lack of answer, I lost the snapshot I used for that mail,
so it was not possible to do again easily.
Because my backups were so hopelessly behind, I did a full resync of
/var, i.e. not a differential send (300GB or so). The copy went at about
25GB/h, which wasn't bad at all since was over wifi (took about 14H).

I'm still waiting for the next incremental backup to run.
Once it's done, I'll try to run a smaller one under strace so I don't
have a ridiculously long log to give you.

Is there a reasonable way to know if btrfs receive is indeed hanging on
kernel code, and whether it's on receive code or on code that tries to
writes the files on the filesystem in the new snapshot?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
