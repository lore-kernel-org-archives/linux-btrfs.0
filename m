Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55338 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933566AbeF2QY2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 12:24:28 -0400
Date: Fri, 29 Jun 2018 09:24:20 -0700
From: Marc MERLIN <marc@merlins.org>
To: Lionel Bouton <lionel-subscription@bouton.name>
Cc: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Message-ID: <20180629162420.xszjxquo7gtrwtxz@merlins.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
 <20180629060657.qrtcxfcy22zkstfw@merlins.org>
 <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
 <20180629065903.xgwpvaa2vuiys75r@merlins.org>
 <20180629120954.4bbcd174@natsu>
 <20180629072210.nxvtwbokblol7xcb@merlins.org>
 <f693b8c8-1b3c-4847-b5f5-3990e3b8389a@bouton.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f693b8c8-1b3c-4847-b5f5-3990e3b8389a@bouton.name>
Subject: Re: btrfs send/receive vs rsync
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 10:04:02AM +0200, Lionel Bouton wrote:
> Hi,
> 
> On 29/06/2018 09:22, Marc MERLIN wrote:
> > On Fri, Jun 29, 2018 at 12:09:54PM +0500, Roman Mamedov wrote:
> >> On Thu, 28 Jun 2018 23:59:03 -0700
> >> Marc MERLIN <marc@merlins.org> wrote:
> >>
> >>> I don't waste a week recreating the many btrfs send/receive relationships.
> >> Consider not using send/receive, and switching to regular rsync instead.
> >> Send/receive is very limiting and cumbersome, including because of what you
> >> described. And it doesn't gain you much over an incremental rsync. As for
> > Err, sorry but I cannot agree with you here, at all :)
> >
> > btrfs send/receive is pretty much the only reason I use btrfs. 
> > rsync takes hours on big filesystems scanning every single inode on both
> > sides and then seeing what changed, and only then sends the differences
> > It's super inefficient.
> > btrfs send knows in seconds what needs to be sent, and works on it right
> > away.
> 
> I've not yet tried send/receive but I feel the pain of rsyncing millions
> of files (I had to use lsyncd to limit the problem to the time the
> origin servers reboot which is a relatively rare event) so this thread
> picked my attention. Looking at the whole thread I wonder if you could
> get a more manageable solution by splitting the filesystem.

So, let's be clear. I did backups with rsync for 10+ years. It was slow
and painful. On my laptop an hourly rsync between 2 drives slowed down
my machine to a crawl while everything was being stat'ed, it took
forever.
Now with btrfs send/receive, it just works, I don't even see it
happening in the background.

Here is a page I wrote about it in 2014:
http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Tips_-Doing-Fast-Incremental-Backups-With-Btrfs-Send-and-Receive

Here is a talk I gave in 2014 too, scroll to the bottom of the page, and
the bottom of the talk outline:
http://marc.merlins.org/perso/btrfs/2014-05.html#My-Btrfs-Talk-at-Linuxcon-JP-2014
and click on 'Btrfs send/receive'

> If instead of using a single BTRFS filesystem you used LVM volumes
> (maybe with Thin provisioning and monitoring of the volume group free
> space) for each of your servers to backup with one BTRFS filesystem per
> volume you would have less snapshots per filesystem and isolate problems
> in case of corruption. If you eventually decide to start from scratch
> again this might help a lot in your case.

So, I already have problems due to too many block layers:
- raid 5 + ssd
- bcache
- dmcrypt
- btrfs

I get occasional deadlocks due to upper layers sending more data to the
lower layer (bcache) than it can process. I'm a bit warry of adding yet
another layer (LVM), but you're otherwise correct than keeping smaller
btrfs filesystems would help with performance and containing possible
damage.

Has anyone actually done this? :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
