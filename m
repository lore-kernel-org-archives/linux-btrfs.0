Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:34367 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaCIS4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Mar 2014 14:56:04 -0400
Received: by mail-vc0-f175.google.com with SMTP id lh14so4112009vcb.6
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Mar 2014 11:56:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <531CA6A6.4040701@gmail.com>
References: <531C1CC4.701@gmail.com> <1553599.dDs6U900Vh@tethys> <531CA6A6.4040701@gmail.com>
From: Tobias Holst <tobby@tobby.eu>
Date: Sun, 9 Mar 2014 19:55:43 +0100
Message-ID: <CAGwxe4iEQqE_QYYnXE7G484pGA8r3Nvco-PLupyB+vXX2PO_TA@mail.gmail.com>
Subject: Re: Massive BTRFS performance degradation
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org, impactoria@googlemail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-03-09 18:36 GMT+01:00 Austin S Hemmelgarn <ahferroin7@gmail.com>:
> On 03/09/2014 04:17 AM, Swâmi Petaramesh wrote:
>> Le dimanche 9 mars 2014 08:48:20 KC a écrit :
>>> I am experiencing massive performance degradation on my BTRFS
>>> root partition on SSD.
>>
>> BTW, is BTRFS still a SSD-killer ? It had this reputation a while
>> ago, and I'm not sure if this still is the case, but I don't dare
>> (yet) converting to BTRFS one of my laptops that has a SSD...
>>
> Actually, because of the COW nature of BTRFS, it should be better for
> SSD's than stuff like ext4 (which DOES kill SSD's when journaling is
> enabled because it ends up doing thousands of read-modify-write cycles
> to the same 128k of the disk under just generic usage).  Just make
> sure that you use the 'ssd' and 'discard' mount options.

Every modern SSD does "Wear Leveling". Doing a read-modify-write cycle
on the same block doesn't mean it writes to the same memory cell. The
SSD-controller distributes the write-cycles over all (empty) cells. So
in best-case every cell in the SSD is used equally, no matter of doing
random writes or writing the same block over and over. This works
better with lots of empty space on the SSD, that's why you should
never use more than 90% of the space on a SSD. Garbage collection and
TRIM also help the SSD-controller to find empty cells.
