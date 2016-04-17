Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38712 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbcDQImC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Apr 2016 04:42:02 -0400
Received: by mail-wm0-f42.google.com with SMTP id u206so84452030wme.1
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2016 01:42:01 -0700 (PDT)
MIME-Version: 1.0
From: Peter Waller <peter@pdftables.com>
Date: Sun, 17 Apr 2016 09:41:21 +0100
Message-ID: <CAFChkqsNBpvSt_2c1HT5X74MTj1yzu5c2Jtpa8b1_5AcVfGU4g@mail.gmail.com>
Subject: [ANN] fienode: compute SHA1 hash of file extents for finding CoW copies
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I just released a toy program, "fienode" which computes a SHA1 of the
physical extents of a file.

Link: https://github.com/pwaller/fienode

There are some questions around on the internet of how to find CoW
copies, which I've answered:

http://unix.stackexchange.com/questions/263309/how-to-verify-a-file-copy-is-reflink-cow/277043#277043

I would appreciate if anyone fact-checks me or has a better way :)

Regards,

- Peter

P.S.

A BRFS mystery:

I did a cp --reflink of a large file, and within a few minutes, the
extents of the copy changed, even though I did not intentionally
change the file. But only the extents in the copy changed, not the
original.

filefrag -v file
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..   32767:  516366448.. 516399215:  32768:
   1:    32768..   65535:  516430848.. 516463615:  32768:  516399216:
   2:    65536..   98303:  516463616.. 516496383:  32768:
   3:    98304..  131071:  516496384.. 516529151:  32768:
   4:   131072..  163839:  516529152.. 516561919:  32768:
   5:   163840..  180671:  516561920.. 516578751:  16832:
   6:   180672..  213439:  516579186.. 516611953:  32768:  516578752:
   7:   213440..  246207:  516611954.. 516644721:  32768:
   8:   246208..  278975:  516644722.. 516677489:  32768:
   9:   278976..  306431:  516399217.. 516426672:  27456:  516677490:
  10:   306432..  339199:  516692992.. 516725759:  32768:  516426673:
  11:   339200..  371967:  516725760.. 516758527:  32768:
  12:   371968..  404735:  516758528.. 516791295:  32768:
  13:   404736..  410059:  516791296.. 516796619:   5324:             eof

[ 5 minutes pass ]

File size of x is 1679605760 (410060 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..   32767:  516366448.. 516399215:  32768:
   1:    32768..   98303:  516430848.. 516496383:  65536:  516399216:
   2:    98304..  131071:  516496384.. 516529151:  32768:
   3:   131072..  163839:  516529152.. 516561919:  32768:
   4:   163840..  180671:  516561920.. 516578751:  16832:
   5:   180672..  213439:  516579186.. 516611953:  32768:  516578752:
   6:   213440..  246207:  516611954.. 516644721:  32768:
   7:   246208..  278975:  516644722.. 516677489:  32768:
   8:   278976..  306431:  516399217.. 516426672:  27456:  516677490:
   9:   306432..  339199:  516692992.. 516725759:  32768:  516426673:
  10:   339200..  371967:  516725760.. 516758527:  32768:
  11:   371968..  404735:  516758528.. 516791295:  32768:
  12:   404736..  410059:  516791296.. 516796619:   5324:             eof

[ an hour passes ]

File size of x is 1679605760 (410060 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..   32767:  516366448.. 516399215:  32768:
   1:    32768..  163839:  516430848.. 516561919: 131072:  516399216:
   2:   163840..  180671:  516561920.. 516578751:  16832:
   3:   180672..  213439:  516579186.. 516611953:  32768:  516578752:
   4:   213440..  246207:  516611954.. 516644721:  32768:
   5:   246208..  278975:  516644722.. 516677489:  32768:
   6:   278976..  306431:  516399217.. 516426672:  27456:  516677490:
   7:   306432..  339199:  516692992.. 516725759:  32768:  516426673:
   8:   339200..  371967:  516725760.. 516758527:  32768:
   9:   371968..  404735:  516758528.. 516791295:  32768:
  10:   404736..  410059:  516791296.. 516796619:   5324:             eof


Over time, some extents are being merged in the reflink copies.

What mechanism is causing this, and why did it only happen to one of
the CoW copies and not the other?
