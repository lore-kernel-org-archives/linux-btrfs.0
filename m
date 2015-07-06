Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:32910 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbbGFXDI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 19:03:08 -0400
Received: by laar3 with SMTP id r3so174174943laa.0
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Jul 2015 16:03:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150706223404.GF7507@wotan.suse.de>
References: <CA+xOVSO2Cd1aYxAnA_Aq32oBTiMTbuo1YQo2cqEY_5WONQV=qA@mail.gmail.com>
	<20150706223404.GF7507@wotan.suse.de>
Date: Tue, 7 Jul 2015 02:03:06 +0300
Message-ID: <CA+xOVSNrX4yT=+0Xre8qpRrsA=+Nu0w5+fUa0oAbvXf0CFr35w@mail.gmail.com>
Subject: Re: running duperemove but no free space gain
From: Mordechay Kaganer <mkaganer@gmail.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.

On Tue, Jul 7, 2015 at 1:34 AM, Mark Fasheh <mfasheh@suse.de> wrote:
>>
>> It runs successfully for several hours and prints out many files which
>> are indeed duplicate like this:
>>
>> Showing 4 identical extents with id 5164bb47
>> Start           Length          Filename
>> 0.0     4.8M    "...."
>> 0.0     4.8M    "...."
>> 0.0     4.8M    "...."
>> 0.0     4.8M    "...."
>> ....skip...
>> [0x78dee80] Try to dedupe extents with id 5164bb47
>> [0x78dee80] Dedupe 3 extents (id: 5164bb47) with target: (0.0, 4.8M), "...."
>>
>> But the actual free space reported by "df" or by "btrfs fi df" doesn't
>> seem to change. Used space and metadata space even increases slightly.
>
> There were some patches for 4.2 which are both on the list and upstream that
> fix an issue where the unligned tail of extents wasn't being deduplicated.
> It sounds like you may have hit this. So we can tell, can you run the
> 'show-shared-extents' program that comes with duperemove (or 'filefrag -e')
> against two of the files that should have been deduped together and provide
> the output here. If most of the extent is showing deduped but there's a
> not-deduped tail extent then that's most likely what you're seeing.
>

# show-shared-extents <first_file> <second_file>
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
350771204096, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
350771318784, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 131072, fe_physical:
350771425280, fe_flags: 0x2008 (encoded shared )
(fiemap) [3] fe_logical: 393216, fe_length: 131072, fe_physical:
350771548160, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 524288, fe_length: 131072, fe_physical:
350771666944, fe_flags: 0x2008 (encoded shared )
(fiemap) [5] fe_logical: 655360, fe_length: 131072, fe_physical:
350771781632, fe_flags: 0x2008 (encoded shared )
(fiemap) [6] fe_logical: 786432, fe_length: 131072, fe_physical:
350771900416, fe_flags: 0x2008 (encoded shared )
(fiemap) [7] fe_logical: 917504, fe_length: 131072, fe_physical:
350772019200, fe_flags: 0x2008 (encoded shared )
(fiemap) [8] fe_logical: 1048576, fe_length: 131072, fe_physical:
350772137984, fe_flags: 0x2008 (encoded shared )
(fiemap) [9] fe_logical: 1179648, fe_length: 131072, fe_physical:
350772256768, fe_flags: 0x2008 (encoded shared )
(fiemap) [10] fe_logical: 1310720, fe_length: 131072, fe_physical:
350772375552, fe_flags: 0x2008 (encoded shared )
(fiemap) [11] fe_logical: 1441792, fe_length: 131072, fe_physical:
350772494336, fe_flags: 0x2008 (encoded shared )
(fiemap) [12] fe_logical: 1572864, fe_length: 131072, fe_physical:
350772617216, fe_flags: 0x2008 (encoded shared )
(fiemap) [13] fe_logical: 1703936, fe_length: 131072, fe_physical:
350772740096, fe_flags: 0x2008 (encoded shared )
(fiemap) [14] fe_logical: 1835008, fe_length: 131072, fe_physical:
350772854784, fe_flags: 0x2008 (encoded shared )
(fiemap) [15] fe_logical: 1966080, fe_length: 131072, fe_physical:
350772977664, fe_flags: 0x2008 (encoded shared )
(fiemap) [16] fe_logical: 2097152, fe_length: 131072, fe_physical:
350773100544, fe_flags: 0x2008 (encoded shared )
(fiemap) [17] fe_logical: 2228224, fe_length: 131072, fe_physical:
350773223424, fe_flags: 0x2008 (encoded shared )
(fiemap) [18] fe_logical: 2359296, fe_length: 131072, fe_physical:
350773342208, fe_flags: 0x2008 (encoded shared )
(fiemap) [19] fe_logical: 2490368, fe_length: 131072, fe_physical:
350773460992, fe_flags: 0x2008 (encoded shared )
(fiemap) [20] fe_logical: 2621440, fe_length: 131072, fe_physical:
350773579776, fe_flags: 0x2008 (encoded shared )
(fiemap) [21] fe_logical: 2752512, fe_length: 131072, fe_physical:
350773698560, fe_flags: 0x2008 (encoded shared )
(fiemap) [22] fe_logical: 2883584, fe_length: 131072, fe_physical:
350773821440, fe_flags: 0x2008 (encoded shared )
(fiemap) [23] fe_logical: 3014656, fe_length: 131072, fe_physical:
350773944320, fe_flags: 0x2008 (encoded shared )
(fiemap) [24] fe_logical: 3145728, fe_length: 131072, fe_physical:
350774067200, fe_flags: 0x2008 (encoded shared )
(fiemap) [25] fe_logical: 3276800, fe_length: 131072, fe_physical:
350774181888, fe_flags: 0x2008 (encoded shared )
(fiemap) [26] fe_logical: 3407872, fe_length: 131072, fe_physical:
350774300672, fe_flags: 0x2008 (encoded shared )
(fiemap) [27] fe_logical: 3538944, fe_length: 131072, fe_physical:
350774423552, fe_flags: 0x2008 (encoded shared )
(fiemap) [28] fe_logical: 3670016, fe_length: 131072, fe_physical:
350774546432, fe_flags: 0x2008 (encoded shared )
(fiemap) [29] fe_logical: 3801088, fe_length: 131072, fe_physical:
350774669312, fe_flags: 0x2008 (encoded shared )
(fiemap) [30] fe_logical: 3932160, fe_length: 131072, fe_physical:
350774792192, fe_flags: 0x2008 (encoded shared )
(fiemap) [31] fe_logical: 4063232, fe_length: 131072, fe_physical:
350774915072, fe_flags: 0x2008 (encoded shared )
(fiemap) [32] fe_logical: 4194304, fe_length: 131072, fe_physical:
350775037952, fe_flags: 0x2008 (encoded shared )
(fiemap) [33] fe_logical: 4325376, fe_length: 131072, fe_physical:
350775160832, fe_flags: 0x2008 (encoded shared )
(fiemap) [34] fe_logical: 4456448, fe_length: 131072, fe_physical:
350775279616, fe_flags: 0x2008 (encoded shared )
(fiemap) [35] fe_logical: 4587520, fe_length: 131072, fe_physical:
350775394304, fe_flags: 0x2008 (encoded shared )
(fiemap) [36] fe_logical: 4718592, fe_length: 131072, fe_physical:
350775517184, fe_flags: 0x2008 (encoded shared )
(fiemap) [37] fe_logical: 4849664, fe_length: 131072, fe_physical:
350775640064, fe_flags: 0x2008 (encoded shared )
(fiemap) [38] fe_logical: 4980736, fe_length: 61440, fe_physical:
350775758848, fe_flags: 0x2009 (last encoded shared )
<first_file>: 5042176 shared bytes
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
350771204096, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
350771318784, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 131072, fe_physical:
350771425280, fe_flags: 0x2008 (encoded shared )
(fiemap) [3] fe_logical: 393216, fe_length: 131072, fe_physical:
350771548160, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 524288, fe_length: 131072, fe_physical:
350771666944, fe_flags: 0x2008 (encoded shared )
(fiemap) [5] fe_logical: 655360, fe_length: 131072, fe_physical:
350771781632, fe_flags: 0x2008 (encoded shared )
(fiemap) [6] fe_logical: 786432, fe_length: 131072, fe_physical:
350771900416, fe_flags: 0x2008 (encoded shared )
(fiemap) [7] fe_logical: 917504, fe_length: 131072, fe_physical:
350772019200, fe_flags: 0x2008 (encoded shared )
(fiemap) [8] fe_logical: 1048576, fe_length: 131072, fe_physical:
350772137984, fe_flags: 0x2008 (encoded shared )
(fiemap) [9] fe_logical: 1179648, fe_length: 131072, fe_physical:
350772256768, fe_flags: 0x2008 (encoded shared )
(fiemap) [10] fe_logical: 1310720, fe_length: 131072, fe_physical:
350772375552, fe_flags: 0x2008 (encoded shared )
(fiemap) [11] fe_logical: 1441792, fe_length: 131072, fe_physical:
350772494336, fe_flags: 0x2008 (encoded shared )
(fiemap) [12] fe_logical: 1572864, fe_length: 131072, fe_physical:
350772617216, fe_flags: 0x2008 (encoded shared )
(fiemap) [13] fe_logical: 1703936, fe_length: 131072, fe_physical:
350772740096, fe_flags: 0x2008 (encoded shared )
(fiemap) [14] fe_logical: 1835008, fe_length: 131072, fe_physical:
350772854784, fe_flags: 0x2008 (encoded shared )
(fiemap) [15] fe_logical: 1966080, fe_length: 131072, fe_physical:
350772977664, fe_flags: 0x2008 (encoded shared )
(fiemap) [16] fe_logical: 2097152, fe_length: 131072, fe_physical:
350773100544, fe_flags: 0x2008 (encoded shared )
(fiemap) [17] fe_logical: 2228224, fe_length: 131072, fe_physical:
350773223424, fe_flags: 0x2008 (encoded shared )
(fiemap) [18] fe_logical: 2359296, fe_length: 131072, fe_physical:
350773342208, fe_flags: 0x2008 (encoded shared )
(fiemap) [19] fe_logical: 2490368, fe_length: 131072, fe_physical:
350773460992, fe_flags: 0x2008 (encoded shared )
(fiemap) [20] fe_logical: 2621440, fe_length: 131072, fe_physical:
350773579776, fe_flags: 0x2008 (encoded shared )
(fiemap) [21] fe_logical: 2752512, fe_length: 131072, fe_physical:
350773698560, fe_flags: 0x2008 (encoded shared )
(fiemap) [22] fe_logical: 2883584, fe_length: 131072, fe_physical:
350773821440, fe_flags: 0x2008 (encoded shared )
(fiemap) [23] fe_logical: 3014656, fe_length: 131072, fe_physical:
350773944320, fe_flags: 0x2008 (encoded shared )
(fiemap) [24] fe_logical: 3145728, fe_length: 131072, fe_physical:
350774067200, fe_flags: 0x2008 (encoded shared )
(fiemap) [25] fe_logical: 3276800, fe_length: 131072, fe_physical:
350774181888, fe_flags: 0x2008 (encoded shared )
(fiemap) [26] fe_logical: 3407872, fe_length: 131072, fe_physical:
350774300672, fe_flags: 0x2008 (encoded shared )
(fiemap) [27] fe_logical: 3538944, fe_length: 131072, fe_physical:
350774423552, fe_flags: 0x2008 (encoded shared )
(fiemap) [28] fe_logical: 3670016, fe_length: 131072, fe_physical:
350774546432, fe_flags: 0x2008 (encoded shared )
(fiemap) [29] fe_logical: 3801088, fe_length: 131072, fe_physical:
350774669312, fe_flags: 0x2008 (encoded shared )
(fiemap) [30] fe_logical: 3932160, fe_length: 131072, fe_physical:
350774792192, fe_flags: 0x2008 (encoded shared )
(fiemap) [31] fe_logical: 4063232, fe_length: 131072, fe_physical:
350774915072, fe_flags: 0x2008 (encoded shared )
(fiemap) [32] fe_logical: 4194304, fe_length: 131072, fe_physical:
350775037952, fe_flags: 0x2008 (encoded shared )
(fiemap) [33] fe_logical: 4325376, fe_length: 131072, fe_physical:
350775160832, fe_flags: 0x2008 (encoded shared )
(fiemap) [34] fe_logical: 4456448, fe_length: 131072, fe_physical:
350775279616, fe_flags: 0x2008 (encoded shared )
(fiemap) [35] fe_logical: 4587520, fe_length: 131072, fe_physical:
350775394304, fe_flags: 0x2008 (encoded shared )
(fiemap) [36] fe_logical: 4718592, fe_length: 131072, fe_physical:
350775517184, fe_flags: 0x2008 (encoded shared )
(fiemap) [37] fe_logical: 4849664, fe_length: 131072, fe_physical:
350775640064, fe_flags: 0x2008 (encoded shared )
(fiemap) [38] fe_logical: 4980736, fe_length: 57344, fe_physical:
350775758848, fe_flags: 0x2008 (encoded shared )
(fiemap) [39] fe_logical: 5038080, fe_length: 4096, fe_physical:
351184961536, fe_flags: 0x9 (last encoded )
<second_file>: 5038080 shared bytes

And another pair (all extents reported shared):

show-shared-extents  <first_file> <second_file>
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
3576952483840, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
3576952606720, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 262144, fe_physical:
3576952733696, fe_flags: 0x2000 (shared )
(fiemap) [3] fe_logical: 524288, fe_length: 131072, fe_physical:
3576952995840, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 655360, fe_length: 393216, fe_physical:
3576953122816, fe_flags: 0x2000 (shared )
(fiemap) [5] fe_logical: 1048576, fe_length: 131072, fe_physical:
3576953516032, fe_flags: 0x2008 (encoded shared )
(fiemap) [6] fe_logical: 1179648, fe_length: 131072, fe_physical:
3576953643008, fe_flags: 0x2008 (encoded shared )
(fiemap) [7] fe_logical: 1310720, fe_length: 262144, fe_physical:
3576953769984, fe_flags: 0x2000 (shared )
(fiemap) [8] fe_logical: 1572864, fe_length: 131072, fe_physical:
3576954032128, fe_flags: 0x2008 (encoded shared )
(fiemap) [9] fe_logical: 1703936, fe_length: 393216, fe_physical:
3576954159104, fe_flags: 0x2000 (shared )
(fiemap) [10] fe_logical: 2097152, fe_length: 131072, fe_physical:
3576954552320, fe_flags: 0x2008 (encoded shared )
(fiemap) [11] fe_logical: 2228224, fe_length: 393216, fe_physical:
3576954679296, fe_flags: 0x2000 (shared )
(fiemap) [12] fe_logical: 2621440, fe_length: 131072, fe_physical:
3576955072512, fe_flags: 0x2008 (encoded shared )
(fiemap) [13] fe_logical: 2752512, fe_length: 131072, fe_physical:
3576955199488, fe_flags: 0x2008 (encoded shared )
(fiemap) [14] fe_logical: 2883584, fe_length: 262144, fe_physical:
3576955326464, fe_flags: 0x2000 (shared )
(fiemap) [15] fe_logical: 3145728, fe_length: 131072, fe_physical:
3576955588608, fe_flags: 0x2008 (encoded shared )
(fiemap) [16] fe_logical: 3276800, fe_length: 1748992, fe_physical:
3576955715584, fe_flags: 0x2001 (last shared )
<first_file>: 5025792 shared bytes
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
3576952483840, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
3576952606720, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 262144, fe_physical:
3576952733696, fe_flags: 0x2000 (shared )
(fiemap) [3] fe_logical: 524288, fe_length: 131072, fe_physical:
3576952995840, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 655360, fe_length: 393216, fe_physical:
3576953122816, fe_flags: 0x2000 (shared )
(fiemap) [5] fe_logical: 1048576, fe_length: 131072, fe_physical:
3576953516032, fe_flags: 0x2008 (encoded shared )
(fiemap) [6] fe_logical: 1179648, fe_length: 131072, fe_physical:
3576953643008, fe_flags: 0x2008 (encoded shared )
(fiemap) [7] fe_logical: 1310720, fe_length: 262144, fe_physical:
3576953769984, fe_flags: 0x2000 (shared )
(fiemap) [8] fe_logical: 1572864, fe_length: 131072, fe_physical:
3576954032128, fe_flags: 0x2008 (encoded shared )
(fiemap) [9] fe_logical: 1703936, fe_length: 393216, fe_physical:
3576954159104, fe_flags: 0x2000 (shared )
(fiemap) [10] fe_logical: 2097152, fe_length: 131072, fe_physical:
3576954552320, fe_flags: 0x2008 (encoded shared )
(fiemap) [11] fe_logical: 2228224, fe_length: 393216, fe_physical:
3576954679296, fe_flags: 0x2000 (shared )
(fiemap) [12] fe_logical: 2621440, fe_length: 131072, fe_physical:
3576955072512, fe_flags: 0x2008 (encoded shared )
(fiemap) [13] fe_logical: 2752512, fe_length: 131072, fe_physical:
3576955199488, fe_flags: 0x2008 (encoded shared )
(fiemap) [14] fe_logical: 2883584, fe_length: 262144, fe_physical:
3576955326464, fe_flags: 0x2000 (shared )
(fiemap) [15] fe_logical: 3145728, fe_length: 131072, fe_physical:
3576955588608, fe_flags: 0x2008 (encoded shared )
(fiemap) [16] fe_logical: 3276800, fe_length: 393216, fe_physical:
3576955715584, fe_flags: 0x2000 (shared )
(fiemap) [17] fe_logical: 3670016, fe_length: 524288, fe_physical:
3576956108800, fe_flags: 0x2000 (shared )
(fiemap) [18] fe_logical: 4194304, fe_length: 524288, fe_physical:
3576956633088, fe_flags: 0x2000 (shared )
(fiemap) [19] fe_logical: 4718592, fe_length: 303104, fe_physical:
3576957157376, fe_flags: 0x2000 (shared )
(fiemap) [20] fe_logical: 5021696, fe_length: 4096, fe_physical:
742996164608, fe_flags: 0x2001 (last shared )
 <second_file>: 5025792 shared bytes

Checked some more pairs, most extents appear as "shared". In some
cases there is "last encoded" not shared extent with length 4096.

Since i use snapshots, may shared also mean "shared between snapshots"?

>
>> I thought that doing deduplication on a file in one snapshot would
>> affect all snapshots/subvolumes that contain this (exact version of
>> the) file because they all actually should point to the same data
>> extents, am i wrong?
>
> Well the case you're describing is one where dedupe wouldn't work - the
> extent would already be considered deduplicated since there is only one of
> them.
>
> If the data has changed from one snapshot to another, we've created new
> extents (for the new data) and it can be deduped against any other extent.
> For duperemove to discover it though you have to provide it a path which
> will eventually resolve to those extents (that is, duperemove has to find it
> in the file scan stage).

I didn't explain this properly: the snapshots are from different
subvolumes, not from the same subvolume. They contain data which i
know is actually duplicated on the main server (there are copies of a
huge Dropbox folder for instance on each subvolume). And duperemove
does find those duplicate files properly in the first phase.

My question is, is this sufficient to point duperemove to the read
only snapshots instead of the main subvolumes?

-- 
משיח NOW!
Moshiach is coming very soon, prepare yourself!
יחי אדוננו מורינו ורבינו מלך המשיח לעולם ועד!
