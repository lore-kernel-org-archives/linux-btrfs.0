Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:43411 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752134AbdDMBPO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 21:15:14 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cyTLl-0003D5-7p
        for linux-btrfs@vger.kernel.org; Thu, 13 Apr 2017 03:15:05 +0200
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Jakob_Sch=c3=bcrz?= <wertstoffe@nurfuerspam.de>
Subject: Re: send snapshot from snapshot incremental
Date: Thu, 13 Apr 2017 03:14:21 +0200
Message-ID: <d003sd-127.ln1@aldebaran.xundeenergie.at>
References: <p18jqd-a0m.ln1@aldebaran.xundeenergie.at>
 <22744.8089.282234.241186@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <22744.8089.282234.241186@tree.ty.sabi.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 2017-03-26 um 22:07 schrieb Peter Grandi:
> [ ... ]
>> BUT if i take a snapshot from the system, and want to transfer
>> it to the external HD, i can not set a parent subvolume,
>> because there isn't any.
> 
> Questions like this are based on incomplete understanding of
> 'send' and 'receive', and on IRC user "darkling" explained it
> fairly well:
> 
>> When you use -c, you're telling the FS that it can expect to
>> find a sent copy of that subvol on the receiving side, and
>> that anything shared with it can be sent by reference. OK, so
>> with -c on its own, you're telling the FS that "all the data
>> in this subvol already exists on the remote".
> 
>> So, when you send your subvol, *all* of the subvol's metadata
>> is sent, and where that metadata refers to an extent that's
>> shared with the -c subvol, the extent data isn't sent, because
>> it's known to be on the other end already, and can be shared
>> directly from there.
> 
>> OK. So, with -p, there's a "base" subvol. The send subvol and
>> the -p reference subvol are both snapshots of that base (at
>> different times). The -p reference subvol, as with -c, is
>> assumed to be on the remote FS. However, because it's known to
>> be an earlier version of the same data, you can be more
>> efficient in the sending by saying "start from the earlier
>> version, and modify it in this way to get the new version"
> 
>> So, with -p, not all of the metadata is sent, because you know
>> you've already got most of it on the remote in the form of the
>> earlier version.
> 
>> So -p is "take this thing and apply these differences to it"
>> and -c is "build this thing from scratch, but you can share
>> some of the data with these sources"
> 

For now, I think i got it... (maybe).

I put the following logic into my script:
1) Search for all Subvolumes on local and remote side, where the
Received-UUID on the remote side is the same as the UUID on the local side
2) Take the parent-UUID from the Snapshot i want to transfer and search
in the list from 1) which snapshot (from the local side) has the same
parent UUID.
3) Take the younges Snapshot from 2) ans set it as parent for the btrfs
send-command
4) Search for snapshot local and remote, wich have the same name|path
ans "basename" as the snapshot i want to transfer
	basename means, my system-subvolume is called @debian
	it contains one subvolume @debian/var/spool
	the snapshotnames are @debian_$TIMESTAMP and
	@debian_$TIMESTAMP/var/spool
	The basename is @debian and @debian/var/spool
5) set all of the snapshots with the same basename as the snapshot to be
transferred as clones for btrfs send.

The final command involves the youngest "sister" from the snapshot i
want to transfer, which is on both sides, set as "parent", and a bunch
of snapshots wich are older (or even younger - is this a problem???)
than the snapshot i want to transfer wich contain modified and the same
data, set as clones

If there is no parent (In case of transferring a snapshot of a
snapshot...) then there are clones of this snapshot, so not all of the
data is to be sent again (and consumes the double space on the backup-media)
If there are no parents AND clones (similar snapshots), the subvolume
seems to be totally new, and the whole must be transferred.
If there is a parent and clones, both of them are used to minimize the
data for the transfer, and use as much as possible from the existing
data/metadata on the backup-media to build the new snapshot there

To use all of the similar snapshots (get by the snapshotname) as clones
seems to fasten the transfer in comparison to only use the parent (this
seems slower). Could this be, or is this only a "feeling?

Thanks for all your advices. This helped me a lot!!

regards Jakob

