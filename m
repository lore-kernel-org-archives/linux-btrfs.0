Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbcCNShI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 14:37:08 -0400
Date: Mon, 14 Mar 2016 19:36:43 +0100
From: David Sterba <dsterba@suse.cz>
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
Cc: Anand Jain <anand.jain@oracle.com>, Chris Mason <clm@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V4 2/2] btrfs-progs: Introduce device delete by devid
Message-ID: <20160314183643.GB21722@suse.cz>
Reply-To: dsterba@suse.cz
References: <1444123990-8832-1-git-send-email-anand.jain@oracle.com>
 <1457518226-601-1-git-send-email-anand.jain@oracle.com>
 <20160309165515.GA18908@suse.cz>
 <56E0E569.5010309@oracle.com>
 <20160310164056.GI18908@twin.jikos.cz>
 <20160314174844.GA22266@jeknote.loshitsa1.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160314174844.GA22266@jeknote.loshitsa1.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2016 at 08:48:44PM +0300, Yauhen Kharuzhy wrote:
> On Thu, Mar 10, 2016 at 05:40:56PM +0100, David Sterba wrote:
> > On Thu, Mar 10, 2016 at 11:09:29AM +0800, Anand Jain wrote:
> > > 
> > > > Please send any followup changes on top of the current devel patch.
> > > 
> > >   I kind of missed this point at the wiki.
> > >     --
> > >     The git repositories on kernel.org are not used for development
> > >     or integration branches.
> > >     --
> > >   Thanks for the update on how things work at your end, which helps
> > >   to keep loss of productive at low.
> > 
> > The development branch workflow in progs has been used for months, I
> > don't know why that would be news for you.
> > 
> > >   Suggest that we need to update similar for the kernel
> > >   section as well. I see some of the inactive branches
> > >   being mentioned there. And its bit confusing as of now.
> > 
> > That's probably the section about btrfs-next tree that is not active for
> > a long time. Apparently nobody cared enough to fix it which just
> > underlines lack of active wiki editors.
> > 
> > I don't understand why you bring it up now, you're a long-term
> > contributor so you're supposed to know how the patches get merged.
> 
> This is actual question for me too. Now I track Chris Mason's git tree
> for latest integrated changes but if any other active git repositories
> exist, please say. We are like to use btrfs actively in future (and use
> it now) in our customer's products, so I intend to be involved in
> development.

Partially covered at

https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories

depends if you want btrfs-progs or kernel.

> And last question about development process: can I hope that btrfs
> maintainers will use the patchwork.kernel.org for patches tracking?

We've tried. I had to script around patchwork heavily to make it usable
but it's still not my priority to keep the patchwork status up to date.
I do run some scripts after releases to mark the done and actually
merged, but this may miss patches that got renamed subject.

> It's sometimes very difficult to track status of patches sent to
> mailing list. For instance, I am trying to get Anand's patches for
> 'global hot spare' functionality working, they depends from two
> another patchsets which were re-sent few times with changes and
> introduced new bugs etc...

Well, the number of submitted patchsets is larger than the review
bandwidth required to get them merged. From my personal standpoint, I
monitor patches from areas close to me or features I'd like to get
merged. And I don't manage to cover all of them, unlikely in the
timeframe they're submitted. Most patchsets have impact on various
internals and introduce/modify the interfaces, such things need review
from people who understand the code or the problematics.

Sending a patchset repeatedly helps, it's kind of a reminder for us and
that the author cares about it. Separating patches to small reviewable
pieces is basically considered a good practice, sending preparatory
patchsets that do cleanups or introduce stuff that would be used later
helps to focus on the core changes when they come.

It's considered ok in btrfs community to send emails or ping on IRC and
ask people privately about the plans or status.

HTH.
