Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54180 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab2FGJOO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2012 05:14:14 -0400
Received: by vcbf11 with SMTP id f11so181612vcb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2012 02:14:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADP2XCmhPX9HyLn6XWs4jgDHhHj8S1-G8PrZo50m4pRRXVft7A@mail.gmail.com>
References: <CADP2XCmhPX9HyLn6XWs4jgDHhHj8S1-G8PrZo50m4pRRXVft7A@mail.gmail.com>
From: Randall Mason <lists@mason.ch>
Date: Thu, 7 Jun 2012 12:13:53 +0300
Message-ID: <CADP2XCmzvf2x10L=Cn8Wvod=2hST0ZrQ16Nu4EaYraJ1JKZyrQ@mail.gmail.com>
Subject: Re: Uncorrectable errors on newly extended volume
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Helmut Hullen <Hullen <at> t-online.de> writes:

> Du meintest am 01.06.12:
>
> > I'm having a problem with a newly extended btrfs volume.  It is
> > running on debian testing with an almost stock 3.1.0 kernel with a
> > little bit of patches
>
> You should use a newer kernel, p.e. 3.3.7 or 3.4

Hello!
I've just upgraded to 3.4.0 from git.kernel.org and I'm still running
into problems.  I checked the Problems FAQ and there doesn't seem to
be anything that matches my problem.  Here's a set of errors when I
try to rsync to the volume in question:
I run:
rmason@<btrfsHost>:~$ sudo rsync -avH -e "ssh -4" --delete --progress
--inplace root@<otherHost>.mason.ch:/home/randall/ /home/randall/
root@<otherHost>.mason.ch's password:
receiving incremental file list
anime/[SFS] Break Blade [BD 1920x1080 x264 FLAC][BG]/[SFS] Break Blade
- 02v2 [BD 1920x1080 x264 FLAC][BG].mkv
     2165440   0%    1.96MB/s    0:28:24
rsync: write failed on "/home/randall/anime/[SFS] Break Blade [BD
1920x1080 x264 FLAC][BG]/[SFS] Break Blade - 02v2 [BD 1920x1080 x264
FLAC][BG].mkv": Input/output error (5)
rsync error: error in file IO (code 11) at receiver.c(322) [receiver=3.0.9]
rsync: connection unexpectedly closed (11135 bytes received so far) [generator]
rsync error: error in rsync protocol data stream (code 12) at
io.c(605) [generator=3.0.9]

I tail messages.log during the rsync command and this is what I get:
Jun  7 04:42:51 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
2052096 csum 2566472073 private 2923703033
Jun  7 04:42:51 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
2052096 csum 2566472073 private 2923703033
Jun  7 04:42:51 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
2138112 csum 2566472073 private 214370805
Jun  7 04:42:51 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
2408448 csum 2566472073 private 3284052016
Jun  7 04:42:51 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
2674688 csum 2566472073 private 669053144
Jun  7 04:42:51 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
2940928 csum 2566472073 private 2266756296
Jun  7 04:42:51 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
3211264 csum 2566472073 private 3658566492
Jun  7 04:42:51 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
3477504 csum 2566472073 private 4196274894
Jun  7 04:42:51 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
3743744 csum 2566472073 private 2836083845
Jun  7 04:42:51 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
4014080 csum 2566472073 private 2057760174
Jun  7 04:42:56 <btrfsHost> kernel: btrfs_readpage_end_io_hook: 334
callbacks suppressed
Jun  7 04:42:56 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
93687808 csum 2566472073 private 3122689738
Jun  7 04:42:56 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
93954048 csum 2566472073 private 2432138128
Jun  7 04:42:56 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
94220288 csum 2566472073 private 176960849
Jun  7 04:42:56 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
94490624 csum 2566472073 private 3686755414
Jun  7 04:42:56 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
94756864 csum 2566472073 private 3413998024
Jun  7 04:42:56 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
95023104 csum 2566472073 private 1213584997
Jun  7 04:42:56 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
95293440 csum 2566472073 private 3260773985
Jun  7 04:42:56 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
95559680 csum 2566472073 private 859919222
Jun  7 04:42:56 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
95825920 csum 2566472073 private 330759519
Jun  7 04:42:56 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
96096256 csum 2566472073 private 2517217076
Jun  7 04:43:01 <btrfsHost> kernel: btrfs_readpage_end_io_hook: 503
callbacks suppressed
Jun  7 04:43:01 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
231006208 csum 2566472073 private 4003729605
Jun  7 04:43:01 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
231272448 csum 2566472073 private 3631855256
Jun  7 04:43:01 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
231542784 csum 2566472073 private 610953759
Jun  7 04:43:01 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
231809024 csum 2566472073 private 3113324635
Jun  7 04:43:01 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
232075264 csum 2566472073 private 3907299018
Jun  7 04:43:01 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
232345600 csum 2566472073 private 4261889602
Jun  7 04:43:01 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
232611840 csum 2566472073 private 2892910093
Jun  7 04:43:01 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
232878080 csum 2566472073 private 3857339386
Jun  7 04:43:01 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
233148416 csum 2566472073 private 3410895248
Jun  7 04:43:01 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
233414656 csum 2566472073 private 4090819852
Jun  7 04:43:06 <btrfsHost> kernel: btrfs_readpage_end_io_hook: 508
callbacks suppressed
Jun  7 04:43:06 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
369664000 csum 2566472073 private 1949454837
Jun  7 04:43:06 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
369930240 csum 2566472073 private 2867367336
Jun  7 04:43:06 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
370200576 csum 2566472073 private 299690505
Jun  7 04:43:06 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
370466816 csum 2566472073 private 2449128099
Jun  7 04:43:06 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
370733056 csum 2566472073 private 3831761403
Jun  7 04:43:06 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
371003392 csum 2566472073 private 594867053
Jun  7 04:43:06 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
371269632 csum 2566472073 private 2391764021
Jun  7 04:43:06 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
371535872 csum 2566472073 private 1250201429
Jun  7 04:43:06 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
371806208 csum 2566472073 private 3704878237
Jun  7 04:43:06 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
372072448 csum 2566472073 private 1588417531
Jun  7 04:43:11 <btrfsHost> kernel: btrfs_readpage_end_io_hook: 515
callbacks suppressed
Jun  7 04:43:11 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
510197760 csum 2566472073 private 1297006436
Jun  7 04:43:11 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
510464000 csum 2566472073 private 1281951163
Jun  7 04:43:11 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
510730240 csum 2566472073 private 1649630795
Jun  7 04:43:11 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
511000576 csum 2566472073 private 621478547
Jun  7 04:43:11 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
511266816 csum 2566472073 private 709499052
Jun  7 04:43:11 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
511533056 csum 2566472073 private 1772067950
Jun  7 04:43:11 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
511803392 csum 2566472073 private 4181868570
Jun  7 04:43:11 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
512069632 csum 2566472073 private 3607792064
Jun  7 04:43:11 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
512335872 csum 2566472073 private 3698346856
Jun  7 04:43:11 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
512606208 csum 2566472073 private 2503998955
Jun  7 04:43:16 <btrfsHost> kernel: btrfs_readpage_end_io_hook: 500
callbacks suppressed
Jun  7 04:43:16 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
646713344 csum 2566472073 private 37706649
Jun  7 04:43:16 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
646979584 csum 2566472073 private 3463060199
Jun  7 04:43:16 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
647249920 csum 2566472073 private 2139594835
Jun  7 04:43:16 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
647516160 csum 2566472073 private 369916444
Jun  7 04:43:16 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
647782400 csum 2566472073 private 1041024394
Jun  7 04:43:16 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
648052736 csum 2566472073 private 1131002593
Jun  7 04:43:16 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
648318976 csum 2566472073 private 3304466401
Jun  7 04:43:16 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
648585216 csum 2566472073 private 2262830394
Jun  7 04:43:16 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
648855552 csum 2566472073 private 93740949
Jun  7 04:43:16 <btrfsHost> kernel: btrfs csum failed ino 1258837 off
649121792 csum 2566472073 private 2413285993

And I make sure that that file is exactly the file that's being transferred:
sudo find /home/randall/ -inum 1258837
/home/randall/anime/[SFS] Break Blade [BD 1920x1080 x264
FLAC][BG]/[SFS] Break Blade - 02v2 [BD 1920x1080 x264 FLAC][BG].mkv

Any more help would be appreciated.  Why is this happening, and how
can I get my data back?

-Randall Mason
