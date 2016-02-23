Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:51163 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213AbcBWUfd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 15:35:33 -0500
Subject: Re: Major HDD performance degradation on btrfs receive
To: Marc MERLIN <marc@merlins.org>
References: <CAGGqMYS=O=zzZE2pK=Stx6OwrZn1Fz59oYBS+jbSHfu4Ovv68Q@mail.gmail.com>
 <04df0eaf-9dc8-b9fa-05cb-020507940bed@mokrynskyi.com>
 <pan$9ab32$bee891f3$832766e9$6d69ce8@cox.net>
 <20160223172635.GI22487@merlins.org> <20160223173444.GJ22487@merlins.org>
 <56CC9E90.30509@bouton.name> <20160223183021.GM22487@merlins.org>
Cc: Duncan <1i5t5.duncan@cox.net>, Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        Alexander Fougner <fougner89@gmail.com>, linux-btrfs@vger.kernel.org
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <56CCC292.1070306@bouton.name>
Date: Tue, 23 Feb 2016 21:35:30 +0100
MIME-Version: 1.0
In-Reply-To: <20160223183021.GM22487@merlins.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 23/02/2016 19:30, Marc MERLIN a écrit :
> On Tue, Feb 23, 2016 at 07:01:52PM +0100, Lionel Bouton wrote:
>> Why don't you use autodefrag ? If you have writable snapshots and do
>> write to them heavily it would not be a good idea (depending on how
>> BTRFS handles this in most cases you would probably either break the
>> reflinks or fragment a snapshot to defragment another) but if you only
>> have read-only snapshots it may work for you (it does for me).
>  
> It's not a stupid question, I had issues with autodefrag in the past,
> and turned it off, but it's been a good 2 years, so maybe it works well
> enough now.
>
>> The only BTRFS filesystems where I disabled autodefrag where Ceph OSDs
>> with heavy in-place updates. Another option would have been to mark
>> files NoCoW but I didn't want to abandon BTRFS checksumming.
> Right. I don't have to worry about COW for virtualbox images there, and
> the snapshots are read only (well, my script makes read-write snapshots
> too, but I almost never use them. Hopefully their presence isn't a
> problem, right?)

I believe autodefrag is only triggering defragmentation on access (write
access only according to the wiki) and uses a queue of limited length
for defragmentation tasks to perform. So the snapshots by themselves
won't cause problems. Even if you access files the defragmentation
should be focused mainly on the versions of the files you access the
most. The real problems probably happen when you access the same file
from several snapshots with lots of internal modifications between the
versions in these snapshots: either autodefrag will break the reflinks
between them or it will attempt to optimize the 2 file versions at
roughly the same time which won't give any benefit but will waste I/O.

Lionel
