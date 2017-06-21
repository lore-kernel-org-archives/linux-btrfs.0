Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:34378 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750986AbdFUXWR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 19:22:17 -0400
Received: by mail-wr0-f175.google.com with SMTP id 77so313450wrb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 16:22:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170621151339.GK5303@merlins.org>
References: <20170620143916.GA22987@merlins.org> <20170620152354.GD7140@carfax.org.uk>
 <20170620152648.GB22987@merlins.org> <20170620153601.GE7140@carfax.org.uk>
 <20170620154429.GC22987@merlins.org> <20170620231202.GB5303@merlins.org>
 <CAJCQCtQMWKJwWjeM4zEb-W7-tjsZyfCo37YyT2xYi0fNTEzcUQ@mail.gmail.com>
 <20170621034352.GE5303@merlins.org> <20170621151339.GK5303@merlins.org>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 21 Jun 2017 17:22:15 -0600
Message-ID: <CAJCQCtT0M77onJ=XnnQi9H9Ty_h6v009GhDK5NSTevHh5jFZbA@mail.gmail.com>
Subject: Re: How to fix errors that check --mode lomem finds, but --mode
 normal doesn't?
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 21, 2017 at 9:13 AM, Marc MERLIN <marc@merlins.org> wrote:
> On Tue, Jun 20, 2017 at 08:43:52PM -0700, Marc MERLIN wrote:
>> On Tue, Jun 20, 2017 at 09:31:42PM -0600, Chris Murphy wrote:
>> > On Tue, Jun 20, 2017 at 5:12 PM, Marc MERLIN <marc@merlins.org> wrote:
>> >
>> > > I'm now going to remount this with nospace_cache to see if your guess about
>> > > space_cache was correct.
>> > > Other suggestions also welcome :)
>> >
>> > What results do you get with lowmem mode? It won't repair without
>> > additional patches, but might give a dev a clue what's going on. I
>> > regularly see normal mode check finds no problems, and lowmem mode
>> > finds problems. Lowmem mode is a total rewrite so it's a different
>> > implementation and can find things normal mode won't.
>>
>> Oh, I kind of forgot that lowmem mode looked for more things than regular
>> mode.
>> I will run this tonight and see what it says.
>
> It's probably still a ways from being finished given how slow lowmem is in
> comparison, but sadly it found a bunch of problems which regular mode didn't
> find.
>
> I'm pretty bummed. I just spent way too long recreating this filesystem and
> the multiple btrfs send/receive relationships from other machines. Too a bit
> over a week :(
>
> It looks like the errors are not major (especially if the regular mode
> doesn't even see them), but without lowmem --repair, I'm kind of screwed.
>
> I'm wondering if I could/should leave those errors unfixed until lowmem --repair
> finally happens, or whether I'm looking at spending another week rebuilding
> this filesystem :-/
>
>
> gargamel:~# btrfs check -p --mode lowmem  /dev/mapper/dshelf2
> Checking filesystem on /dev/mapper/dshelf2
> UUID: 85441c59-ad11-4b25-b1fe-974f9e4acede
> ERROR: extent[3886187384832, 81920] referencer count mismatch (root: 11930, owner: 375444, offset: 1851654144) wanted: 1, have: 4
> ERROR: extent[3886189391872, 122880] referencer count mismatch (root: 11712, owner: 863395, offset: 79659008) wanted: 1, have: 2
> ERROR: extent[3933249708032, 69632] referencer count mismatch (root: 12424, owner: 6945, offset: 2083389440) wanted: 1, have: 2
> ERROR: extent[3933249708032, 69632] referencer count mismatch (root: 12172, owner: 6945, offset: 2083389440) wanted: 1, have: 2
> ERROR: extent[4571729862656, 876544] referencer count mismatch (root: 11058, owner: 375442, offset: 907706368) wanted: 6, have: 21
> ERROR: extent[4641490833408, 270336] referencer count mismatch (root: 11712, owner: 375444, offset: 1848672256) wanted: 3, have: 5
> ERROR: extent[4641490833408, 270336] referencer count mismatch (root: 11276, owner: 375444, offset: 1848672256) wanted: 3, have: 5
> ERROR: extent[4641490833408, 270336] referencer count mismatch (root: 11058, owner: 375444, offset: 1848672256) wanted: 3, have: 5
> ERROR: extent[4641490833408, 270336] referencer count mismatch (root: 11494, owner: 375444, offset: 1848672256) wanted: 3, have: 5
> ERROR: extent[4658555617280, 122880] referencer count mismatch (root: 11712, owner: 375444, offset: 1848705024) wanted: 1, have: 3
> ERROR: extent[4677858123776, 417792] referencer count mismatch (root: 11712, owner: 863395, offset: 79523840) wanted: 1, have: 3
> ERROR: extent[4677858123776, 417792] referencer count mismatch (root: 11930, owner: 863395, offset: 79523840) wanted: 1, have: 3
> ERROR: extent[4698380947456, 409600] referencer count mismatch (root: 11930, owner: 375444, offset: 1851596800) wanted: 3, have: 4
> ERROR: extent[4720470421504, 667648] referencer count mismatch (root: 11058, owner: 3463478, offset: 2334720) wanted: 2, have: 10
> ERROR: extent[4783941246976, 65536] referencer count mismatch (root: 9365, owner: 24493, offset: 4562944) wanted: 2, have: 3
> ERROR: extent[5077564477440, 106496] referencer count mismatch (root: 9370, owner: 1602694, offset: 734756864) wanted: 1, have: 2
> ERROR: extent[5136306929664, 131489792] referencer count mismatch (root: 11712, owner: 375441, offset: 910999552) wanted: 16, have: 1864
> ERROR: extent[5136306929664, 131489792] referencer count mismatch (root: 11276, owner: 375441, offset: 910999552) wanted: 867, have: 1865
> ERROR: extent[5136306929664, 131489792] referencer count mismatch (root: 11058, owner: 375441, offset: 910999552) wanted: 126, have: 1872
> ERROR: extent[5136306929664, 131489792] referencer count mismatch (root: 11494, owner: 375441, offset: 910999552) wanted: 866, have: 1864
> ERROR: extent[5136306929664, 131489792] referencer count mismatch (root: 11930, owner: 375441, offset: 910999552) wanted: 861, have: 1859
> ERROR: extent[5136649891840, 66781184] referencer count mismatch (root: 11058, owner: 375442, offset: 192659456) wanted: 5, have: 19
> ERROR: extent[5136879157248, 134217728] referencer count mismatch (root: 11930, owner: 375442, offset: 394543104) wanted: 10, have: 33
> ERROR: extent[5137380671488, 80945152] referencer count mismatch (root: 11058, owner: 375442, offset: 875233280) wanted: 1, have: 21
> ERROR: extent[5137380671488, 80945152] referencer count mismatch (root: 11930, owner: 375442, offset: 875233280) wanted: 11, have: 21
> ERROR: extent[5138641395712, 524288] referencer count mismatch (root: 11494, owner: 375445, offset: 39845888) wanted: 1, have: 3
> ERROR: extent[5190245990400, 53248] referencer count mismatch (root: 11712, owner: 863395, offset: 51118080) wanted: 1, have: 4
> ERROR: extent[5190245990400, 53248] referencer count mismatch (root: 11276, owner: 863395, offset: 51118080) wanted: 1, have: 4
> ERROR: extent[5190245990400, 53248] referencer count mismatch (root: 11494, owner: 863395, offset: 51118080) wanted: 1, have: 4
> ERROR: extent[5190274174976, 77824] referencer count mismatch (root: 11276, owner: 863395, offset: 74952704) wanted: 3, have: 5
> ERROR: extent[5190274174976, 77824] referencer count mismatch (root: 11058, owner: 863395, offset: 74952704) wanted: 3, have: 5
> ERROR: extent[5190274174976, 77824] referencer count mismatch (root: 11494, owner: 863395, offset: 74952704) wanted: 3, have: 5
> ERROR: extent[5190274174976, 77824] referencer count mismatch (root: 11930, owner: 863395, offset: 74952704) wanted: 3, have: 5
> ERROR: extent[5190275895296, 77824] referencer count mismatch (root: 11712, owner: 863395, offset: 77705216) wanted: 1, have: 6
> ERROR: extent[5190275895296, 77824] referencer count mismatch (root: 11276, owner: 863395, offset: 77705216) wanted: 5, have: 6
> ERROR: extent[5190275895296, 77824] referencer count mismatch (root: 11058, owner: 863395, offset: 77705216) wanted: 5, have: 6
> ERROR: extent[5427326599168, 61440] referencer count mismatch (root: 9370, owner: 1225712, offset: 29753344) wanted: 1, have: 5
> ERROR: extent[5456623030272, 24576] referencer count mismatch (root: 11058, owner: 2278892, offset: 786432) wanted: 2, have: 3
> ERROR: extent[5851251269632, 134217728] referencer count mismatch (root: 9370, owner: 1602695, offset: 534061056) wanted: 3, have: 4
> ERROR: errors found in extent allocation tree or chunk allocation
> cache and super generation don't match, space cache will be invalidated
> ERROR: root 3857 EXTENT_DATA[108864 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[133050 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[388570 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[729583 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[984778 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[997394 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1002954 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1007491 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1111463 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1111506 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1111536 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1111536 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1134500 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1136498 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1175965 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1185977 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1190919 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1201340 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1230370 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1230530 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1230530 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1235960 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1248784 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1271827 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1295242 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1406074 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1410780 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1412938 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1413532 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1413532 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1421245 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1423365 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1425985 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1429229 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1430615 4096] interrupt
> ERROR: root 3857 EXTENT_DATA[1443769 4096] interrupt
> ERROR: root 3860 EXTENT_DATA[599089 4096] interrupt
>
> (not finished, still going on)


I don't know what it means. Maybe Qu has some idea. He might want a
btrfs-image  of this file system to see if it's a bug. There are still
some bugs found with lowmem mode, so these could be bogus messages.
But the file system clearly has problems, the question is why does
such a new file system have these kinds of problems that can't be
fixed by normal repair because they aren't even being detected; or
maybe there is no problem on disk per se, the problem might be a bug.

In which case, off chance going back to a substantially older kernel
might help. Maybe the latest 4.9 series kernel?

-- 
Chris Murphy
