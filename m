Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49490 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755098AbaENNKo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 09:10:44 -0400
Message-ID: <53736BB6.30508@fb.com>
Date: Wed, 14 May 2014 09:12:22 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Liu Bo <bo.li.liu@oracle.com>,
        Zach Brown <zab@redhat.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] btrfs: fix inline compressed read err corruption
References: <1399590979-15331-1-git-send-email-zab@redhat.com> <1399590979-15331-3-git-send-email-zab@redhat.com> <20140512150022.GA15727@localhost.localdomain> <20140512171850.GG6917@twin.jikos.cz>
In-Reply-To: <20140512171850.GG6917@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/12/2014 01:18 PM, David Sterba wrote:
> On Mon, May 12, 2014 at 11:00:23PM +0800, Liu Bo wrote:
>> On Thu, May 08, 2014 at 07:16:19PM -0400, Zach Brown wrote:
>>> uncompress_inline() is silently dropping an error from
>>> btrfs_decompress() after testing it and zeroing the page that was
>>> supposed to hold decompressed data.  This can silently turn compressed
>>> inline data in to zeros if decompression fails due to corrupt compressed
>>> data or memory allocation failure.
>>>
>>> I have no idea why uncompress_inline() is zeroing the page for an error
>>> from btrfs_decompress() but not for the earlier ENOMEM from kmalloc().
>>> Can someone explain this?
>>
>> I guess that's because decompress() may have put part of real data on the page
>> and then bail out, and we don't want those data to be exposed to users in this
>> error case.
>>
>> And kmalloc() 's ENOMEM runs before that decompress(), page has whatever random
>> data.
> 
> But we don't return any data in case of error. In the unpatched code,
> there's no error so a zeroed page is returned, but this would not happen
> after Zach's fix.

I dug a little more, the zeroing goes all the way back to the original
compression code.  It looks like some paranoia of mine.

I'd say its fine to leave off as long as we don't mark the page uptodate.

-chris

