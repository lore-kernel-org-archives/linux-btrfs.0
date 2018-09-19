Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i6.italiaonline.it ([213.209.14.33]:48986 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731253AbeITAUX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 20:20:23 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: grub-devel@gnu.org
Cc: Daniel Kiper <dkiper@net-space.pl>, linux-btrfs@vger.kernel.org
Subject: [PATCH V7] Add support for BTRFS raid5/6 to GRUB
Date: Wed, 19 Sep 2018 20:40:31 +0200
Message-Id: <20180919184040.22540-1-kreijack@libero.it>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>





Hi All,

the aim of this patches set is to provide support for a BTRFS raid5/6
filesystem in GRUB.

The first patch, implements the basic support for raid5/6. I.e this works when
all the disks are present.

The next 5 patches, are preparatory ones.

The 7th patch implements the raid5 recovery for btrfs (i.e. handling the
disappearing of 1 disk).
The 8th patch makes the code for handling the raid6 recovery more generic.
The last one implements the raid6 recovery for btrfs (i.e. handling the
disappearing up to two disks).

I tested the code in grub-emu, and it works both with all the disks,
and with some disks missing. I checked the crc32 calculated from grub and
from linux and these matched. Finally I checked if the support for md raid6
still works properly, and it does (with all drives and with up to 2 drives
missing)

Comments are welcome.

Changelog
v1: initial support for btrfs raid5/6. No recovery allowed
v2: full support for btrfs raid5/6. Recovery allowed
v3: some minor cleanup suggested by Daniel Kiper; reusing the
    original raid6 recovery code of grub
v4: Several spell fix; better description of the RAID layout
    in btrfs, and the variables which describes the stripe
    positioning; split the patch #5 in two (#5 and #6)
v5: Several spell fix; improved code comment in patch #1, small
    clean up in the code
v6: Small cleanup; improved the wording in the RAID6 layout
    description; in the function raid6_recover_read_buffer() avoid
    a unnecessary memcpy in case of invalid data;
v7: - patch 2,3,5,6,8 received an Review-by Daniel, and were unchanged from
    the last time (only minor cleanup in the commit description requested by
    Daniel)
    - patch 7 received some small update rearranging a for(), and some
    bracket around if()
    - patch 4, received an update message which explains better why NULL
    is stored in data->devices_attached[]
    - patch 9, received a blank line to separate better a code line from
    a previous comment. A description of 'parities_pos' was added
    - patch 1, received a major update about the variable meaning description
    in the comment. However I suspect that we need some further review to reach
    a fully agreement about this text. NB: the update are relate only to comments

BR
G.Baroncelli

--
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
