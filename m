From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Online device removal pushed to the unstable tree
Date: Wed, 14 May 2008 13:15:20 -0400
Message-ID: <200805141315.21117.chris.mason@oracle.com>
References: <200805131608.36386.chris.mason@oracle.com> <f058a9c30805140741o7d4c4e67l243f981d1b750cca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30805140741o7d4c4e67l243f981d1b750cca@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 14 May 2008, Miguel Sousa Filipe wrote:
> Hi all,
>
> On Tue, May 13, 2008 at 9:08 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > Hello everyone,
> >
> >  The unstable tree is still format compatible with v0.14, and it now
> > includes the ability to remove devices online.  In mirror configurations,
> > IO errors to one of the mirrors are also handled, although it doesn't
> > currently kick off a rebuild or other magic.
> >
> >  To try things out:
> >
> >  mkfs.btrfs -d raid1 -m raid1 /dev/sdb /dev/sdc
> >  mount /dev/sdb /mnt
> >  # put data on /mnt
> >  # then add /dev/sdd to the FS
> >  btrfs-vol -a /dev/sdd /mnt
> >
> >  At this point we've got a raid1 filesystem with data spread across sdb
> > and sdc.  If we remove /dev/sdc, all the existing data will be remirrored
> > onto sdd:
>
> Is there a way to check the progress of the remirror/rebuild ?
> (somewhat similar to what /proc/mdstat provides when a mirror is being
> synced)

Sorry, not yet.  Some information is printed to the console, but it is 
currently difficult to tell how far along the remirroring is.

The current code is definitely slower than it should be, I went for the most 
generic setup in hopes of stabilizing it quickly.

-chris
