Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55724 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2GGVGq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Jul 2012 17:06:46 -0400
Received: by lbbgm6 with SMTP id gm6so17532983lbb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Jul 2012 14:06:44 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 7 Jul 2012 23:06:44 +0200
Message-ID: <CACe732vW=0XO3V=Pjm8pO5Me1Lq=t=mrELN4XT6qr-D8a0Rvxg@mail.gmail.com>
Subject: Re: [PATCH 0/5] btrfs: lz4/lz4hc compression
From: Jan Killius <tmpnerd@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: andrew.mahone@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,
I get lots of "kick the bucket" messages with the newest lz4 patches.
Is there any way to debug/fix this ?
Here is a dmesg snippet:
[34114.165731] lz4: pg_out 33 > 32 nr_dest, nr_out 33; len 131072
out_len 131587 hdr 8, ino 1948055
[34114.165733] ... kick the bucket
[34114.166268] lz4: pg_out 33 > 32 nr_dest, nr_out 33; len 131072
out_len 131587 hdr 8, ino 1948055
[34114.166270] ... kick the bucket
[34114.166309] lz4: pg_out 33 > 32 nr_dest, nr_out 33; len 131072
out_len 131518 hdr 8, ino 1948055
[34114.166312] lz4: pg_out 33 > 32 nr_dest, nr_out 33; len 131072
out_len 131492 hdr 8, ino 1948055
[34114.166313] ... kick the bucket
[34114.166314] ... kick the bucket
[34114.166330] lz4: pg_out 33 > 32 nr_dest, nr_out 33; len 131072
out_len 131549 hdr 8, ino 1948055
[34114.166332] ... kick the bucket
[34114.166373] lz4: pg_out 33 > 32 nr_dest, nr_out 33; len 131072
out_len 131521 hdr 8, ino 1948055
[34114.166375] ... kick the bucket
[34114.166406] lz4: pg_out 33 > 32 nr_dest, nr_out 33; len 131072
out_len 131565 hdr 8, ino 1948055
[34114.166409] lz4: pg_out 33 > 32 nr_dest, nr_out 33; len 131072
out_len 131587 hdr 8, ino 1948055
[34114.166410] ... kick the bucket
[34114.166411] ... kick the bucket
[34114.166687] lz4: pg_out 33 > 32 nr_dest, nr_out 33; len 131072
out_len 131587 hdr 8, ino 1948055
[34114.166689] ... kick the bucket
[34119.160244] lz4: pg_out 33 > 32 nr_dest, nr_out 33; len 131072
out_len 131587 hdr 8, ino 1948044
[34119.160246] ... kick the bucket
[34119.160539] lz4: pg_out 33 > 32 nr_dest, nr_out 33; len 131072
out_len 131587 hdr 8, ino 1948044
[34119.160540] ... kick the bucket
[34119.162139] lz4: pg_out 33 > 32 nr_dest, nr_out 33; len 131072
out_len 131577 hdr 8, ino 1948044
[34119.162144] ... kick the bucket
