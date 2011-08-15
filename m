From: Chris Mason <chris.mason@oracle.com>
Subject: Re: licenses (for apple OSX and others)?
Date: Mon, 15 Aug 2011 11:15:05 -0400
Message-ID: <1313420602-sup-9846@shiny>
References: <CAPr7RtVfNtNno=7KTJvyvNFnkumHd3PiJSo8eoswBZT-0vwFQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: ivo welch <ivowel@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <CAPr7RtVfNtNno=7KTJvyvNFnkumHd3PiJSo8eoswBZT-0vwFQA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from ivo welch's message of 2011-08-14 20:34:14 -0400:
> curiosity question---could btrfs be licensed in multiple ways to allow
> Apple and other vendors to adopt it?  as end users, having one good
> file system that works everywhere as a main root system would be
> heaven...

One of the ways you can tell people like the project is when they wish
they could use it everywhere.  Thanks for this question ;)

There are a few problems with relicensing btrfs under something other
than the GPL.

Large parts of the btrfs code that deal with the VFS were copied from
ext2 and ext3.  These are GPL and would have to be reimplemented.  The
code that deals with the page cache was also lifted and adapted from
different parts of the kernel, and it is surprising how far the roots of
the page cache spread into the rest of the code.

More importantly, btrfs has major contributions from many companies and
individuals.  I intentionally set things up so there wouldn't be a
single place you could go and say 'xyz' owns the btrfs code, we'll
ask them for permission.

Just like most of the kernel, we have maintainers and contributors,
but not a single owner.  This is a big part of why others feel
comfortable contributing to btrfs, and to be honest it's one of my
favorite parts of the project.

None of this prevents others from using btrfs outside of linux, but if
they do it'll be under the GPL.

-chris
