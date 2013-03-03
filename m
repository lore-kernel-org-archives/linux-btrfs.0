Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:44111 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab3CCPoh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 10:44:37 -0500
Received: by mail-we0-f175.google.com with SMTP id x8so3803263wey.6
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Mar 2013 07:44:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130303152839.GC18135@shiny.masoncoding.com>
References: <CAOcd+r2p9AonnEwGZCS4CPUJ8O2EuQkSAA15twERY47FtrqLEw@mail.gmail.com>
	<20130303152839.GC18135@shiny.masoncoding.com>
Date: Sun, 3 Mar 2013 17:44:35 +0200
Message-ID: <CAOcd+r1EyuWm4xm3N-F2v82Uh9c+QCY1oO7ovfPL744OsxhPMA@mail.gmail.com>
Subject: Re: same EXTENT_ITEM appears twice in the extent tree
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On Sun, Mar 3, 2013 at 5:28 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> On Sun, Mar 03, 2013 at 06:40:50AM -0700, Alex Lyakas wrote:
>> Greetings all,
>> I have an extent tree that looks like follows:
>>
>>       item 22 key (27059916800 EXTENT_ITEM 16384) itemoff 2656 itemsize 24
>>               extent refs 1 gen 164 flags 1
>>       item 23 key (27059916800 EXTENT_ITEM 98304) itemoff 2603 itemsize 53
>>               extent refs 1 gen 165 flags 1
>>               extent data backref root 257 objectid 257 offset 17446191104 count 1
>>       item 24 key (27059916800 SHARED_DATA_REF 47169536) itemoff 2599 itemsize 4
>>               shared data backref count 1
>
> Have you been experimenting on this FS with snapshot deletion patches?

No, I haven't applied any patches on top of the commit I mentioned. (I
presume you mean David's patch for one-by-one deletion). Since
created, this FS has only seen straight IO with parallel snapshot
creation and deletion. However, the kernel was crashing pretty
frequently during this test, so I presume log replay was taking place.

Any particular thing I can look for in the debug-tree output, except
searching for more double-allocations?

Thanks,
Alex.


>
> -chris
