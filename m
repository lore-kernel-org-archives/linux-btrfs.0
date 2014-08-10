Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45325 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaHJOjB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 10:39:01 -0400
Date: Sun, 10 Aug 2014 07:39:00 -0700
From: Marc MERLIN <marc@merlins.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Fixing the btrfs deadlocks
Message-ID: <20140810143900.GB27670@merlins.org>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com> <2242759.aOKEuU2TTR@xev> <20140809143206.GJ11855@bitfolk.com> <CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com> <CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com> <pan$29b1$ee1dac$e6091513$d07b2702@cox.net> <20140809182113.GI12778@merlins.org> <pan.2014.08.10.12.43.31@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <pan.2014.08.10.12.43.31@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 10, 2014 at 12:43:31PM +0000, Holger Hoffstätte wrote:
> On Sat, 09 Aug 2014 11:21:13 -0700, Marc MERLIN wrote:
> 
> > I sure hope that deadlock patch is going to be added to the 3.16.x tree,
> > I'm not super stocked with being stuck at 3.14.
> 
> Let me try to re-stoke your enthusiasm a bit :)
> 
> If you are comfortable with patching your own kernel you can take
> a look at my custom patch queue, which I just put up at:
> https://github.com/hhoffstaette/kernel-patches/tree/master/3.14
> You can take only what you need, i.e. btrfs-*.
> 
> These are meant to be ironed over latest stable in order. and mostly
> address "corner cases" that seem to happen infrequently, but still
> are bad enough to leave a bad taste.
> 
> Unfortunately the btrfs code has changed significantly with 3.15+,
> so later patches often no longer apply at all. However the ones that do
> have been working well for me. I don't just blindly add them, but rather
> at least try to understand what they do/change.
> 
> I sent out an email for comments about backporting this select set of
> patches to 3.14, but got no replies. :(

My apologies if I missed some Emails, but I'm a bit confused.
The deadlocks happen reliably with 3.15+, but those patches are marked as
being for 3.14 in your URL, but then you say you didn't backport them to
3.14.

You lost me :)

That said, if you'd like to me try a set of patches that applies to
3.15.latest or 3.16 to see if they stop my frequent btrfs deadlocks, I'd be
happy to.
If the patches are meant for 3.14, that's not very helpful since 3.14 is
reasonably stable for me in comparison.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
