Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout08.t-online.de ([194.25.134.20]:37902 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606Ab3KFAJ1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 19:09:27 -0500
Date: Wed, 6 Nov 2013 01:08:32 +0100
From: "Matthias G. Eckermann" <matthias.g.eckermann@t-online.de>
To: Marc MERLIN <marc@merlins.org>, David Madden <dhm@mersenne.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: OK to take hourly snapshots, then cull older ones?
Message-ID: <20131106000832.GA25578@t-online.de>
Reply-To: "Matthias G. Eckermann" <matthias.g.eckermann@t-online.de>
References: <525CBF0D.1020609@mersenne.com>
 <20131103115024.GA5139@t-online.de>
 <20131105025111.GG20447@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20131105025111.GG20447@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Marc and all,

On Mon, Nov 04, 2013 at 06:51:11PM -0800 Marc MERLIN wrote:
> On Sun, Nov 03, 2013 at 12:50PM +0100, Matthias G. Eckermann wrote:
> > On Mon, Oct 14, 2013 at 21:05 David Madden wrote:
> > 
> > > I'd like to use BTRFS to do something like the old NetApp
> > > snapshot system: every hour or so, there'd be a snapshot,
> > > then the 23 of the snapshots during a day would be
> > > deleted, leaving just a day snapshot, then after a month,
> > > 6 of 7 snapshots would be deleted, leaving just a week
> > > snapshot, and so on.
> > 
> > This is implemented in "Snapper", see:
> > 	http://snapper.io/
> > It's by default delivered with openSUSE and SUSE Linux
> > Enterprise, binaries are available for "everything else"
> > as well.
> 
> Just curious, what does it do more than the 20 line shellscript I
> posted?
> http://marc.merlins.org/linux/scripts/btrfs_snaps

You asked ... 

Snapper does not only handle snapshotting itself, but a
lot of steps around it, to make it easier for an
administrator to handle snapshotting.

While primarily offering a cmdline utility, Snapper also
has integration into D-BUS, thus other tools can ask for
snapshots on a specific subvolume.  To make this secure,
access rights are stored in a per subvolume configuration
among other attributes and rules.

Based on that Snapper offers (rough summary):

- Managing configurations (create, delete, list, ...)
- Managing snapshots (create, delete, list)
- Add and modify metadata of snapshots
- Compare snapshots aka "diff"
- Roll-back snapshots (selective roll-back, per file)

Within the configuration you can add
- rules for creation and removal of snapshots
- access rights

Off-Topic: Snapper also works with DM based snapshots.

Other projects using snapper:

* Samba 4 has a prototype implementation of Windows'
  FSRVP server for SMB share shadow-copies ("snapshots") 
  using Snapper via D-Bus. See: 
  http://snapper.io/videos.html

* The Systems Management stack of openSUSE / SUSE 
  Linux Enterprise (ZYpp, YaST) uses Snapper
  automatically, if "/" is on btrfs.

<SelfAdulation>

One also can use it for regular snapshots to the $HOME
directory; see my description here:
https://www.suse.com/communities/conversations/menu-du-jour-vivaneau-vert-sur-lit-de-legumes-au-beurre-et-supremes-de-pamplemousse-2/
and here
https://www.suse.com/communities/conversations/sieste-siesta/

</SelfAdulation>

Hope this explains.

so long -
	MgE

-- 
Matthias G. Eckermann, Berlin, Germany
Private : matthias.g.eckermann@t-online.de
Business: mge@suse.com

