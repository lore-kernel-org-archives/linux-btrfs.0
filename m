Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw11a-andra.wadns.net ([41.185.62.155]:40016 "EHLO
	fw11a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752029AbbABRqK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jan 2015 12:46:10 -0500
Message-ID: <54A6D951.9080706@swiftspirit.co.za>
Date: Fri, 02 Jan 2015 19:45:53 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, ashford@whisperpc.com,
        Phillip Susi <psusi@ubuntu.com>
CC: Jose Manuel Perez Bethencourt <jmperezbeth@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        "sys.syphus" <syssyphus@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: I need to P. are we almost there yet?
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>    <CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>    <CAJCQCtR=Hinq_w6ELXFT-Ema-5THoz5EpuXkCOU_fE1gv--+qQ@mail.gmail.com>    <7e0d08fddb1e0060f756690f6c82c350.squirrel@webmail.wanet.net>    <54A31CAE.4020606@ubuntu.com>    <40b56c60ddd4801295a92c4b11d5c08e.squirrel@webmail.wanet.net>    <54A3633C.3040609@ubuntu.com> <1da0cf9a75a357c960af323aa56c7530.squirrel@webmail.wanet.net> <54A6A05D.6000200@gmail.com>
In-Reply-To: <54A6A05D.6000200@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/01/02 15:42, Austin S Hemmelgarn wrote:
> On 2014-12-31 12:27, ashford@whisperpc.com wrote:
>> I see this as a CRITICAL design flaw.  The reason for calling it 
>> CRITICAL
>> is that System Administrators have been trained for >20 years that 
>> RAID-10
>> can usually handle a dual-disk failure, but the BTRFS implementation has
>> effectively ZERO chance of doing so.
> No, some rather simple math
That's the problem. The math isn't as simple as you'd expect:

The example below is probably a pathological case - but here goes. Let's 
say in this 4-disk example that chunks are striped as d1,d2,d1,d2 where 
d1 is the first bit of data and d2 is the second:
Chunk 1 might be striped across disks A,B,C,D d1,d2,d1,d2
Chunk 2 might be striped across disks B,C,A,D d3,d4,d3,d4
Chunk 3 might be striped across disks D,A,C,B d5,d6,d5,d6
Chunk 4 might be striped across disks A,C,B,D d7,d8,d7,d8
Chunk 5 might be striped across disks A,C,D,B d9,d10,d9,d10

Lose any two disks and you have a 50% chance on *each* chunk to have 
lost that chunk. With traditional RAID10 you have a 50% chance of losing 
the array entirely. With btrfs, the more data you have stored, the 
chances get closer to 100% of losing *some* data in a 2-disk failure.

In the above example, losing A and B means you lose d3, d6, and d7 
(which ends up being 60% of all chunks).
Losing A and C means you lose d1 (20% of all chunks).
Losing A and D means you lose d9 (20% of all chunks).
Losing B and C means you lose d10 (20% of all chunks).
Losing B and D means you lose d2 (20% of all chunks).
Losing C and D means you lose d4,d5, AND d8 (60% of all chunks)

The above skewed example has an average of 40% of all chunks failed. As 
you add more data and randomise the allocation, this will approach 50% - 
BUT, the chances of losing *some* data is already clearly shown to be 
very close to 100%.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

