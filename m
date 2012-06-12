Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:62718 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751924Ab2FLPME convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 11:12:04 -0400
Received: by lahd3 with SMTP id d3so3588965lah.19
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jun 2012 08:12:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1477951.uUzcAEg64Z@when>
References: <1339183466.55421.YahooMailNeo@web160803.mail.bf1.yahoo.com>
	<pan.2012.06.12.01.53.23@cox.net>
	<1477951.uUzcAEg64Z@when>
Date: Tue, 12 Jun 2012 10:12:03 -0500
Message-ID: <CAGJTRcj67JvpuTK9EivYd14K4YRgdRuKyUvj9nhLR1PaUPvSGQ@mail.gmail.com>
Subject: Re: Moving top level to a subvolume
From: Michael <mike@draftx.net>
To: Randy Barlow <randy@electronsweatshop.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The Ubuntu wiki does not(in a straight-forward way) say BTRFS is
experimental and unstable. It looks like they copied and pasted from
the BTRFS official Wiki.
Link:  https://help.ubuntu.com/community/btrfs

I do not have an account on the BTRFS wiki, but I believe changing the
first paragraphs to something like what I included at the bottom. The
big change is that we need to specifically and in big bold letters say
that BTRFS is experimental and unstable as well as outline that BTRFS
shouldn't be used on data where loss would cause headaches.
I don't think that as is we draw enough attention to these facts. We
are assuming that by saying(on the Wiki) "Btrfs is under heavy
development" people will realize that it is experimental and unstable.
Right after that we say that "every effort is being made to keep the
filesystem stable and fast" which reads more like, "we are making
every effort to KEEP it stable and fast". This ambiguity would lead
users to believe that BTRFS is fast and stable(instead of that "we are
attempting to have it be fast and stable")
----
Btrfs is under heavy development, but while every effort is being made
to keep the filesystem stable and fast, it is still marked as
[bold][bold]experimental and unstable[/bold][/bold]. Btrfs should not
yet be used on data where loss would cause headaches. Because of the
speed of development, you should run the latest kernel you can (either
the latest release kernel from kernel.org, or the latest -rc kernel.
Please email the Btrfs mailing list if you have any problems or
questions while using Btrfs.
----

On Tue, Jun 12, 2012 at 9:52 AM, Randy Barlow
<randy@electronsweatshop.com> wrote:
>
> On Tuesday, June 12, 2012 01:53:23 AM Duncan wrote:
> > We get a lot of folks on this list who somehow miss the kernel warning,
> > and the wiki warning, and the general community knowledge, that btrfs is
> > still marked experimental and is still under heavy development.  If
> > something goes wrong, as it often has for these folks when they post
> > here...
>
> I personally run Gentoo, but I've been told by some coworkers that the Ubuntu
> installer offers btrfs as an option to the users without marking it as
> experimental, unstable, or under development. I wonder if that is why we see
> so many people surprised when they lose their filesystems. Can anyone verify
> whether that is true of Ubuntu, or of any other Linux distributions?
>
> --
> R
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
