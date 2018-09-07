Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58782 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727703AbeIGR4h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 13:56:37 -0400
Date: Fri, 7 Sep 2018 15:15:22 +0200
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?Q?J=FCrgen?= Herrmann <t-5@t-5.eu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: compiling btrfs-progs 4.17.1 gives error "reiserfs/misc.h: No
 such file or directory"
Message-ID: <20180907131522.GO24025@suse.cz>
Reply-To: dsterba@suse.cz
References: <e822c3d52bfef3e0f2cc4617b21f5518@t-5.eu>
 <20180907103803.GK24025@twin.jikos.cz>
 <2344f0b5de7e00bdd9d880caca86c05b@t-5.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <2344f0b5de7e00bdd9d880caca86c05b@t-5.eu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 07, 2018 at 12:51:54PM +0200, Jürgen Herrmann wrote:
> Am 7.9.2018 12:38, schrieb David Sterba:
> > On Fri, Sep 07, 2018 at 11:56:18AM +0200, Jürgen Herrmann wrote:
> >> I'm on linux mint 19, freshly installed on a new laptop about 6 weeks
> >> ago. So i wanted to compile latest btrfs-progs and latest stable 
> >> kernel
> >> first before reporting that here, BUT: I cannot compile btrfs-progs
> >> 4.17.1
> >> because of the following error:
> >> 
> >>      [CC]     convert/source-reiserfs.o
> >> In file included from convert/source-reiserfs.c:30:0:
> >> ./convert/source-reiserfs.h:23:10: fatal error: reiserfs/misc.h: No 
> >> such
> >> file or directory
> >>   #include <reiserfs/misc.h>
> >>            ^~~~~~~~~~~~~~~~~
> >> compilation terminated.
> >> Makefile:309: recipe for target 'convert/source-reiserfs.o' failed
> >> make: *** [convert/source-reiserfs.o] Error 1
> >> 
> >> A google search did not turn up any help nor does apt know of any
> >> reiserfs related libs that i could install.
> > 
> > The build dependencies are in the file INSTALL.
> 
> I admit that this was a noob mistake to not read that file :)

I partly blame the generic INSTALL file that's in GNU projects that is
useless and everybody now ignores it.

> There's no libreiserfscore on linux mint 19 though.

The distributions choose different names or packaging the libraries
separately from the base reiserfs package.

> Here's what apt finds for "reiser"
> 
> p   libguestfs-reiserfs                                 - guest disk 
> image management system - ReiserFS support
> p   libguestfs-reiserfs:i386                            - guest disk 
> image management system - ReiserFS support
> i   libreiser4-dev                                      - Reiser4's 
> filesystem access and manipulation library. Devel fi
> p   libreiser4-dev:i386                                 - Reiser4's 
> filesystem access and manipulation library. Devel fi
> p   reiser4progs                                        - administration 
> utilities for the Reiser4 filesystem
> p   reiser4progs:i386                                   - administration 
> utilities for the Reiser4 filesystem
> i   reiserfsprogs                                       - User-level 
> tools for ReiserFS filesystems
> p   reiserfsprogs:i386                                  - User-level 
> tools for ReiserFS filesystems
> 
> As you can see, libreiser4-dev is installed.

libbreiser4-dev is a different package and not the one expected for
build. You need the development package for the v3 of reisers, which
should be derived from 'reiserfsprogs'.
