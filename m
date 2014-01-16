Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55088 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaAPMTY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 07:19:24 -0500
Date: Thu, 16 Jan 2014 04:19:06 -0800
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: btrfsck failes
Message-ID: <20140116121906.GP10639@merlins.org>
References: <CAFP7zVthUK54N5-8+QRABBpz2R9-mAbJGjiOc6Ty3nVS4O-EDA@mail.gmail.com>
 <A76390BF-4D85-47D3-A332-AD09809F6632@colorremedies.com>
 <CAKcLGm-Km3svoJ4oPGUdv8Wh__qsNAjujVmhF=46dwQP4HaeNw@mail.gmail.com>
 <5A3CA53B-B359-4DE0-A31B-49F98A1EBF7C@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A3CA53B-B359-4DE0-A31B-49F98A1EBF7C@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 15, 2014 at 10:16:13AM -0700, Chris Murphy wrote:
> 
> On Jan 15, 2014, at 9:15 AM, Mitch Harder <mitch.harder@sabayonlinux.org> wrote:
> 
> > On Mon, Jan 13, 2014 at 6:37 PM, Chris Murphy <lists@colorremedies.com> wrote:
> >> 
> >> On Jan 13, 2014, at 3:58 PM, Holger Brandsmeier <brandsmeier@gmail.com> wrote:
> >>> 
> >>> Currently btrfsck failes to repair my partition, I get the output:
> >>> 
> >>> [root@ho-think bholger]# btrfsck --repair /dev/sda5
> >> 
> >> This is almost the last resort and you probably should be posting to the list before using repair.
> >> 
> >> 
> > 
> > This is like saying:
> > 
> > "Yes, btrfs does now have a working btrfsck, but only for the select
> > few who manage to get through on the mailing list for support."
> > 
> > I'd like to think that's not the case.
> 
> Yet that's exactly what the wiki suggests: "If you have a broken filesystem, it is probably better to use btrfsck with advice from one of the btrfs developers, just in case something goes wrong. (But even if it does go badly wrong, you've still got your backups, right?)"
> 
> I think it's understandably annoying that the repair tool could make things worse rather than fail gracefully, because restoring from backups is tedious. But the only way it gets better is if people break both the file system and the repair tools in ways the devs can't possibly predict. 

I hate to be a broken record :) but telling people they should read/have
read a wiki when they are in the middle of fixing a filesystem is not
the right way to go.
On my laptop while travelling, it would even be my only way to boot and
maybe I can't get to the internet until my FS is fixed (maybe, maybe
not, but you get the idea).

My main point again (sorry) is still that the man page and usage info of btrfsck
should really warn users "this is likely NOT what you want to run,
please read the manpage, or HOWTO in /usr/share/doc/ with details about
mount recovery and other things to try first".

Think of it as a good thing, it means more btrfs users, and they are
used to working a certain way. It's for btrfs to adapt to how they're
used to working when possible.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
