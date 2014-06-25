Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ny.voidptr.de ([5.45.110.253]:49587 "EHLO ny.voidptr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbaFYTrG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 15:47:06 -0400
Date: Wed, 25 Jun 2014 21:40:40 +0200
From: Nils Steinger <git@n-st.de>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: Add uninstall targets to Makefiles.
Message-ID: <20140625194040.GA8631@ny.voidptr.de>
References: <53A78988.7050602@jp.fujitsu.com>
 <1403490228-3513-1-git-send-email-git@n-st.de>
 <20140623150442.GK1553@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140623150442.GK1553@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 23, 2014 at 05:04:42PM +0200, David Sterba wrote:
> On Mon, Jun 23, 2014 at 04:23:48AM +0200, Nils Steinger wrote:
> > +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(man8dir)
> 
> > +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(libdir)
> 
> > +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(bindir)
> 
> I don't think it's right to remove the systemwide directories: bindir,
> libdir and man8dir. There rest are btrfs subdirs (eg. incdir), that's
> fine.

On my system, man8dir didn't exist prior to the installation, so I
thought it would be reasonable to have the uninstallation routine remove
it. bindir and libdir will exist by default on most systems, so that's a
different case…
So, should we really keep the directories around, even if they were
created by the installation and are now empty (if they aren't, they
won't be removed anyway)?
