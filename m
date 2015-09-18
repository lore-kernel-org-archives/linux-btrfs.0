Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:32998 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbbIRTpH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Sep 2015 15:45:07 -0400
Received: by wiclk2 with SMTP id lk2so77287140wic.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 12:45:06 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 18 Sep 2015 20:45:06 +0100
Message-ID: <CANfzhCbyeAO+VUQG1znkMck9+vggO6a_GXYasjcOA4tO0sOE0g@mail.gmail.com>
Subject: btrfs file usage output incorrect for RAID10?
From: Derek Dongray <derek@valedon.co.uk>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a 5 disk array (1x2Tb + 4x3Tb). Previously, this was formatted
as RAID1, but I've been converting it to RAID10. As the conversion has
progressed, I've noticed that the Unallocated figure for each device
has slowly increaed, while the Overall "Device unallocated" and "Free
(estimated)" figures have remained fairly constant (as expected).

At just over 50% through the conversion, the output of 'btrfs file
usage -Tg /home' shows:

Overall:
    Device size:       13041.10GiB
    Device allocated:       12867.46GiB
    Device unallocated:         173.64GiB
    Device missing:           0.00GiB
    Used:       12558.29GiB
    Free (estimated):         240.19GiB (min: 240.19GiB)
    Data ratio:              2.00
    Metadata ratio:              2.00
    Global reserve:           0.50GiB (used: 0.09GiB)

                 Data       Data       Metadata Metadata System
         single  RAID1      RAID10     RAID1    RAID10   RAID1   Unallocated

/dev/sdb       -   15.00GiB  864.48GiB        -  2.75GiB       -   980.79GiB
/dev/sdc       - 1364.00GiB  707.70GiB  2.00GiB  2.50GiB 0.03GiB   718.29GiB
/dev/sdd       - 1359.00GiB  712.07GiB  1.00GiB  1.50GiB       -   720.95GiB
/dev/sde       -  905.00GiB  929.19GiB        -  2.75GiB 0.03GiB   957.55GiB
/dev/sdg       - 1311.00GiB  730.25GiB  1.00GiB  1.50GiB       -   750.77GiB
         ======= ========== ========== ======== ======== ======= ===========
Total    0.50GiB 2477.00GiB 3943.70GiB  2.00GiB 11.00GiB 0.03GiB  4128.34GiB
Used     0.09GiB 2476.35GiB 3790.98GiB  0.96GiB 10.85GiB 0.00GiB

My suspicion is that the 'data' size for RAID10 is showing the
allocation for only one copy of the data, rather than the 2 for RAID1,
and that the 'Unallocated' size, presumably calculated by subtracting
the size of the data and metadata from the total size of the disk, is
therefore incorrect.

Can someone familiar with the source code of btrfs-progs confirm if
this is correct or, if the figures are correct, my RAID1 is actually
being converted to RAID0!

Thanks

-- 
Derek
