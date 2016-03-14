Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:41400 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbcCNR4r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 13:56:47 -0400
Date: Mon, 14 Mar 2016 20:48:44 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V4 2/2] btrfs-progs: Introduce device delete by devid
Message-ID: <20160314174844.GA22266@jeknote.loshitsa1.net>
References: <1444123990-8832-1-git-send-email-anand.jain@oracle.com>
 <1457518226-601-1-git-send-email-anand.jain@oracle.com>
 <20160309165515.GA18908@suse.cz>
 <56E0E569.5010309@oracle.com>
 <20160310164056.GI18908@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160310164056.GI18908@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 10, 2016 at 05:40:56PM +0100, David Sterba wrote:
> On Thu, Mar 10, 2016 at 11:09:29AM +0800, Anand Jain wrote:
> > 
> > > Please send any followup changes on top of the current devel patch.
> > 
> >   I kind of missed this point at the wiki.
> >     --
> >     The git repositories on kernel.org are not used for development
> >     or integration branches.
> >     --
> >   Thanks for the update on how things work at your end, which helps
> >   to keep loss of productive at low.
> 
> The development branch workflow in progs has been used for months, I
> don't know why that would be news for you.
> 
> >   Suggest that we need to update similar for the kernel
> >   section as well. I see some of the inactive branches
> >   being mentioned there. And its bit confusing as of now.
> 
> That's probably the section about btrfs-next tree that is not active for
> a long time. Apparently nobody cared enough to fix it which just
> underlines lack of active wiki editors.
> 
> I don't understand why you bring it up now, you're a long-term
> contributor so you're supposed to know how the patches get merged.

This is actual question for me too. Now I track Chris Mason's git tree
for latest integrated changes but if any other active git repositories
exist, please say. We are like to use btrfs actively in future (and use
it now) in our customer's products, so I intend to be involved in
development.


And last question about development process: can I hope that btrfs
maintainers will use the patchwork.kernel.org for patches tracking?
It's sometimes very difficult to track status of patches sent to
mailing list. For instance, I am trying to get Anand's patches for
'global hot spare' functionality working, they depends from two
another patchsets which were re-sent few times with changes and
introduced new bugs etc...

Btw, Anand, if you have public git repo with 'global hotspare' patches,
could you please send it's location also?

-- 
Yauhen Kharuzhy
