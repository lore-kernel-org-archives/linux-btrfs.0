Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from msa105.auone-net.jp ([61.117.18.165]:32773 "EHLO
	msa105.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3GJCGO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jul 2013 22:06:14 -0400
Date: Wed, 10 Jul 2013 11:06:11 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Fix automatic prerequisite generation
References: <20130706082232.1679715C03A@msa104.auone-net.jp>
 <20130708164607.GC18204@twin.jikos.cz>
 <20130708170925.GD18204@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130708170925.GD18204@twin.jikos.cz>
Message-Id: <20130710020612.7CF616FC03D@msa105.auone-net.jp>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-07-08 19:09:25 +0200, David Sterba wrote:
> On Mon, Jul 08, 2013 at 06:46:07PM +0200, David Sterba wrote:
> > On Sat, Jul 06, 2013 at 05:22:31PM +0900, Kusanagi Kouichi wrote:
> > > Some files don't compile because of insufficient prerequisite.
> > > 
> > > $ make btrfs
> > > ...
> > >     [CC]     btrfs.o
> > > btrfs.c:24:21: fatal error: version.h: No such file or directory
> > >  #include "version.h"
> > >                      ^
> > > compilation terminated.
> > > make: *** [btrfs.o] Error 1
> > 
> > Works great, thanks. I've noticed that DEPFLAGS is now unused and
> > removed it.
> 
> Two more small things: the files were previously named .something.o.d and
> now they're something.d .
> 
> * .gitignore needs to be updated
> * I'd prefer to keep the suffix .o.d, the leading . has go away due to
>   the macro tricks
> 
> I'll fold the following patch if you don't mind

Looks good to me. Thanks.

> --- a/.gitignore
> +++ b/.gitignore
> @@ -1,6 +1,6 @@
>  *.o
>  *.static.o
> -.*.o.d
> +*.o.d
>  version.h
>  version
>  man/*.gz
> diff --git a/Makefile b/Makefile
> index 70880bc..849e3fe 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -76,8 +76,8 @@ else
>         check = true
>  endif
> 
> -%.d: %.c
> -       $(Q)$(CC) -MM -MG -MF $@ -MT $(@:.d=.o) -MT $(@:.d=.static.o) -MT $@ $(AM_CFLAGS) $(CFLAGS) $<
> +%.o.d: %.c
> +       $(Q)$(CC) -MM -MG -MF $@ -MT $(@:.o.d=.o) -MT $(@:.o.d=.static.o) -MT $@ $(AM_CFLAGS) $(CFLAGS) $<
> 
>  .c.o:
>         $(Q)$(check) $<
> @@ -186,7 +186,7 @@ install-man:
> 
>  clean :
>         @echo "Cleaning"
> -       $(Q)rm -f $(progs) cscope.out *.o *.d btrfs-convert btrfs-image btrfs-select-super \
> +       $(Q)rm -f $(progs) cscope.out *.o *.o.d btrfs-convert btrfs-image btrfs-select-super \
>               btrfs-zero-log btrfstune dir-test ioctl-test quick-test send-test btrfsck \
>               btrfs.static mkfs.btrfs.static btrfs-calc-size \
>               version.h \
> @@ -205,5 +205,5 @@ install: $(libs) $(progs) install-man
>         $(INSTALL) -m644 $(headers) $(DESTDIR)$(incdir)
> 
>  ifneq ($(MAKECMDGOALS),clean)
> --include $(objects:.o=.d) $(cmd-objects:.o=.d) $(subst .btrfs,, $(filter-out btrfsck.d, $(progs:=.d)))
> +-include $(objects:.o=.o.d) $(cmd-objects:.o=.o.d) $(subst .btrfs,, $(filter-out btrfsck.o.d, $(progs:=.o.d)))
>  endif
> 
