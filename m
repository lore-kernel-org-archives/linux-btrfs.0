Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758623Ab3IBOnt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Sep 2013 10:43:49 -0400
Date: Mon, 2 Sep 2013 16:43:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org, Kusanagi Kouichi <slash@ac.auone-net.jp>
Subject: Re: [PATCH 2/3] Btrfs-progs: move test tools to tests/ subdir
Message-ID: <20130902144345.GZ23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1370992519-21369-1-git-send-email-sandeen@redhat.com>
 <1370992519-21369-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370992519-21369-3-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 11, 2013 at 06:15:18PM -0500, Eric Sandeen wrote:
> Move test tools to tests/

>  rename btrfs-corrupt-block.c => tests/btrfs-corrupt-block.c (100%)

IMO this is not a test by itself, so it should stay in the toplevel dir.

> --- /dev/null
> +++ b/tests/Makefile
> @@ -0,0 +1,49 @@
eg.
TOPLEVEL = ..

> +CFLAGS += -I..
CFLAGS += -I$(TOPLEVEL)

> +
> +objects := $(addprefix ../, $(objects))

etc. s/../$(TOPLEVEL)

> +
> +lib_LIBS = -lblkid -luuid
> +LIBS = $(lib_LIBS) $(addprefix ../, $(libs_static))
> +
> +# These last 2 don't actually build anymore
> +progs = btrfs-corrupt-block ioctl-test quick-test send-test # random-test dir-test
> +
> +libs_static = libbtrfs.a
> +libs = $(addprefix ../, $(libs_static))
> +headers = $(libbtrfs_headers)
> +

the default rule belongs here, ie
all: $(progs)

Otherwise 'make' in the tests/ subdir will try to execute the first .c
file it needs to build.

> +.c.o:
> +	$(Q)$(check) $<
> +	@echo "    [CC]     $@"
> +	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<

Until now we've had only man/ and it does not compile anything, now
tests/ duplicate the .c.o: rule. The rules are not exported to subdirs,
we need either to duplicate it in every subdir/Makefile or have
something like Makefile.rules or builddefs, and each Makefile has to
keep track back to the toplevel dir. We want to be able to 'make tests'
but also just 'make' in the tests/ directory -- which does not work
right now.

> +
> +all: $(progs)
> +

> +clean :
> +	$(Q)rm -f *.o .*.d $(progs)
> +
> +-include .*.d

This should probably look like the update in the toplevel makefile:

ifneq ($(MAKECMDGOALS),clean)
-include $(objects:.o=.o.d) $(cmd-objects:.o=.o.d) $(subst .btrfs,, $(filter-out btrfsck.o.d, $(progs:=.o.d)))
endif

and for the clean: rule a minor update: the .d files do not start with '.'.
(Both introduced in "btrfs-progs: Fix automatic prerequisite generation")

Let's start with moving just the tests, see how the makefiles work and
then proceed with cmds/ and the shared kernel files.


david
