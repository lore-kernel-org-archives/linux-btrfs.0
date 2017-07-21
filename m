Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:56210 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753111AbdGUXVE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 19:21:04 -0400
Subject: Re: [PATCH] Btrfs: Do not use data_alloc_cluster in ssd mode
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <20170721114711.20229-1-hans.van.kranenburg@mendix.com>
 <413a6ddf-b71d-678f-3c6b-a6aab6937226@gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <ac54b35e-d5f0-6da2-bd55-117005ba2588@mendix.com>
Date: Sat, 22 Jul 2017 01:21:03 +0200
MIME-Version: 1.0
In-Reply-To: <413a6ddf-b71d-678f-3c6b-a6aab6937226@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/21/2017 05:50 PM, Austin S. Hemmelgarn wrote:
> On 2017-07-21 07:47, Hans van Kranenburg wrote:
>> [...]
>>
>> Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
> Behaves as advertised, and I'm not seeing any issues in my testing (and
> I can confirm from experience that this logic slows things down, I've
> been forcing '-o nossd' on my systems for a while now for the
> performance improvement), so you can add:
> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>

Thanks for testing!

Would you mind sharing a bit about what kind of test this is, and how
you measure the difference?

Does it mean that you're throwing a lot of data at the disk, and that
you can measure that 'cluster' mode of figuring out where to put the
writes has to spend more effort than the 'tetris' mode, and that it
limits the write speed?

The only relevant difference I was aware of until now is just the
placement of the writes.

-- 
Hans van Kranenburg
