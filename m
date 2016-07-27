Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i5.italiaonline.it ([212.48.25.234]:60738 "EHLO
	libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757121AbcG0QZw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jul 2016 12:25:52 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH] btrfs-progs: Make RAID stripesize configurable
References: <1469194929-27647-1-git-send-email-lkml.page@gmail.com>
 <f7de852d-86de-b438-e79f-c57666c7d0e4@gmail.com>
 <CAJCQCtTFGMku4FJZN7oH4=UV+F+Tz_FLD7RbUE5JWgaQKFtH4A@mail.gmail.com>
 <20160727021233.7e10ee48@ad>
To: Sanidhya Solanki <lkml.page@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <e0eb3366-7183-59b1-7cdc-3debd4e45b79@inwind.it>
Date: Wed, 27 Jul 2016 18:25:48 +0200
MIME-Version: 1.0
In-Reply-To: <20160727021233.7e10ee48@ad>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Sanidhya,

On 2016-07-27 08:12, Sanidhya Solanki wrote:
> The reason for this limit is the fact that, as I noted above the real 
> stripe size is currently 4KiB, with an element size of 64KiB. 


I am not able to understand this sentence: on the best of my knowledge,
in btrfs the RAID5/RAID6 stripe is composed by several sub-stripes (I am
not sure about the terminology to adopt); the number of sub-stripe is equal 
to the number of the disk.

Until now, in btrfs the size of sub-stripe is fixed to 64k, so the size
of a stripe is equal to 64k * <number of disks>. So for raid5 the minimum
stripe size is 192k, for raid6 is 256k.

Why you are writing that the real stripe size is 4kb (may be that you are
referring to the be the page size ?).

I am quite sure that the problem is the terminology. Could you be so kindly 
to explain what you are meaning ?

Thanks in advance.
BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
