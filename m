Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:57006 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbaETXjY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 19:39:24 -0400
Message-ID: <537BE7A4.5060508@zytor.com>
Date: Tue, 20 May 2014 16:39:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Formalizing the use of Boot Area B
References: <537403E3.6090902@zytor.com> <537BE54B.3060603@zytor.com> <537BE73F.7040307@fb.com>
In-Reply-To: <537BE73F.7040307@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/20/2014 04:37 PM, Chris Mason wrote:
> On 05/20/2014 07:29 PM, H. Peter Anvin wrote:
>> On 05/14/2014 05:01 PM, H. Peter Anvin wrote:
>>> It turns out that the primary 64K "Boot Area A" is too small for some
>>> applications and/or some architectures.
>>>
>>> When I discussed this with Chris Mason, he pointed out that the area
>>> beyond the superblock is also unused, up until at least the megabyte
>>> point (from my reading of the mkfs code, it is actually slightly more
>>> than a megabyte.)
>>>
>>> This is present in all versions of mkfs.btrfs that has the superblock at
>>> 64K (some very early ones had the superblock at 16K, but that format is
>>> no longer supported), so all that is needed is formalizing the specs as
>>> to the use of this area.
>>>
>>> My suggestion is that 64-128K is reserved for extension of the
>>> superblock and/or any other filesystem uses, and 128-1024K is defined as
>>> Boot Area B.  However, if there may be reason to reserve more, then we
>>> should do that.  Hence requesting a formal decision as to the extent and
>>> ownership of this area.
>>>
>>> 	-hpa
>>>
>>
>> Ping on this?  If I don't hear back on this I will probably just go
>> ahead and use 128K-1024K.
> 
> Hi Peter,
> 
> We do leave the first 1MB of each device alone.  Can we do 256K-1024K
> for the boot loader?  We don't have an immediate need for the extra
> space, but I'd like to reserve a little more than the extra 64KB.
> 

Works for me.  So 64-256K (192K) is reserved for the file system, and
Boot Area B is 256-1024K (768K).

	-hpa


