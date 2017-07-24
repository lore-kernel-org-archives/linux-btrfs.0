Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:33593 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751558AbdGXLXp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 07:23:45 -0400
Received: by mail-it0-f65.google.com with SMTP id t6so7396243itb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 04:23:45 -0700 (PDT)
Subject: Re: [PATCH] Btrfs: Do not use data_alloc_cluster in ssd mode
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <20170721114711.20229-1-hans.van.kranenburg@mendix.com>
 <413a6ddf-b71d-678f-3c6b-a6aab6937226@gmail.com>
 <ac54b35e-d5f0-6da2-bd55-117005ba2588@mendix.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e2319f41-3862-fc36-cbf3-49e0ace541cf@gmail.com>
Date: Mon, 24 Jul 2017 07:23:38 -0400
MIME-Version: 1.0
In-Reply-To: <ac54b35e-d5f0-6da2-bd55-117005ba2588@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-07-21 19:21, Hans van Kranenburg wrote:
> On 07/21/2017 05:50 PM, Austin S. Hemmelgarn wrote:
>> On 2017-07-21 07:47, Hans van Kranenburg wrote:
>>> [...]
>>>
>>> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
>> Behaves as advertised, and I'm not seeing any issues in my testing (and
>> I can confirm from experience that this logic slows things down, I've
>> been forcing '-o nossd' on my systems for a while now for the
>> performance improvement), so you can add:
>> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
> 
> Thanks for testing!
> 
> Would you mind sharing a bit about what kind of test this is, and how
> you measure the difference?
> 
> Does it mean that you're throwing a lot of data at the disk, and that
> you can measure that 'cluster' mode of figuring out where to put the
> writes has to spend more effort than the 'tetris' mode, and that it
> limits the write speed?
> 
> The only relevant difference I was aware of until now is just the
> placement of the writes.
> 

For the generic testing, I've got a (mostly) automated testing system
setup on my home server that builds a kernel with the patches applied
and then runs xfstests and a handful of other tests I've got myself
(I really need to get around to pushing those upstream...).  At the
moment, it tests using 32 and 64-bit x86, ARMv7a, ARMv6stj-z, ARMv8
(whatever QEMU's default revision is), PPC64 (big and little endian),
and 32-bit MIPS (new ABI only, also big and little endian).

For the specific case here, back when I set up my systems to use 'nossd'
3 months ago, I specifically set up two of them that are otherwise
identical to test if there was any difference.  The systems in question
are a pair of Intel NUC's with Pentium N3700 CPU's (4 cores, no HT, 1.6GHz
normal, 2.4GHz boost), 4G of DDR3L-1600 RAM, and a 250GB Crucial MX200 SSD.
After 3 months, the one which has run with 'nossd' set in the mount options
is getting roughly 1-3% better write performance, equivalent read performance
(both measured with fio and iozone), and completes discard operations almost
twice as fast (based on timing `fstrim` with the same amount of space free on
both filesystems).
