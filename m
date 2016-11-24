Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44386 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935768AbcKXK6n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Nov 2016 05:58:43 -0500
Date: Thu, 24 Nov 2016 11:58:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Mike Gilbert <floppymaster@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs-4.8.3 libbtrfs missing symbols?
Message-ID: <20161124105838.GT12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <CAJ0EP40tqX7MhtHcUiCMW5hRUrkhS+c3xPe=nRqCK8m5dc4FPA@mail.gmail.com>
 <20161123094504.GO12522@twin.jikos.cz>
 <CAJ0EP41JOGvqvC5uxGNX2OcrZUe7KhsCGzKyEd29aKBiVci68g@mail.gmail.com>
 <CAJ0EP43Way2cfHzZXt2mhiBNhVBRiGBsTj_KFp+vYoZB-3yieA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ0EP43Way2cfHzZXt2mhiBNhVBRiGBsTj_KFp+vYoZB-3yieA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 23, 2016 at 01:49:53PM -0500, Mike Gilbert wrote:
> On Wed, Nov 23, 2016 at 1:43 PM, Mike Gilbert <floppymaster@gmail.com> wrote:
> > On Wed, Nov 23, 2016 at 4:45 AM, David Sterba <dsterba@suse.cz> wrote:
> >> On Tue, Nov 22, 2016 at 01:49:15PM -0500, Mike Gilbert wrote:
> >>> Hi,
> >>>
> >>> I received a bug report about a build failure in a package (snapper)
> >>> that utilizes libbtrfs.
> >>>
> >>> https://bugs.gentoo.org/show_bug.cgi?id=600078
> >>>
> >>> To summarize the issue, the package has a configure test that executes
> >>> the following:
> >>>
> >>> configure:16618: x86_64-pc-linux-gnu-gcc -o conftest -O2 -pipe
> >>> -march=amdfam10 -frecord-gcc-switches -std=c99 -Wall -Wextra
> >>> -Wformat=2 -Wmissing-prototypes -Wno-unused-parameter
> >>> -DCONFDIR='"/etc/conf.d"' -Wl,-O1 -Wl,--as-needed conftest.c -lbtrfs
> >>> >&5
> >>> /usr/lib/gcc/x86_64-pc-linux-gnu/5.4.0/../../../../lib64/libbtrfs.so:
> >>> undefined reference to `lookup_path_rootid'
> >>> collect2: error: ld returned 1 exit status
> >>> configure:16618: $? = 1
> >>>
> >>> It seems that the "lookup_path_rootid" symbol is not included in the library.
> >>>
> >>> Could someone look into this?
> >>
> >> Thanks for the report, bug reproduced here. My referential snapper build
> >> does not fail so I did not know about that. I've now extended the
> >> library test to cover the missing symbol. As the build does not fail
> >> it's needed to actually run the built binary.
> >
> > That's very strange; I definitely get a build-time failure here. Maybe
> > there's some difference in your toolchain.
> >
> > On current master:
> >
> > floppym@naomi btrfs-progs % make V=1 library-test
> >     [LD]     library-test
> > gcc -g -O1 -Wall -D_FORTIFY_SOURCE=2 -include config.h
> > -DBTRFS_FLAT_INCLUDES -D_XOPEN_SOURCE=700 -fno-strict-aliasing -fPIC
> > -I/home/floppym/src/btrfs-progs
> > -I/home/floppym/src/btrfs-progs/kernel-lib    -o library-test
> > library-test.o -rdynamic  -lbtrfs
> > /usr/lib/gcc/x86_64-pc-linux-gnu/5.4.0/../../../../lib64/libbtrfs.so:
> > undefined reference to `lookup_path_rootid'
> > collect2: error: ld returned 1 exit status
> > make: *** [Makefile:433: library-test] Error 1
> 
> Oh! Based on that command line, library-test is getting linked against
> /usr/lib64/libbtrfs.so instead of the freshly built copy in $PWD.

Oh, right, that's what we get when we don't use automake :)

> You probably need to add -L. or -L$(TOPDIR) to that command in the Makefile.

That was it, thank you!
