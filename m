Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:34499 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752377AbdFTW5W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 18:57:22 -0400
Received: from 68.79-160-168.customer.lyse.net ([79.160.168.68]:30402 helo=[10.0.0.10])
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <waxhead@dirtcellar.net>)
        id 1dNS5H-0003ez-Vk
        for linux-btrfs@vger.kernel.org; Wed, 21 Jun 2017 00:57:20 +0200
To: linux-btrfs@vger.kernel.org
Reply-To: waxhead@dirtcellar.net
From: waxhead <waxhead@dirtcellar.net>
Subject: Exactly what is wrong with RAID5/6
Message-ID: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
Date: Wed, 21 Jun 2017 00:57:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am trying to piece together the actual status of the RAID5/6 bit of BTRFS.
The wiki refer to kernel 3.19 which was released in February 2015 so I 
assume that the information there is a tad outdated (the last update on 
the wiki page was July 2016)
https://btrfs.wiki.kernel.org/index.php/RAID56

Now there are four problems listed

1. Parity may be inconsistent after a crash (the "write hole")
Is this still true, if yes - would not this apply for RAID1 / RAID10 as 
well? How was it solved there , and why can't that be done for RAID5/6

2. Parity data is not checksummed
Why is this a problem? Does it have to do with the design of BTRFS somehow?
Parity is after all just data, BTRFS does checksum data so what is the 
reason this is a problem?

3. No support for discard? (possibly -- needs confirmation with cmason)
Does this matter that much really?, is there an update on this?

4. The algorithm uses as many devices as are available: No support for a 
fixed-width stripe.
What is the plan for this one? There was patches on the mailing list by 
the SnapRAID author to support up to 6 parity devices. Will the (re?) 
resign of btrfs raid5/6 support a scheme that allows for multiple parity 
devices?

I do have a few other questions as well...

5. BTRFS does still (kernel 4.9) not seem to use the device ID to 
communicate with devices.

If you on a multi device filesystem yank out a device, for example 
/dev/sdg and it reappear as /dev/sdx for example btrfs will still 
happily try to write to /dev/sdg even if btrfs fi sh /mnt shows the 
correct device ID. What is the status for getting BTRFS to properly 
understand that a device is missing?

6. RAID1 needs to be able to make two copies always. E.g. if you have 
three disks you can loose one and it should still work. What about 
RAID10 ? If you have for example 6 disk RAID10 array, loose one disk and 
reboots (due to #5 above). Will RAID10 recognize that the array now is a 
5 disk array and stripe+mirror over 2 disks (or possibly 2.5 disks?) 
instead of 3? In other words, will it work as long as it can create a 
RAID10 profile that requires a minimum of four disks?
