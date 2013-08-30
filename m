Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab3H3VDj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 17:03:39 -0400
Date: Fri, 30 Aug 2013 14:03:28 -0700
From: Zach Brown <zab@redhat.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/15] btrfs-progs: get C=1 sparse checking working again
Message-ID: <20130830210328.GU26818@lenny.home.zabbo.net>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
 <1376522205-16992-2-git-send-email-zab@redhat.com>
 <20130830160838.GN23113@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130830160838.GN23113@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Very nice, thanks.
> 
> I'm getting this error, for each built object file:
> 
> $ make V=1 C=1
>     [SP]     ctree.o

Heh, I goofed when building the echo and actual rules, might as well
update that to $< to have it output .c?

        @$(check_echo) "    [SP]     $@"
        $(Q)$(check) $(AM_CFLAGS) $(CFLAGS) $<

:)

> sparse -include .cc-defines.h  -D__CHECKER__ -D__CHECK_ENDIAN__ -Wbitwise -Wuninitialized -Wshadow -Wundef -Wall -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES -fPIC -g -O1 ctree.c
> /usr/include/stdio.h:33:12: error: unable to open 'stddef.h'
> make: *** [ctree.o] Error 1

*nod*.  I also ran in to this on another box.  Indeed, as you said in a
later email, this comes from older sparse not knowing to add the
internal gcc include installation paths to its search path.  You can
hack this yourself:

gcc_install := "$(shell gcc --print-search | \
                awk '($$1 == "install:"){print $$2}')/install"

	sparse -I$(gcc_install)

But honestly, I'm not sure that we should bother, given all the other
problems with older sparse.  It seems acceptable to ask people to run
the latest git snapshot.  It's easy.

- z
