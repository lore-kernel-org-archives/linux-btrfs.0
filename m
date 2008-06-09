From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BUG ON linux/ppc 2.6.24.
Date: Sun, 8 Jun 2008 21:51:28 -0400
Message-ID: <200806082151.28534.chris.mason@oracle.com>
References: <f058a9c30806051416g11216654m34b6c8e2b72b3395@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30806051416g11216654m34b6c8e2b72b3395@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 05 June 2008, Miguel Sousa Filipe wrote:
> Hi there,
>
> Running ubuntu 8.04 on ibook.
> Linux newton 2.6.24-17-powerpc #1 Thu May 1 13:56:51 UTC 2008 ppc GNU/Linux
>
> a fresh hg pull of btrfs0.15, with btrfs on a lvm.
>
> btrfsck is clean.
>
> creation of files and dirs work, but a simple echo "a" > a, or a cp, tar
> ..etc.. result in segfault/core dump of application and this is what I get
> from dmesg:

This oops looks like the apparmor oops, which we try to get around by testing 
for CONFIG_SECURITY_APPARMOR

Any chance you've self compiled the ubuntu kernel with this turned off?

At any rate, if you change compat.h to enable REMOVE_SUID_PATH things should 
work.  If REMOVE_SUID_PATH is already enabled, I'll tell you to turn it 
off ;)

-chris
