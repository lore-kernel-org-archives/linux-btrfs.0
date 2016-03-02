Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31497 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbcCBEso (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 23:48:44 -0500
Subject: Re: [RFC] Experimental btrfs encryption
To: Chris Mason <clm@fb.com>, Christoph Hellwig <hch@infradead.org>,
        Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
 <20160301162952.GB718307@mother.pipebreaker.pl>
 <20160301164616.dbbeuzccfkzupign@floor.thefacebook.com>
 <20160301175927.GA32354@infradead.org>
 <20160301182312.fdl264cxemz2fy5m@floor.thefacebook.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56D67087.7040702@oracle.com>
Date: Wed, 2 Mar 2016 12:48:07 +0800
MIME-Version: 1.0
In-Reply-To: <20160301182312.fdl264cxemz2fy5m@floor.thefacebook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 03/02/2016 02:23 AM, Chris Mason wrote:
> On Tue, Mar 01, 2016 at 09:59:27AM -0800, Christoph Hellwig wrote:
>> On Tue, Mar 01, 2016 at 11:46:16AM -0500, Chris Mason wrote:
>>> We'll definitely move in line with the common API over time.  Thanks
>>> Anand for starting this!
>>>
>>> I'd prefer that we keep it per-subvolume for now, just because
>>> subvolumes are so cheap and because it seems like a better collection
>>> point for general use.  But as the other filesystems add features we'll
>>> make sure and keep parity with what users expect.
>>
>> We already have per-file encryption in f2fs and ext4, and both have
>> a compatible userspace API and ABI.  It would be a pitty to deviate
>> from that intead of reusing it, and if needed extending it.
>
> I wasn't very clear here sorry.  per-subvolume is my favorite way, but
> we'll go with the existing ABIs as well.  There's no reason to be
> different.


Thanks for commenting.

btrfs encryption creates attributes per file its named

   btrfs.encrypt

But when we have a standard attribute for file encryption
this should be updated.

I wrote a design approaches/principles on which btrfs encryption
is based on.. and it here

https://docs.google.com/document/d/1fq9snDM_4ikn44UDNErjHqKXgZHukiJWS4Il3qVhm3M/edit?usp=sharing

for your kind review.


Thanks! Anand

