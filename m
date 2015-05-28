Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:34958 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbbE1CTV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 May 2015 22:19:21 -0400
Received: by labko7 with SMTP id ko7so17261815lab.2
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2015 19:19:19 -0700 (PDT)
MIME-Version: 1.0
From: Tobias Holst <tobby@tobby.eu>
Date: Thu, 28 May 2015 04:18:58 +0200
Message-ID: <CAGwxe4h5ubG1SptGLH9STNvDaghQJwbUXEDTa_UHREXye9nPsA@mail.gmail.com>
Subject: Uncorrectable errors on RAID6
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I am doing a scrub on my 6-drive btrfs RAID6. Last time it found zero
errors, but now I am getting this in my log:

[ 6610.888020] BTRFS: checksum error at logical 478232346624 on dev
/dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
[ 6610.888025] BTRFS: checksum error at logical 478232346624 on dev
/dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
[ 6610.888029] BTRFS: bdev /dev/dm-2 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
[ 6611.271334] BTRFS: unable to fixup (regular) error at logical
478232346624 on dev /dev/dm-2
[ 6611.831370] BTRFS: checksum error at logical 478232346624 on dev
/dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
[ 6611.831373] BTRFS: checksum error at logical 478232346624 on dev
/dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
[ 6611.831375] BTRFS: bdev /dev/dm-2 errs: wr 0, rd 0, flush 0, corrupt 2, gen 0
[ 6612.396402] BTRFS: unable to fixup (regular) error at logical
478232346624 on dev /dev/dm-2
[ 6904.027456] BTRFS: checksum error at logical 478232346624 on dev
/dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
[ 6904.027460] BTRFS: checksum error at logical 478232346624 on dev
/dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
[ 6904.027463] BTRFS: bdev /dev/dm-2 errs: wr 0, rd 0, flush 0, corrupt 3, gen 0

Looks like it is always the same sector.

"btrfs balance status" shows me:
scrub status for a34ce68b-bb9f-49f0-91fe-21a924ef11ae
        scrub started at Thu May 28 02:25:31 2015, running for 6759 seconds
        total bytes scrubbed: 448.87GiB with 14 errors
        error details: read=8 csum=6
        corrected errors: 3, uncorrectable errors: 11, unverified errors: 0

What does it mean and why are these erros uncorrectable even on a RAID6?
Can I find out, which files are affected?

system: Ubuntu 14.04.2
kernel version 4.0.4
btrfs-tools version: 4.0

Regards
Tobias
