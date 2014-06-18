Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46547 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbaFRP3H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 11:29:07 -0400
Date: Wed, 18 Jun 2014 17:29:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH V2] btrfs-progs: add mount options to btrfs-mount.5
Message-ID: <20140618152906.GW1903@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5398D475.4070309@redhat.com>
 <5398D4DF.9080508@redhat.com>
 <20140612105151.GN1903@twin.jikos.cz>
 <5399BB92.2070205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5399BB92.2070205@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 12, 2014 at 09:39:14AM -0500, Eric Sandeen wrote:
> > So what if the mount options are generated from btrfs-mount.txt but
> > installed under btrfs.5.gz name? If there are more section 5 manpages we
> > can make it more generic but for now hardcoding btrfs-mount.* ->
> > btrfs.5. sounds ok to me.
> 
> Yeah, that seemed like kind of nasty hard-coding, but I suppose it works
> for now.  I wanted to make it more generic, I didn't have a better idea..

Added:

--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -85,6 +85,9 @@ install-man: man
        $(INSTALL) -d -m 755 $(DESTDIR)$(man5dir)
        $(INSTALL) -d -m 755 $(DESTDIR)$(man8dir)
        $(INSTALL) -m 644 $(GZ_MAN5) $(DESTDIR)$(man5dir)
+       # the source file name of btrfs.5 clashes with section 8 page, but we
+       # want to keep the code generic
+       mv $(DESTDIR)$(man5dir)/btrfs-mount.5.gz $(DESTDIR)$(man5dir)/btrfs.5.gz
        $(INSTALL) -m 644 $(GZ_MAN8) $(DESTDIR)$(man8dir)
        $(LNS) btrfs-check.8.gz $(DESTDIR)$(man8dir)/btrfsck.8.gz

So the MAN5 code is generic, the exception is only at the installation time.
