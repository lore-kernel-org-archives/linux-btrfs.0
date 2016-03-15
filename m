Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:38176 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbcCOHUp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 03:20:45 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1afjHX-0000Ts-AN
	for linux-btrfs@vger.kernel.org; Tue, 15 Mar 2016 08:20:43 +0100
Date: Tue, 15 Mar 2016 08:20:43 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
Message-ID: <20160315072043.GM2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
 <20160305143934.GE1902@torres.zugschlus.de>
 <CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
 <20160313115809.GQ2334@torres.zugschlus.de>
 <CAPmG0jbUJ8rUM4ttk3MvDPMjAV=fxqwa93Ce0s6kOLQb=3qm=g@mail.gmail.com>
 <20160313205605.GV2334@torres.zugschlus.de>
 <CAPmG0jYJgwenu-9n5qi=S+f1D7xVQv=jRhwMAfoaeOjBkysM4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAPmG0jYJgwenu-9n5qi=S+f1D7xVQv=jRhwMAfoaeOjBkysM4w@mail.gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2016 at 01:00:13AM +0100, Henk Slager wrote:
> On Sun, Mar 13, 2016 at 9:56 PM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> > Yes, I want to keep the possibility to remove huge files from
> > snapshots that shouldnt have been on a snapshotted volume in the first
> > place without having to ditch the entire snapshot.
> 
> You could do ro snapshotting and in case you want to modify something
> inside a snapshot/subvolume:
> # btrfs property set <subvolume> ro false
> # rm <subvolume>/<somefile>
> # btrfs property set <subvolume> ro true

I was not aware that it is possible to fiddle with the ro property of
an already existing snapshot. I am not yet sure whether I love or hate
this.

> >> Also, If some part of the OS or tools scans through the snapshot dirs
> >> every now and then with atime creation on, metadata grows without a
> >> real need.
> >
> > I mount with noatime and nodiratime anyway, and the directory the
> > snapshots are mounted to (/mnt/snapshots) are excluded in
> > updatedb.conf. Any other idea which tool might scan filesystems and
> > that might not be noticed when it's running about a five digit number
> > of snapshots?
> 
> Maybe baloo or so if you use KDE.

I usually do those tests via ssh without even being logged in to a
local desktop.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
