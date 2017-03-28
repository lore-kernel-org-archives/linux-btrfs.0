Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:38247 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752679AbdC1WPh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 18:15:37 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cszOV-0001dN-9v
        for linux-btrfs@vger.kernel.org; Wed, 29 Mar 2017 00:15:15 +0200
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Jakob_Sch=c3=bcrz?= <wertstoffe@nurfuerspam.de>
Subject: Re: send snapshot from snapshot incremental
Date: Wed, 29 Mar 2017 00:01:55 +0200
Message-ID: <j33rqd-nkh.ln1@aldebaran.xundeenergie.at>
References: <p18jqd-a0m.ln1@aldebaran.xundeenergie.at>
 <22744.8089.282234.241186@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <22744.8089.282234.241186@tree.ty.sabi.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for that explanation.

I'm sure, i didn't understand the -c option... and my english is pretty
good enough for the most things I need to know in Linux-things... but
not for this. :-(

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
> Also here some additional details:
> 
>   http://logs.tvrrug.org.uk/logs/%23btrfs/2016-06-29.html#2016-06-29T22:39:59
> 
> The requirement for read-only is because in that way it is
> pretty sure that the same stuff is on both origin and target
> volume.
> 
> It may help to compare with RSYNC: it has to scan both the full
> origin and target trees, because it cannot be told that there is
> a parent tree that is the same on origin and target; but with
> option '--link-dest' it can do something similar to 'send -c'.

There is Subvolume A on the send- and the receive-side.
There is also Subvolume AA on the send-side from A.
The parent-ID from send-AA is the ID from A.
The received-ID from A on received-side A is the ID from A.

To send the AA, i use the command
btrfs send -p A AA|btrfs receive /path/to/receiveFS/

The received-ID from AA on received-side A is the ID from AA.


Now i take a snapshot from AA on the send-side -> Called AAA

If i try to send AAA to the receiving FS with
btrfs send -p AA AAA|btrfs receive /path/to/receiveFS/
no parent snapshot is found.
I should better take the -c Option.

btrfs send -c AA AAA|btrfs receive /path/to/receiveFS/

Am I right?
(Sorry, cannot test it now, i do not have my external Drive here)
I might remember, that this didn't work in the past...

Best regards

Jakob

