Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765AbaLRNbQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 08:31:16 -0500
Date: Thu, 18 Dec 2014 14:31:12 +0100
From: Karel Zak <kzak@redhat.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-prog: improve build-system by autoconf
Message-ID: <20141218133111.GG19904@x2.net.home>
References: <1418387724-20188-1-git-send-email-kzak@redhat.com>
 <20141217140726.GY27601@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141217140726.GY27601@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 17, 2014 at 03:07:26PM +0100, David Sterba wrote:
> On Fri, Dec 12, 2014 at 01:35:14PM +0100, Karel Zak wrote:
> > This is first step to make btrfs-progs build system more conventional
> > for userspace users and developers. All is implemented by small incremental
> > patches to keep things review-able.
> 
> Thanks. I went through the patches and haven't found major problems. The
> changes are affecting build system and this will need a longer period
> before all distros have a chance to adapt to that, so I'm postponing it
> to 3.19.

Cool, I'll try to prepare next set of patches with automake.

BTW, I have good experience with build-system changes -- downstream
distributions (maintainers) are usually pretty flexible :-)

> > Note that there is also strange unused btrfs_convert_libs, btrfs_image_libs and
> > btrfs_fragments_libs variables with things like "-lgd -lpng -ljpeg -lfreetype".
> > I guess it's some legacy, right? I didn't touch these variables as I have no
> > clue about sense of this stuff.
> 
> No, it's part of the macro magic. There are pattern rules that accept
> any source in the form btrfs-something.c and also pick the libraries for
> that from variable btrfs_something_libs:
> 
> btrfs-%: $(objects) $(libs) btrfs-%.o
>         @echo "    [LD]     $@"
>         $(Q)$(CC) $(CFLAGS) -o $@ $(objects) $@.o $(LDFLAGS) $(LIBS) $($(subst -,_,$@-libs))
> 
> This is for convenience, if this turns out to be hard to do with in combination
> with autotools, I don't insist on keeping it but it has simplified the Makefile
> significantly.

OK, so -ljpeg in the Makefile is just example, right?


Anyway, for these things is better to introduce extra autoconf
AC_ARG_VAR() variables, keep is empty by default and use it in
Makefile. The advantage is that the variables are documented and
visible by ./configure --help.

For example in util-linux we have many {SUID,DAEMON,SOLIB,...}_CFLAGS
and LDFLAGS for distributions that require extensions like -fPIE,
-Wl,-z,relro etc. The same is possible to do with $LIBS.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
