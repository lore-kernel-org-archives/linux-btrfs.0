Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ny.voidptr.de ([5.45.110.253]:58912 "EHLO ny.voidptr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760522AbaGYNst (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 09:48:49 -0400
Date: Fri, 25 Jul 2014 15:48:48 +0200
From: Nils Steinger <git@n-st.de>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] btrfs-progs: Add uninstall targets to Makefiles.
Message-ID: <20140725134848.GA14867@ny.voidptr.de>
References: <53A78988.7050602@jp.fujitsu.com>
 <1403490228-3513-1-git-send-email-git@n-st.de>
 <20140623150442.GK1553@twin.jikos.cz>
 <20140625194040.GA8631@ny.voidptr.de>
 <20140627123201.GB1553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140627123201.GB1553@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I apologize for the long hiatus.

On Fri, Jun 27, 2014 at 02:32:01PM +0200, David Sterba wrote:
> On Wed, Jun 25, 2014 at 09:40:40PM +0200, Nils Steinger wrote:
> > On my system, man8dir didn't exist prior to the installation, so I
> > thought it would be reasonable to have the uninstallation routine remove
> > it.
> 
> According to the FHS [1] the manX directories do not have to exsit, so
> this part shall stay.
> 
> [1] http://www.pathname.com/fhs/pub/fhs-2.3.html#USRSHAREMANMANUALPAGES
> and then note #32
> 
> > bindir and libdir will exist by default on most systems, so that's a
> > different case…
> > So, should we really keep the directories around, even if they were
> > created by the installation and are now empty (if they aren't, they
> > won't be removed anyway)?
> 
> But we don't track if the directories were created by the installation
> or not.  Normally the directories would exist anyway (/usr or /usr/local
> as prefix) and are expected to exist at the locations. Installation to
> arbitraty directory works, but managing the directories is IMO up to the
> user.
> 
> So are you ok with keeping bindir and libdir only (ie. removing only
> man8dir)?

Yes, that should be sensible. I've updated my patch accordingly and
resubmitted it few minutes ago.

Regards,
Nils
