Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36742 "EHLO
        mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751579AbcITLPY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 07:15:24 -0400
Received: by mail-pa0-f42.google.com with SMTP id id6so6196863pad.3
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 04:15:23 -0700 (PDT)
Date: Tue, 20 Sep 2016 03:15:19 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
To: tytso@mit.edu, linux-btrfs@vger.kernel.org
Subject: ChaCha20 vs. AES performance
Message-ID: <20160920111519.3n5ijtusvevasjl4@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not on the list or I would've replied directly, but on Haswell, ChaCha20 (in
software) is over 2x as fast as AES (in hardware), at realistic (for a
filesystem) block sizes:
 
testing speed of ctr(aes) (ctr(aes-aesni)) decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 378 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 1130 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 3981 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 15458 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 122880 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 391 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 1193 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 4212 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 16388 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 131029 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 417 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 1222 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 4398 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 17114 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 137028 cycles (8192 bytes)

testing speed of chacha20 (chacha20-simd) encryption
test 0 (256 bit key, 16 byte blocks): 1 operation in 4356 cycles (16 bytes)
test 1 (256 bit key, 64 byte blocks): 1 operation in 4004 cycles (64 bytes)
test 2 (256 bit key, 256 byte blocks): 1 operation in 6524 cycles (256 bytes)
test 3 (256 bit key, 1024 byte blocks): 1 operation in 9248 cycles (1024 bytes)
test 4 (256 bit key, 8192 byte blocks): 1 operation in 60274 cycles (8192 bytes)

Poly1305 is also plenty fast:

testing speed of gcm(aes) (gcm_base(ctr-aes-aesni,ghash-generic)) encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 7567 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 9654 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 19010 cycles (256 bytes)
test 3 (128 bit key, 512 byte blocks): 1 operation in 33118 cycles (512 bytes)
test 4 (128 bit key, 1024 byte blocks): 1 operation in 59738 cycles (1024 bytes)
test 5 (128 bit key, 2048 byte blocks): 1 operation in 106545 cycles (2048 bytes)
test 6 (128 bit key, 4096 byte blocks): 1 operation in 211189 cycles (4096 bytes)
test 7 (128 bit key, 8192 byte blocks): 1 operation in 370439 cycles (8192 bytes)
test 8 (192 bit key, 16 byte blocks): 1 operation in 6780 cycles (16 bytes)
test 9 (192 bit key, 64 byte blocks): 1 operation in 8802 cycles (64 bytes)
test 10 (192 bit key, 256 byte blocks): 1 operation in 17352 cycles (256 bytes)
test 11 (192 bit key, 512 byte blocks): 1 operation in 28680 cycles (512 bytes)
test 12 (192 bit key, 1024 byte blocks): 1 operation in 51230 cycles (1024 bytes)
test 13 (192 bit key, 2048 byte blocks): 1 operation in 96662 cycles (2048 bytes)
test 14 (192 bit key, 4096 byte blocks): 1 operation in 187287 cycles (4096 bytes)
test 15 (192 bit key, 8192 byte blocks): 1 operation in 372570 cycles (8192 bytes)
test 16 (256 bit key, 16 byte blocks): 1 operation in 6273 cycles (16 bytes)
test 17 (256 bit key, 64 byte blocks): 1 operation in 8096 cycles (64 bytes)
test 18 (256 bit key, 256 byte blocks): 1 operation in 15895 cycles (256 bytes)
test 19 (256 bit key, 512 byte blocks): 1 operation in 26259 cycles (512 bytes)
test 20 (256 bit key, 1024 byte blocks): 1 operation in 47121 cycles (1024 bytes)
test 21 (256 bit key, 2048 byte blocks): 1 operation in 91003 cycles (2048 bytes)
test 22 (256 bit key, 4096 byte blocks): 1 operation in 175883 cycles (4096 bytes)
test 23 (256 bit key, 8192 byte blocks): 1 operation in 340904 cycles (8192 bytes)

testing speed of rfc7539esp(chacha20,poly1305) (rfc7539esp(chacha20-simd,poly1305-simd)) encryption
test 0 (288 bit key, 16 byte blocks): 1 operation in 12145 cycles (16 bytes)
test 1 (288 bit key, 64 byte blocks): 1 operation in 14538 cycles (64 bytes)
test 2 (288 bit key, 256 byte blocks): 1 operation in 16435 cycles (256 bytes)
test 3 (288 bit key, 512 byte blocks): 1 operation in 15622 cycles (512 bytes)
test 4 (288 bit key, 1024 byte blocks): 1 operation in 18671 cycles (1024 bytes)
test 5 (288 bit key, 2048 byte blocks): 1 operation in 23264 cycles (2048 bytes)
test 6 (288 bit key, 4096 byte blocks): 1 operation in 36480 cycles (4096 bytes)
test 7 (288 bit key, 8192 byte blocks): 1 operation in 75051 cycles (8192 bytes)

When AVX-512 comes out ChaCha20 is going to get even faster - probably by more
than 2x, since they're adding a rotate instruction. I haven't tested on ARM but
I'd be surprised if the situation is significantly different there (the kernel's
lacking a NEON ChaCha20 implementation, but I could do one).

Just because it's implemented in hardware doesn't mean it's faster...
