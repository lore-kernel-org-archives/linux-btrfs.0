Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59911 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbeHQMKx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 08:10:53 -0400
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id 2B43D38EE79
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Aug 2018 11:08:15 +0200 (CEST)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Experiences on BTRFS Dual SSD RAID 1 with outage of one SSD
Date: Fri, 17 Aug 2018 11:08:14 +0200
Message-ID: <2331408.nK7QgfhVWv@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

This happened about two weeks ago. I already dealt with it and all is 
well.

Linux hung on suspend so I switched off this ThinkPad T520 forcefully. 
After that it did not boot the operating system anymore. Intel SSD 320, 
latest firmware, which should patch this bug, but apparently does not, 
is only 8 MiB big. Those 8 MiB just contain zeros.

Access via GRML and "mount -fo degraded" worked. I initially was even 
able to write onto this degraded filesystem. First I copied all data to 
a backup drive.

I even started a balance to "single" so that it would work with one SSD.

But later I learned that secure erase may recover the Intel SSD 320 and 
since I had no other SSD at hand, did that. And yes, it did. So I 
canceled the balance.

I partitioned the Intel SSD 320 and put LVM on it, just as I had it. But 
at that time I was not able to mount the degraded BTRFS on the other SSD 
as writable anymore, not even with "-f" "I know what I am doing". Thus I 
was not able to add a device to it and btrfs balance it to RAID 1. Even 
"btrfs replace" was not working.

I thus formatted a new BTRFS RAID 1 and restored.

A week later I migrated the Intel SSD 320 to a Samsung 860 Pro. Again 
via one full backup and restore cycle. However, this time I was able to 
copy most of the data of the Intel SSD 320 with "mount -fo degraded" via 
eSATA and thus the copy operation was way faster.

So conclusion:

1. Pro: BTRFS RAID 1 really protected my data against a complete SSD 
outage.

2. Con:  It does not allow me to add a device and balance to RAID 1 or 
replace one device that is already missing at this time.

3. I keep using BTRFS RAID 1 on two SSDs for often changed, critical 
data.

4. And yes, I know it does not replace a backup. As it was holidays and 
I was lazy backup was two weeks old already, so I was happy to have all 
my data still on the other SSD.

5. The error messages in kernel when mounting without "-o degraded" are 
less than helpful. They indicate a corrupted filesystem instead of just 
telling that one device is missing and "-o degraded" would help here.


I have seen a discussion about the limitation in point 2. That allowing 
to add a device and make it into RAID 1 again might be dangerous, cause 
of system chunk and probably other reasons. I did not completely read 
and understand it tough.

So I still don´t get it, cause:

Either it is a RAID 1, then, one disk may fail and I still have *all* 
data. Also for the system chunk, which according to btrfs fi df / btrfs 
fi sh was indeed RAID 1. If so, then period. Then I don´t see why it 
would need to disallow me to make it into an RAID 1 again after one 
device has been lost.

Or it is no RAID 1 and then what is the point to begin with? As I was 
able to copy of all date of the degraded mount, I´d say it was a RAID 1.

(I know that BTRFS RAID 1 is not a regular RAID 1 anyway, but just does 
two copies regardless of how many drives you use.)


For this laptop it was not all that important but I wonder about BTRFS 
RAID 1 in enterprise environment, cause restoring from backup adds a 
significantly higher downtime.

Anyway, creating a new filesystem may have been better here anyway, 
cause it replaced an BTRFS that aged over several years with a new one. 
Due to the increased capacity and due to me thinking that Samsung 860 
Pro compresses itself, I removed LZO compression. This would also give 
larger extents on files that are not fragmented or only slightly 
fragmented. I think that Intel SSD 320 did not compress, but Crucial 
m500 mSATA SSD does. That has been the secondary SSD that still had all 
the data after the outage of the Intel SSD 320.


Overall I am happy, cause BTRFS RAID 1 gave me access to the data after 
the SSD outage. That is the most important thing about it for me.

Thanks,
-- 
Martin
