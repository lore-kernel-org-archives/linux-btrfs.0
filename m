Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57613 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab3H3V1L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 17:27:11 -0400
Date: Fri, 30 Aug 2013 23:27:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/15] btrfs-progs: get C=1 sparse checking working again
Message-ID: <20130830212708.GR23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
 <1376522205-16992-2-git-send-email-zab@redhat.com>
 <20130830160838.GN23113@twin.jikos.cz>
 <20130830210328.GU26818@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130830210328.GU26818@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 30, 2013 at 02:03:28PM -0700, Zach Brown wrote:
> Heh, I goofed when building the echo and actual rules, might as well
> update that to $< to have it output .c?
> 
>         @$(check_echo) "    [SP]     $@"
>         $(Q)$(check) $(AM_CFLAGS) $(CFLAGS) $<

Yeah, looks better with .c

> > sparse -include .cc-defines.h  -D__CHECKER__ -D__CHECK_ENDIAN__ -Wbitwise -Wuninitialized -Wshadow -Wundef -Wall -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES -fPIC -g -O1 ctree.c
> > /usr/include/stdio.h:33:12: error: unable to open 'stddef.h'
> > make: *** [ctree.o] Error 1
> 
> *nod*.  I also ran in to this on another box.  Indeed, as you said in a
> later email, this comes from older sparse not knowing to add the
> internal gcc include installation paths to its search path.  You can
> hack this yourself:
> 
> gcc_install := "$(shell gcc --print-search | \
>                 awk '($$1 == "install:"){print $$2}')/install"
> 
> 	sparse -I$(gcc_install)
> 
> But honestly, I'm not sure that we should bother, given all the other
> problems with older sparse.  It seems acceptable to ask people to run
> the latest git snapshot.  It's easy.

Ack.

I've reinstalled from the distro provided package with tag
sparse-20130425 and it worked.

david
