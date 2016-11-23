Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59677 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934187AbcKWJpI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Nov 2016 04:45:08 -0500
Date: Wed, 23 Nov 2016 10:45:04 +0100
From: David Sterba <dsterba@suse.cz>
To: Mike Gilbert <floppymaster@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs-4.8.3 libbtrfs missing symbols?
Message-ID: <20161123094504.GO12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJ0EP40tqX7MhtHcUiCMW5hRUrkhS+c3xPe=nRqCK8m5dc4FPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ0EP40tqX7MhtHcUiCMW5hRUrkhS+c3xPe=nRqCK8m5dc4FPA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 22, 2016 at 01:49:15PM -0500, Mike Gilbert wrote:
> Hi,
> 
> I received a bug report about a build failure in a package (snapper)
> that utilizes libbtrfs.
> 
> https://bugs.gentoo.org/show_bug.cgi?id=600078
> 
> To summarize the issue, the package has a configure test that executes
> the following:
> 
> configure:16618: x86_64-pc-linux-gnu-gcc -o conftest -O2 -pipe
> -march=amdfam10 -frecord-gcc-switches -std=c99 -Wall -Wextra
> -Wformat=2 -Wmissing-prototypes -Wno-unused-parameter
> -DCONFDIR='"/etc/conf.d"' -Wl,-O1 -Wl,--as-needed conftest.c -lbtrfs
> >&5
> /usr/lib/gcc/x86_64-pc-linux-gnu/5.4.0/../../../../lib64/libbtrfs.so:
> undefined reference to `lookup_path_rootid'
> collect2: error: ld returned 1 exit status
> configure:16618: $? = 1
> 
> It seems that the "lookup_path_rootid" symbol is not included in the library.
> 
> Could someone look into this?

Thanks for the report, bug reproduced here. My referential snapper build
does not fail so I did not know about that. I've now extended the
library test to cover the missing symbol. As the build does not fail
it's needed to actually run the built binary.

Fixed in devel now, I'll release 4.8.4 with this (and maybe other)
bugfixes.
