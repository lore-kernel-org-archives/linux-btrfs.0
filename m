Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab3DXMnq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 08:43:46 -0400
Date: Wed, 24 Apr 2013 14:43:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] btrfs-progs: Add default rules to Makefile
Message-ID: <20130424124343.GA16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <517463E4.7040400@redhat.com>
 <517466AD.9060401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <517466AD.9060401@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 21, 2013 at 05:22:37PM -0500, Eric Sandeen wrote:
> This gets rid of a lot of the cut and pasted rules for
> each individual command, and as an added bonus makes it
> easy to build any btrfs-$FOO statically as well, i.e.
> 
>   # make btrfs-convert.static

Nice!

> +# keep intermediate files from the below implicit rules around
> +.PRECIOUS: $(addsuffix .o,$(progs))

I guess you saw something like

$ make btrfs-calc-size.static
...
rm btrfs-calc-size.static.o

at the end of the make output (though there's not rule to rm the file).

I've found this blogpost
http://darrendev.blogspot.cz/2008/06/stopping-make-delete-intermediate-files.html
that describes how to prevent the intermediate files to disappear, and
I've verified that this

-.PRECIOUS: $(addsuffix .o,$(progs))
+.SECONDARY:

works as expected in our case. Besides this change I moved the per-prog
libs variables up in the Makefile so the configurable settings are kept
close together:

+# external libs required by various binaries; for btrfs-foo,
+# specify btrfs_foo_libs = <list of libs>; see $($(subst...)) rules below
+btrfs_convert_libs = -lext2fs -lcom_err
+btrfs_image_libs = -lpthread
+btrfs_fragment_libs = -lgd -lpng -ljpeg -lfreetype


david
