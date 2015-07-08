Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:34760 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbbGHF57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 01:57:59 -0400
Received: by lagx9 with SMTP id x9so218034380lag.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2015 22:57:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+xOVSN1v5v9z3=zP8E6phTV0c54pOCf7Rh10EBR4zkkFNVo4A@mail.gmail.com>
References: <CA+xOVSO2Cd1aYxAnA_Aq32oBTiMTbuo1YQo2cqEY_5WONQV=qA@mail.gmail.com>
	<20150706223404.GF7507@wotan.suse.de>
	<CA+xOVSNrX4yT=+0Xre8qpRrsA=+Nu0w5+fUa0oAbvXf0CFr35w@mail.gmail.com>
	<20150706230725.GG7507@wotan.suse.de>
	<559B7158.6050404@spotprint.com.au>
	<CA+xOVSN1v5v9z3=zP8E6phTV0c54pOCf7Rh10EBR4zkkFNVo4A@mail.gmail.com>
Date: Wed, 8 Jul 2015 08:57:57 +0300
Message-ID: <CA+xOVSOSzeeaz4dNJCV0JuXRD2ESTbHO4TvO7v0WQp=72xiaWA@mail.gmail.com>
Subject: Re: running duperemove but no free space gain
From: Mordechay Kaganer <mkaganer@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

B.H.


On Tue, Jul 7, 2015 at 4:14 PM, Mordechay Kaganer <mkaganer@gmail.com> wrote:
>
>
> The conclusion is: to actually reclaim the duplicated space you have
> to include all snapshots that may point to the file.
>

Tried to dedupe the real data, including all snapshots. Still no free
space gain. This time, this looks like dedupe didn't actually work.
The log:

# duperemove:

Showing 12 identical extents with id 572cbc6e
Start           Length          Filename
0.0     54.9M   "/test_btrfs/snapshots/2015-06-13/subvol1/dir770/21+/3065.wav"
0.0     54.9M
"/test_btrfs/snapshots/2015-06-13/subvol1/dir770.sav/21/3065.wav"
0.0     54.9M   "/test_btrfs/snapshots/2015-06-16/subvol1/dir770/21+/3065.wav"
0.0     54.9M
"/test_btrfs/snapshots/2015-06-16/subvol1/dir770.sav/21/3065.wav"
0.0     54.9M   "/test_btrfs/snapshots/2015-06-20/subvol1/dir770/21+/3065.wav"
0.0     54.9M
"/test_btrfs/snapshots/2015-06-20/subvol1/dir770.sav/21/3065.wav"
0.0     54.9M   "/test_btrfs/snapshots/2015-06-23/subvol1/dir770/21+/3065.wav"
0.0     54.9M
"/test_btrfs/snapshots/2015-06-23/subvol1/dir770.sav/21/3065.wav"
0.0     54.9M   "/test_btrfs/snapshots/2015-07-05/subvol1/dir770/21+/3065.wav"
0.0     54.9M
"/test_btrfs/snapshots/2015-07-05/subvol1/dir770.sav/21/3065.wav"
0.0     54.9M   "/test_btrfs/subvol1/dir770/21+/3065.wav"
0.0     54.9M   "/test_btrfs/subvol1/dir770.sav/21/3065.wav"
....
[0x9b7800] Try to dedupe extents with id 572cbc6e
[0x9b7800] Dedupe 1 extents (id: 572cbc6e) with target: (0.0, 54.9M),
"/test_btrfs/snapshots/2015-06-13/subvol1/dir770/21+/3065.wav"
....
Kernel processed data (excludes target files): 49.8G
Comparison of extent info shows a net change in shared extents of: 0.0

# show-shared-extents $file | head -5:

show-shared-extents
/test_btrfs/snapshots/2015-06-13/subvol1/dir770/21+/3065.wav:
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
8178629230592, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
8178629300224, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 131072, fe_physical:
8178629369856, fe_flags: 0x2008 (encoded shared )
(fiemap) [3] fe_logical: 393216, fe_length: 131072, fe_physical:
8178629451776, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 524288, fe_length: 131072, fe_physical:
8178629533696, fe_flags: 0x2008 (encoded shared )
show-shared-extents
/test_btrfs/snapshots/2015-06-13/subvol1/dir770.sav/21/3065.wav:
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
8178629230592, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
8178629300224, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 131072, fe_physical:
8178629369856, fe_flags: 0x2008 (encoded shared )
(fiemap) [3] fe_logical: 393216, fe_length: 131072, fe_physical:
8178629451776, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 524288, fe_length: 131072, fe_physical:
8178629533696, fe_flags: 0x2008 (encoded shared )
show-shared-extents
/test_btrfs/snapshots/2015-06-16/subvol1/dir770/21+/3065.wav:
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
8178629230592, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
8178629300224, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 131072, fe_physical:
8178629369856, fe_flags: 0x2008 (encoded shared )
(fiemap) [3] fe_logical: 393216, fe_length: 131072, fe_physical:
8178629451776, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 524288, fe_length: 131072, fe_physical:
8178629533696, fe_flags: 0x2008 (encoded shared )
show-shared-extents
/test_btrfs/snapshots/2015-06-16/subvol1/dir770.sav/21/3065.wav:
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
7960106323968, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
7960106393600, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 131072, fe_physical:
7960106463232, fe_flags: 0x2008 (encoded shared )
(fiemap) [3] fe_logical: 393216, fe_length: 131072, fe_physical:
7960106545152, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 524288, fe_length: 131072, fe_physical:
7960106627072, fe_flags: 0x2008 (encoded shared )
show-shared-extents
/test_btrfs/snapshots/2015-06-20/subvol1/dir770/21+/3065.wav:
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
8178629230592, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
8178629300224, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 131072, fe_physical:
8178629369856, fe_flags: 0x2008 (encoded shared )
(fiemap) [3] fe_logical: 393216, fe_length: 131072, fe_physical:
8178629451776, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 524288, fe_length: 131072, fe_physical:
8178629533696, fe_flags: 0x2008 (encoded shared )
show-shared-extents
/test_btrfs/snapshots/2015-06-20/subvol1/dir770.sav/21/3065.wav:
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
7960106323968, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
7960106393600, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 131072, fe_physical:
7960106463232, fe_flags: 0x2008 (encoded shared )
(fiemap) [3] fe_logical: 393216, fe_length: 131072, fe_physical:
7960106545152, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 524288, fe_length: 131072, fe_physical:
7960106627072, fe_flags: 0x2008 (encoded shared )
show-shared-extents
/test_btrfs/snapshots/2015-06-23/subvol1/dir770/21+/3065.wav:
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
8178629230592, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
8178629300224, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 131072, fe_physical:
8178629369856, fe_flags: 0x2008 (encoded shared )
(fiemap) [3] fe_logical: 393216, fe_length: 131072, fe_physical:
8178629451776, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 524288, fe_length: 131072, fe_physical:
8178629533696, fe_flags: 0x2008 (encoded shared )
show-shared-extents
/test_btrfs/snapshots/2015-06-23/subvol1/dir770.sav/21/3065.wav:
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
7960106323968, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
7960106393600, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 131072, fe_physical:
7960106463232, fe_flags: 0x2008 (encoded shared )
(fiemap) [3] fe_logical: 393216, fe_length: 131072, fe_physical:
7960106545152, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 524288, fe_length: 131072, fe_physical:
7960106627072, fe_flags: 0x2008 (encoded shared )
show-shared-extents
/test_btrfs/snapshots/2015-07-05/subvol1/dir770/21+/3065.wav:
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
8178629230592, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
8178629300224, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 131072, fe_physical:
8178629369856, fe_flags: 0x2008 (encoded shared )
(fiemap) [3] fe_logical: 393216, fe_length: 131072, fe_physical:
8178629451776, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 524288, fe_length: 131072, fe_physical:
8178629533696, fe_flags: 0x2008 (encoded shared )
show-shared-extents
/test_btrfs/snapshots/2015-07-05/subvol1/dir770.sav/21/3065.wav:
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
7960106323968, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
7960106393600, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 131072, fe_physical:
7960106463232, fe_flags: 0x2008 (encoded shared )
(fiemap) [3] fe_logical: 393216, fe_length: 131072, fe_physical:
7960106545152, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 524288, fe_length: 131072, fe_physical:
7960106627072, fe_flags: 0x2008 (encoded shared )
show-shared-extents /test_btrfs/subvol1/dir770/21+/3065.wav:
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
8178629230592, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
8178629300224, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 131072, fe_physical:
8178629369856, fe_flags: 0x2008 (encoded shared )
(fiemap) [3] fe_logical: 393216, fe_length: 131072, fe_physical:
8178629451776, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 524288, fe_length: 131072, fe_physical:
8178629533696, fe_flags: 0x2008 (encoded shared )
show-shared-extents /test_btrfs/subvol1/dir770.sav/21/3065.wav:
(fiemap) [0] fe_logical: 0, fe_length: 131072, fe_physical:
7960106323968, fe_flags: 0x2008 (encoded shared )
(fiemap) [1] fe_logical: 131072, fe_length: 131072, fe_physical:
7960106393600, fe_flags: 0x2008 (encoded shared )
(fiemap) [2] fe_logical: 262144, fe_length: 131072, fe_physical:
7960106463232, fe_flags: 0x2008 (encoded shared )
(fiemap) [3] fe_logical: 393216, fe_length: 131072, fe_physical:
7960106545152, fe_flags: 0x2008 (encoded shared )
(fiemap) [4] fe_logical: 524288, fe_length: 131072, fe_physical:
7960106627072, fe_flags: 0x2008 (encoded shared )

Note that here we actually have 2 duplicate files
(subvol1/dir770/21+/3065.wav, subvol1/dir770.sav/21/3065.wav) and 5
snapshots of each of file. We attempted to dedupe all 12 instances at
once but according to fe_physical we still have 2 copies of the data.
Why is this happening?

-- 
משיח NOW!
Moshiach is coming very soon, prepare yourself!
יחי אדוננו מורינו ורבינו מלך המשיח לעולם ועד!
