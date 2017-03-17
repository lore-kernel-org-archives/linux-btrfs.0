Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:37206 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750926AbdCQKO6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 06:14:58 -0400
Subject: Re: help : "bad tree block start" -> btrfs forced readonly
To: Roman Mamedov <rm@romanrm.net>
References: <0ec911af-2932-72df-d9b3-bd27616e101e@bouton.name>
 <c704f24e-4ea2-43fe-909e-92ad98bf6d28@bouton.name>
 <4866fa5d-d9bc-653a-17d8-b555fc55491e@mendix.com>
 <2994d13d-c65c-0794-8a83-a68ff258f109@bouton.name>
 <20170317145107.21bb9b45@natsu>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <74575358-1fee-404d-51e4-6fb51348c10f@bouton.name>
Date: Fri, 17 Mar 2017 11:03:23 +0100
MIME-Version: 1.0
In-Reply-To: <20170317145107.21bb9b45@natsu>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 17/03/2017 à 10:51, Roman Mamedov a écrit :
> On Fri, 17 Mar 2017 10:27:11 +0100
> Lionel Bouton <lionel-subscription@bouton.name> wrote:
>
>> Hi,
>>
>> Le 17/03/2017 à 09:43, Hans van Kranenburg a écrit :
>>> btrfs-debug-tree -b 3415463870464
>> Here is what it gives me back :
>>
>> btrfs-debug-tree -b 3415463870464 /dev/sdb
>> btrfs-progs v4.6.1
>> checksum verify failed on 3415463870464 found A85405B7 wanted 01010101
>> checksum verify failed on 3415463870464 found A85405B7 wanted 01010101
>> bytenr mismatch, want=3415463870464, have=72340172838076673
>> ERROR: failed to read 3415463870464
>>
>> Is there a way to remove part of the tree and keep the rest ? It could
>> help minimize the time needed to restore data.
> If you are able to experiment with writable snapshots, you could try using
> "btrfs-corrupt-block" to kill the bad block, and see what btrfsck makes out of
> the rest. In a similar case I got little to no damage to the overall FS.
> http://www.spinics.net/lists/linux-btrfs/msg53061.html
>
I've launched btrfs check in read-only mode :

btrfs check -p /dev/sdb
Checking filesystem on /dev/sdb
UUID: dbbde1f0-d8a0-4c7c-a7b8-17237e98e525
checksum verify failed on 3415463755776 found A85405B7 wanted 01010101
checksum verify failed on 3415463755776 found A85405B7 wanted 01010101
bytenr mismatch, want=3415463755776, have=72340172838076673
checksum verify failed on 3415464001536 found A85405B7 wanted 01010101
checksum verify failed on 3415464001536 found A85405B7 wanted 01010101
bytenr mismatch, want=3415464001536, have=72340172838076673
checksum verify failed on 3415464640512 found A85405B7 wanted 01010101
checksum verify failed on 3415464640512 found A85405B7 wanted 01010101
bytenr mismatch, want=3415464640512, have=72340172838076673

This goes on for pages... I probably missed some output and then there
are lots of errors like this one :

ref mismatch on [3415470456832 16384] extent item 1, found 0
Backref 3415470456832 root 3420 not referenced back 0x268013d0
Incorrect global backref count on 3415470456832 found 1 wanted 0
backpointer mismatch on [3415470456832 16384]
owner ref check failed [3415470456832 16384]

...

Followed by lots of this :

ref mismatch on [11010388205568 278528] extent item 1, found 0
checksum verify failed on 3415464869888 found A85405B7 wanted 01010101
checksum verify failed on 3415464869888 found A85405B7 wanted 01010101
bytenr mismatch, want=3415464869888, have=72340172838076673
Incorrect local backref count on 11010388205568 root 257 owner 7487206
offset 0 found 0 wanted 1 back 0x72335670
Backref disk bytenr does not match extent record, bytenr=11010388205568,
ref bytenr=0
backpointer mismatch on [11010388205568 278528]
owner ref check failed [11010388205568 278528]

...

I stopped there : am I correct in thinking that it will take ages to try
to salvage this without any guarantee that I'll get a substantial amount
of the 10 million files on this filesystem ?

I'm considering trying to use a 4 week old snapshot of the device to
find out if it was corrupted or not instead. It will still be a pain if
it works but rsync for less than a month of data is at least an order of
magnitude faster than a full restore.

Lionel
