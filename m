Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3CORwk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 13:52:40 -0400
Date: Fri, 15 Mar 2013 18:52:37 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org, Hugo Mills <h.r.mills@reading.ac.uk>
Subject: Re: [PATCH] btrfs-progs: add Makefile rule for static build of
 btrfs-find-root
Message-ID: <20130315175236.GI7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1363103051-10207-1-git-send-email-hugo@carfax.org.uk>
 <20130312175325.GR7229@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130312175325.GR7229@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 12, 2013 at 06:53:25PM +0100, David Sterba wrote:
> On Tue, Mar 12, 2013 at 03:44:11PM +0000, Hugo Mills wrote:
> > +btrfs-find-root.static: $(static_objects) $(libs) find-root.static.o
> 
> I've noticed that the (newly added) mkfs.btrfs.static target does not
> depend on $(libs) and this is correct

... well, it's partially correct, we don't need $(libs) but we need the
object files and possibly built with the same cflags as the rest of the
.static.o group. So far the build works if libbtrfs.a is built and the
final binary is linked against it. I finally made it to compile and link
the way it should IMHO be, patch will follow after cleaning.

david
