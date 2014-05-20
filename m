Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw8a-gabriella.wadns.net ([196.220.39.91]:8339 "EHLO
	fw8a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750721AbaETUL3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 16:11:29 -0400
Message-ID: <537BB6E4.2020508@swiftspirit.co.za>
Date: Tue, 20 May 2014 22:11:16 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, russell@coker.com.au,
        linux-btrfs@vger.kernel.org
Subject: Re: ditto blocks on ZFS
References: <2308735.51F3c4eZQ7@xev> <lldpvm$s7c$1@ger.gmane.org> <537A7BF9.5060508@swiftspirit.co.za> <4483661.BdmCOR8JR5@xev> <537B6190.2030100@gmail.com>
In-Reply-To: <537B6190.2030100@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/05/20 04:07 PM, Austin S Hemmelgarn wrote:
> On 2014-05-19 22:07, Russell Coker wrote:
>> [snip]
>> As an aside, I'd really like to be able to set RAID levels by subtree.  I'd
>> like to use RAID-1 with ditto blocks for my important data and RAID-0 for
>> unimportant data.
>>
> But the proposed changes for n-way replication would already handle
> this.
> [snip]
>
Russell's specific request above is probably best handled by being able 
to change replication levels per subvolume - this won't be handled by 
N-way replication.

Extra replication on leaf nodes will make relatively little difference 
in the scenarios laid out in this thread - but on "trunk" nodes (folders 
or subvolumes closer to the filesystem root) it makes a significant 
difference. "Plain" N-way replication doesn't flexibly treat these two 
nodes differently.

As an example, Russell might have a server with two disks - yet he wants 
6 copies of all metadata for subvolumes and their immediate subfolders. 
At three folders deep he "only" wants to have 4 copies. At six folders 
deep, only 2. Ditto blocks add an attractive safety net without 
unnecessarily doubling or tripling the size of *all* metadata.

It is a good idea. The next question to me is whether or not it is 
something that can be implemented elegantly and whether or not a 
talented *dev* thinks it is a good idea.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

