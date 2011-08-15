From: Billy Crook <billycrook@gmail.com>
Subject: Re: licenses (for apple OSX and others)?
Date: Mon, 15 Aug 2011 12:39:45 -0500
Message-ID: <CANZ96zW1wW7uaKP2wkagH7avW-RDouoP-M6GtE6oFSYW=kUHfw@mail.gmail.com>
References: <CAPr7RtVfNtNno=7KTJvyvNFnkumHd3PiJSo8eoswBZT-0vwFQA@mail.gmail.com>
 <1313420602-sup-9846@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ivo welch <ivowel@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1313420602-sup-9846@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Maybe Apple and Microsoft can write a GPL FUSE-like wrapper for btrfs.

On Mon, Aug 15, 2011 at 10:15, Chris Mason <chris.mason@oracle.com> wro=
te:
> Excerpts from ivo welch's message of 2011-08-14 20:34:14 -0400:
>> curiosity question---could btrfs be licensed in multiple ways to all=
ow
>> Apple and other vendors to adopt it? =A0as end users, having one goo=
d
>> file system that works everywhere as a main root system would be
>> heaven...
>
> One of the ways you can tell people like the project is when they wis=
h
> they could use it everywhere. =A0Thanks for this question ;)
>
> There are a few problems with relicensing btrfs under something other
> than the GPL.
>
> Large parts of the btrfs code that deal with the VFS were copied from
> ext2 and ext3. =A0These are GPL and would have to be reimplemented. =A0=
The
> code that deals with the page cache was also lifted and adapted from
> different parts of the kernel, and it is surprising how far the roots=
 of
> the page cache spread into the rest of the code.
>
> More importantly, btrfs has major contributions from many companies a=
nd
> individuals. =A0I intentionally set things up so there wouldn't be a
> single place you could go and say 'xyz' owns the btrfs code, we'll
> ask them for permission.
>
> Just like most of the kernel, we have maintainers and contributors,
> but not a single owner. =A0This is a big part of why others feel
> comfortable contributing to btrfs, and to be honest it's one of my
> favorite parts of the project.
>
> None of this prevents others from using btrfs outside of linux, but i=
f
> they do it'll be under the GPL.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
