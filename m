Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:32841 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbcCDMbI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Mar 2016 07:31:08 -0500
Received: by mail-qg0-f53.google.com with SMTP id t4so41728757qge.0
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Mar 2016 04:31:08 -0800 (PST)
Subject: Re: [RFC] Experimental btrfs encryption
To: Anand Jain <anand.jain@oracle.com>, Chris Mason <clm@fb.com>,
        Christoph Hellwig <hch@infradead.org>,
        Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
 <20160301162952.GB718307@mother.pipebreaker.pl>
 <20160301164616.dbbeuzccfkzupign@floor.thefacebook.com>
 <20160301175927.GA32354@infradead.org>
 <20160301182312.fdl264cxemz2fy5m@floor.thefacebook.com>
 <56D67087.7040702@oracle.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56D97FC8.3020800@gmail.com>
Date: Fri, 4 Mar 2016 07:30:00 -0500
MIME-Version: 1.0
In-Reply-To: <56D67087.7040702@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-01 23:48, Anand Jain wrote:
>
>
>
> On 03/02/2016 02:23 AM, Chris Mason wrote:
>> On Tue, Mar 01, 2016 at 09:59:27AM -0800, Christoph Hellwig wrote:
>>> On Tue, Mar 01, 2016 at 11:46:16AM -0500, Chris Mason wrote:
>>>> We'll definitely move in line with the common API over time.  Thanks
>>>> Anand for starting this!
>>>>
>>>> I'd prefer that we keep it per-subvolume for now, just because
>>>> subvolumes are so cheap and because it seems like a better collection
>>>> point for general use.  But as the other filesystems add features we'll
>>>> make sure and keep parity with what users expect.
>>>
>>> We already have per-file encryption in f2fs and ext4, and both have
>>> a compatible userspace API and ABI.  It would be a pitty to deviate
>>> from that intead of reusing it, and if needed extending it.
>>
>> I wasn't very clear here sorry.  per-subvolume is my favorite way, but
>> we'll go with the existing ABIs as well.  There's no reason to be
>> different.
>
>
> Thanks for commenting.
>
> btrfs encryption creates attributes per file its named
>
>    btrfs.encrypt
>
> But when we have a standard attribute for file encryption
> this should be updated.
>
> I wrote a design approaches/principles on which btrfs encryption
> is based on.. and it here
>
> https://docs.google.com/document/d/1fq9snDM_4ikn44UDNErjHqKXgZHukiJWS4Il3qVhm3M/edit?usp=sharing

FWIW, a new version of the patch series pushing the ext4/F2FS API up to 
the VFS layer got posted on LKML just the other day.  Based on the level 
of review, it looks like it may end up in 4.6.

