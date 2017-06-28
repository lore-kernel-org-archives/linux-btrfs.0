Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42591 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751752AbdF1PlF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 11:41:05 -0400
Date: Wed, 28 Jun 2017 17:39:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL] Btrfs for 4.13, part 1
Message-ID: <20170628153954.GJ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1498229425.git.dsterba@suse.com>
 <007ac50e-71e2-6e25-7d17-821720a37317@fb.com>
 <CAL3q7H4W6ag=1SZQ83WoYa9r+h3RsC4NR=mV_VYB6=fgZVA9xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4W6ag=1SZQ83WoYa9r+h3RsC4NR=mV_VYB6=fgZVA9xw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 27, 2017 at 12:00:20PM +0100, Filipe Manana wrote:
> On Mon, Jun 26, 2017 at 5:58 PM, Chris Mason <clm@fb.com> wrote:
> > On 06/23/2017 11:16 AM, David Sterba wrote:
> >> this is the main batch for 4.13. There are some user visible changes, see
> >> below. The core updates improve error handling (mostly related to bios),
> >> with
> >> the usual incremental work on the GFP_NOFS (mis)use removal. All patches
> >> have
> >> been in for-next for an extensive amount of time.
> >>
> >> Thre will be followups but I want push the series (111 patches) forward.
> >> There
> >> are also some updates to adjacent subsystems (writeback and blocklayer),
> >> so I
> >> want to give some stable point for merging in the upcoming weeks.
> >
> > Thanks Dave, I ran this (along with the updates we added) through a long
> > stress and the usual xfstests.
> 
> Have any of you run xfstests without failures?

Without any failures, no, with acceptable failures at this point in
development cycle, yes. The dir-item validation failures are fixable and
will come next. I haven't seen the crashes in raid56, thanks for the
report.

> I'm finding it hard to believe, as some of these changes cause
> problems all the time, and at least one of them deterministically
> ("btrfs: fix validation of XATTR_ITEM dir items"), as I've just noted
> in the respective thread for that patch.

Yeah, that was an incomplete fix for a bug that I had reported but did
not receive a fix in time to send the pull request. I want the dir-item
validation patches merged now, we have enough time to fix the failures.

The merge window is due in the next weeks, major part of the patches
be ready earlier, so I'm deciding what's applicable even it's not
perfect.  Known and fixable failures are just fine right now, theres
whole rc1-rc5 period.

You might disagree with this approach. The quality dropped, somebody did
not verify the code, run the tests or check the results. Fill in the
names. I'm not developers' QA, I put patches together and push further
upstream. Reviews cost a lot of time, driving multiple patchsets forward
is exhausting. So I do not test each and every commit or address all
failures immediatelly, I count on the time where this can happen. And
also on the rest of the developer crew.

(Note for casual readers of this mail: I want to set the expectations
right, there's nothing personal.)
