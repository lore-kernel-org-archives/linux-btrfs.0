Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35461 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631AbcHJD16 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 23:27:58 -0400
Received: by mail-wm0-f67.google.com with SMTP id i5so6969437wmg.2
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Aug 2016 20:27:57 -0700 (PDT)
MIME-Version: 1.0
From: Dave T <davestechshop@gmail.com>
Date: Tue, 9 Aug 2016 23:27:56 -0400
Message-ID: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
Subject: checksum error in metadata node - best way to move root fs to new drive?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs scrub returned with uncorrectable errors. Searching in dmesg
returns the following information:

BTRFS warning (device dm-0): checksum error at logical NNNNN on
/dev/mapper/[crypto] sector: yyyyy metadata node (level 2) in tree 250

it also says:

unable to fixup (regular) error at logical NNNNNN on /dev/mapper/[crypto]


I assume I have a bad block device. Does that seem correct? The
important data is backed up.

However, it would save me a lot of time reinstalling the operating
system and setting up my work environment if I can copy this root
filesystem to another storage device.

Can I do that, considering the errors I have mentioned?? With the
uncorrectable error being in a metadata node, what (if anything) does
that imply about restoring from this drive?

If I can copy this entire root filesystem, what is the best way to do
it? The btrfs restore tool? cp? rsync? Some cloning tool? Other
options?

If I use the btrfs restore tool, should I use options x, m and S? In
particular I wonder exactly what the S option does. If I leave S out,
are all symlinks ignored?

I'm trying to save time and clone this so that I get the operating
system and all my tweaks / configurations back. As I said, the really
important data is separately backed up.

I appreciate all suggestions.
