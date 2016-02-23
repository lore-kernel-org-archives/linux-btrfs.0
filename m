Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48756 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbcBWSac (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 13:30:32 -0500
Date: Tue, 23 Feb 2016 10:30:21 -0800
From: Marc MERLIN <marc@merlins.org>
To: Lionel Bouton <lionel-subscription@bouton.name>
Cc: Duncan <1i5t5.duncan@cox.net>, Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        Alexander Fougner <fougner89@gmail.com>, linux-btrfs@vger.kernel.org
Message-ID: <20160223183021.GM22487@merlins.org>
References: <CAGGqMYS=O=zzZE2pK=Stx6OwrZn1Fz59oYBS+jbSHfu4Ovv68Q@mail.gmail.com>
 <04df0eaf-9dc8-b9fa-05cb-020507940bed@mokrynskyi.com>
 <pan$9ab32$bee891f3$832766e9$6d69ce8@cox.net>
 <20160223172635.GI22487@merlins.org>
 <20160223173444.GJ22487@merlins.org>
 <56CC9E90.30509@bouton.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56CC9E90.30509@bouton.name>
Subject: Re: Major HDD performance degradation on btrfs receive
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 23, 2016 at 07:01:52PM +0100, Lionel Bouton wrote:
> Why don't you use autodefrag ? If you have writable snapshots and do
> write to them heavily it would not be a good idea (depending on how
> BTRFS handles this in most cases you would probably either break the
> reflinks or fragment a snapshot to defragment another) but if you only
> have read-only snapshots it may work for you (it does for me).
 
It's not a stupid question, I had issues with autodefrag in the past,
and turned it off, but it's been a good 2 years, so maybe it works well
enough now.

> The only BTRFS filesystems where I disabled autodefrag where Ceph OSDs
> with heavy in-place updates. Another option would have been to mark
> files NoCoW but I didn't want to abandon BTRFS checksumming.

Right. I don't have to worry about COW for virtualbox images there, and
the snapshots are read only (well, my script makes read-write snapshots
too, but I almost never use them. Hopefully their presence isn't a
problem, right?)

Thanks for the suggestion.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
