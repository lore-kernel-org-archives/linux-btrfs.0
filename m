Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47050 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab2KCM1Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2012 08:27:24 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1677945eaa.19
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Nov 2012 05:27:23 -0700 (PDT)
Message-ID: <50950DDC.8060402@gmail.com>
Date: Sat, 03 Nov 2012 13:28:12 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Gabriel <g2p.code@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH][BTRFS-PROGS] Enhance btrfs fi df
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it> <201211021218.29778.Martin@lichtvoll.de> <5093B658.3000007@gmail.com> <k715i0$7go$1@ger.gmane.org> <20121102220604.GC28864@carfax.org.uk> <k71kl2$7go$3@ger.gmane.org> <20121102234419.GD28864@carfax.org.uk>
In-Reply-To: <20121102234419.GD28864@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/03/2012 12:44 AM, Hugo Mills wrote:
> 1 MiB stored in RAID-5 across 3 devices takes up 1.5 MiB -- multiplier ×1.5
>    (1 MiB over 2 devices is 512 KiB, plus an additional 512 KiB for parity)
> 1 MiB stored in RAID-5 across 6 devices takes up 1.2 MiB -- multipler ×1.2
>    (1 MiB over 5 devices is 204.8 KiB, plus an additional 204.8 KiB for parity)
> 
>    With the (initial) proposed implementation of RAID-5, the
> stripe-width (i.e. the number of devices used for any given chunk
> allocation) will be *as many as can be allocated*. Chris confirmed
> this today on IRC. So if I have a disk array of 2T, 2T, 2T, 1T, 1T,
> 1T, then the first 1T of allocation will stripe across 6 devices,


Interesting.
Let me simulate a possible output


> ./btrfs filesystem disk-usage -t /
          Data    Metadata Metadata    System System
          RAID5   Single   DUP         Single DUP     Unallocated

/dev/dm-0  1.50TB   8.00MB           - 4.00MB 16.00MB    500.00MB
/dev/dm-1  1.50TB        -           - 4.00MB 16.00MB    500.00MB
/dev/dm-2  1.50TB        -           - 4.00MB       -    500.00MB
/dev/dm-3  1.00TB        - 2x 100.00MB 4.00MB       -    300.00MB
/dev/dm-4  1.00TB        - 2x 100.00MB 4.00MB       -    300.00MB
          ======= ======== =========== ====== ======= ===========
Total      5.00TB   8.00MB    200.00MB 4.00MB  8.00MB      2.10TB
Used      10.65GB     0.00     50.00MB   0.00  4.00KB


Would be it clear ? And what if we move the Total/used below the header ?

> ./btrfs filesystem disk-usage -t /
          Data    Metadata Metadata    System System
          RAID5   Single   DUP         Single DUP     Unallocated

Total      5.00TB   8.00MB    200.00MB 4.00MB  8.00MB      2.10TB
Used      10.65GB     0.00     50.00MB   0.00  4.00KB
          ======= ======== =========== ====== ======= ===========
/dev/dm-0  1.50TB   8.00MB           - 4.00MB 16.00MB    500.00MB
/dev/dm-1  1.50TB        -           - 4.00MB 16.00MB    500.00MB
/dev/dm-2  1.50TB        -           - 4.00MB       -    500.00MB
/dev/dm-3  1.00TB        - 2x 100.00MB 4.00MB       -    300.00MB
/dev/dm-4  1.00TB        - 2x 100.00MB 4.00MB       -    300.00MB




GB

P.S:
The raid5 is composed by (4+1) x 1T and (2+1) x 0.5TB, supposing the
disks as 2x 1.5TB and 3x2Tb.


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
