Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693AbaF0McD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 08:32:03 -0400
Date: Fri, 27 Jun 2014 14:32:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Nils Steinger <git@n-st.de>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: Add uninstall targets to Makefiles.
Message-ID: <20140627123201.GB1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53A78988.7050602@jp.fujitsu.com>
 <1403490228-3513-1-git-send-email-git@n-st.de>
 <20140623150442.GK1553@twin.jikos.cz>
 <20140625194040.GA8631@ny.voidptr.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140625194040.GA8631@ny.voidptr.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 25, 2014 at 09:40:40PM +0200, Nils Steinger wrote:
> On Mon, Jun 23, 2014 at 05:04:42PM +0200, David Sterba wrote:
> > On Mon, Jun 23, 2014 at 04:23:48AM +0200, Nils Steinger wrote:
> > > +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(man8dir)
> > 
> > > +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(libdir)
> > 
> > > +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(bindir)
> > 
> > I don't think it's right to remove the systemwide directories: bindir,
> > libdir and man8dir. There rest are btrfs subdirs (eg. incdir), that's
> > fine.
> 
> On my system, man8dir didn't exist prior to the installation, so I
> thought it would be reasonable to have the uninstallation routine remove
> it.

According to the FHS [1] the manX directories do not have to exsit, so
this part shall stay.

> bindir and libdir will exist by default on most systems, so that's a
> different case…
> So, should we really keep the directories around, even if they were
> created by the installation and are now empty (if they aren't, they
> won't be removed anyway)?

But we don't track if the directories were created by the installation
or not.  Normally the directories would exist anyway (/usr or /usr/local
as prefix) and are expected to exist at the locations. Installation to
arbitraty directory works, but managing the directories is IMO up to the
user.

So are you ok with keeping bindir and libdir only (ie. removing only
man8dir)?

Thanks.

[1] http://www.pathname.com/fhs/pub/fhs-2.3.html#USRSHAREMANMANUALPAGES
and then note #32
