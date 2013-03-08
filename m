Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:56371 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab3CHIy7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Mar 2013 03:54:59 -0500
Received: from athlonxp.localnet (unknown [IPv6:2a01:e34:ef31:5f50:922b:34ff:fe35:5a3c])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 01E4B94025A
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Mar 2013 09:54:52 +0100 (CET)
From: =?ISO-8859-1?Q?Fr=E9d=E9ric?= COIFFIER <frederic.coiffier@free.fr>
To: linux-btrfs@vger.kernel.org
Subject: How to recover uncorrectable errors ?
Date: Fri, 08 Mar 2013 09:54:50 +0100
Message-ID: <6033676.gK0GbPgrpE@athlonxp>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm using a Linux 3.7.6 (Gentoo Linux) with btrfs-progs-0.20_rc1_p56 and since few days, I have some uncorrectable errors :

# btrfs scrub status /
scrub status for 6b6ea99b-edee-498d-bf07-f3a3f1cba2f3
        scrub started at Thu Mar  7 20:12:31 2013 and finished after 515 seconds
        total bytes scrubbed: 31.02GB with 6 errors
        error details: csum=6
        corrected errors: 0, uncorrectable errors: 6, unverified errors: 0

I don't know what has produced this error (maybe an hard reset or a power cut) but I use an old not-SSD hard-disk.

I have discovered this problem thanks to several errors in dmesg when I try to access to a file :

[ 2985.163718] btrfs: sda2 checksum verify failed on 26326409216 wanted 59A31CB1 found DFB0FE7F level 0
[ 2985.169191] btrfs: sda2 checksum verify failed on 26326409216 wanted 59A31CB1 found DFB0FE7F level 0
[ 2993.102810] btrfs: sda2 checksum verify failed on 272228352 wanted 1A0FCFD3 found 119281BE level 0
[ 2993.114213] btrfs: sda2 checksum verify failed on 272228352 wanted 1A0FCFD3 found 119281BE level 0
[ 2993.114527] btrfs: sda2 checksum verify failed on 272228352 wanted 1A0FCFD3 found 119281BE level 0
[ 2993.114795] btrfs: sda2 checksum verify failed on 272228352 wanted 1A0FCFD3 found 119281BE level 0
[ 2993.115097] btrfs: sda2 checksum verify failed on 272228352 wanted 1A0FCFD3 found 119281BE level 0
[ 2993.115349] btrfs: sda2 checksum verify failed on 272228352 wanted 1A0FCFD3 found 119281BE level 0
[ 2993.115585] btrfs: sda2 checksum verify failed on 272228352 wanted 1A0FCFD3 found 119281BE level 0
[ 2993.115956] btrfs: sda2 checksum verify failed on 272228352 wanted 1A0FCFD3 found 119281BE level 0
[ 2993.116260] btrfs: sda2 checksum verify failed on 272228352 wanted 1A0FCFD3 found 119281BE level 0
[ 2993.116558] btrfs: sda2 checksum verify failed on 272228352 wanted 1A0FCFD3 found 119281BE level 0
[ 2998.100230] csum_tree_block: 27408 callbacks suppressed
[ 2998.100233] btrfs: sda2 checksum verify failed on 272228352 wanted 1A0FCFD3 found 119281BE level 0
[ 2998.100406] btrfs: sda2 checksum verify failed on 272228352 wanted 1A0FCFD3 found 119281BE level 0
[ 2998.100591] btrfs: sda2 checksum verify failed on 272228352 wanted 1A0FCFD3 found 119281BE level 0

If I restart a btrfs scrub, I get these messages :

[ 3047.835131] btrfs: checksum error at logical 272228352 on dev /dev/sda2, sector 548080: metadata leaf (level 0) in tree 5
[ 3047.835134] btrfs: checksum error at logical 272228352 on dev /dev/sda2, sector 548080: metadata leaf (level 0) in tree 5
[ 3047.835137] btrfs: bdev /dev/sda2 errs: wr 0, rd 0, flush 0, corrupt 20, gen 0
[ 3047.953751] btrfs: unable to fixup (regular) error at logical 272228352 on dev /dev/sda2
[ 3052.349518] btrfs: checksum error at logical 556208128 on dev /dev/sda2, sector 1102728: metadata leaf (level 0) in tree 5
[ 3052.349521] btrfs: checksum error at logical 556208128 on dev /dev/sda2, sector 1102728: metadata leaf (level 0) in tree 5
[ 3052.349524] btrfs: bdev /dev/sda2 errs: wr 0, rd 0, flush 0, corrupt 21, gen 0
[ 3055.840357] btrfs: unable to fixup (regular) error at logical 556208128 on dev /dev/sda2
[ 3061.032879] btrfs: checksum error at logical 272228352 on dev /dev/sda2, sector 2645232: metadata leaf (level 0) in tree 5
[ 3061.032882] btrfs: checksum error at logical 272228352 on dev /dev/sda2, sector 2645232: metadata leaf (level 0) in tree 5
[ 3061.032885] btrfs: bdev /dev/sda2 errs: wr 0, rd 0, flush 0, corrupt 22, gen 0
[ 3063.014553] btrfs: unable to fixup (regular) error at logical 272228352 on dev /dev/sda2
[ 3067.758444] btrfs: checksum error at logical 556208128 on dev /dev/sda2, sector 3199880: metadata leaf (level 0) in tree 5
[ 3067.758447] btrfs: checksum error at logical 556208128 on dev /dev/sda2, sector 3199880: metadata leaf (level 0) in tree 5
[ 3067.758450] btrfs: bdev /dev/sda2 errs: wr 0, rd 0, flush 0, corrupt 23, gen 0
[ 3067.822206] btrfs: unable to fixup (regular) error at logical 556208128 on dev /dev/sda2

I tried a LiveCD to make a btrfsck [I have to check its version] but it segfaults during the test.

Today, I can't remove the file (and I can't delete its directory), updatedb runs during hours when it tries to read this file.
So, what is the best way to recover these errors (as I think that some files are definitely lost) ?
I would like to identify the corrupted files and to delete them.

Regards,
Frederic
