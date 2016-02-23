Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:54248 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbcBWSBy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 13:01:54 -0500
Subject: Re: Major HDD performance degradation on btrfs receive
To: Marc MERLIN <marc@merlins.org>, Duncan <1i5t5.duncan@cox.net>,
        Nazar Mokrynskyi <nazar@mokrynskyi.com>,
        Alexander Fougner <fougner89@gmail.com>
References: <CAGGqMYS=O=zzZE2pK=Stx6OwrZn1Fz59oYBS+jbSHfu4Ovv68Q@mail.gmail.com>
 <04df0eaf-9dc8-b9fa-05cb-020507940bed@mokrynskyi.com>
 <pan$9ab32$bee891f3$832766e9$6d69ce8@cox.net>
 <20160223172635.GI22487@merlins.org> <20160223173444.GJ22487@merlins.org>
Cc: linux-btrfs@vger.kernel.org
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <56CC9E90.30509@bouton.name>
Date: Tue, 23 Feb 2016 19:01:52 +0100
MIME-Version: 1.0
In-Reply-To: <20160223173444.GJ22487@merlins.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 23/02/2016 18:34, Marc MERLIN a écrit :
> On Tue, Feb 23, 2016 at 09:26:35AM -0800, Marc MERLIN wrote:
>> Label: 'dshelf2'  uuid: d4a51178-c1e6-4219-95ab-5c5864695bfd
>>         Total devices 1 FS bytes used 4.25TiB
>>         devid    1 size 7.28TiB used 4.44TiB path /dev/mapper/dshelf2
>>
>> btrfs fi df /mnt/btrfs_pool2/
>> Data, single: total=4.29TiB, used=4.18TiB
>> System, DUP: total=64.00MiB, used=512.00KiB
>> Metadata, DUP: total=77.50GiB, used=73.31GiB
>> GlobalReserve, single: total=512.00MiB, used=31.22MiB
>>
>> Currently, it's btrfs on top of dmcrpyt on top of swraid5
> Sorry, I forgot to give the mount options:
> /dev/mapper/dshelf2 on /mnt/dshelf2/backup type btrfs (rw,noatime,compress=lzo,space_cache,skip_balance,subvolid=257,subvol=/backup)

Why don't you use autodefrag ? If you have writable snapshots and do
write to them heavily it would not be a good idea (depending on how
BTRFS handles this in most cases you would probably either break the
reflinks or fragment a snapshot to defragment another) but if you only
have read-only snapshots it may work for you (it does for me).

The only BTRFS filesystems where I disabled autodefrag where Ceph OSDs
with heavy in-place updates. Another option would have been to mark
files NoCoW but I didn't want to abandon BTRFS checksumming.

Lionel
