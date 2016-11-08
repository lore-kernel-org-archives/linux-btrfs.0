Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:37086 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932873AbcKHREU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 12:04:20 -0500
Received: by mail-it0-f48.google.com with SMTP id u205so219790673itc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Nov 2016 09:04:20 -0800 (PST)
Subject: Re: Announcing btrfs-dedupe
To: "Darrick J. Wong" <darrick.wong@oracle.com>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <20161107140200.GM12522@suse.cz> <1478572812.28957.4.camel@scientia.net>
 <d32c6f44-970f-615d-cb01-6ef48cd8d1f6@gmail.com>
 <20161108165706.GB16801@birch.djwong.org>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>, dsterba@suse.cz,
        James Pharaoh <james@wellbehavedsoftware.com>,
        linux-btrfs@vger.kernel.org, mark@fasheh.com
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ec4e9e7a-6c85-b4a7-4ae1-e54b94ec0db3@gmail.com>
Date: Tue, 8 Nov 2016 12:04:16 -0500
MIME-Version: 1.0
In-Reply-To: <20161108165706.GB16801@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-08 11:57, Darrick J. Wong wrote:
> On Tue, Nov 08, 2016 at 08:26:02AM -0500, Austin S. Hemmelgarn wrote:
>> On 2016-11-07 21:40, Christoph Anton Mitterer wrote:
>>> On Mon, 2016-11-07 at 15:02 +0100, David Sterba wrote:
>>>> I think adding a whole-file dedup mode to duperemove would be better
>>>> (from user's POV) than writing a whole new tool
>>>
>>> What would IMO be really good from a user's POV was, if one of the
>>> tools, deemed to be the "best", would be added to the btrfs-progs and
>>> simply become "the official" one.
>>
>> The problem is that for deduplication, most tools won't work well for
>> everything.  For example the cases I use it in are very specific and have
>> horrible performance using pretty much any available tool (I have a couple
>> cases where I have disjoint subsets of the same directory tree with
>> different prefixes, so I can tell exactly which files are duplicated, and
>> that any duplicate file is 100% duplicate, as well as a couple of cases
>> where changes are small, scattered, and highly predictable (and thus it's
>> easier to find what's changed and dedupe everything else instead of finding
>> what's the same), and none of the existing options do well in either
>> situation).
>>
>> I'd argue at minimum for having the extent-same tool from duperemove in
>> btrfs-progs, as that lets people do deduplication how they want without
>> having to write C code.  Something equivalent that would let you call any
>> BTRFS ioctl with (reasonably) arbitrary arguments might actually be even
>> better (I can see such a tool being wonderful for debugging).
>
> Since xfsprogs 4.3, xfs_io has a 'dedupe' command that can talk to
> FIDEDUPERANGE (f.k.a. EXTENT SAME):
>
> $ xfs_io -c '/mnt/srcfile srcoffset dstoffset length' /mnt/destfile
>
I actually hadn't known about this, thanks.  It means that xfs_io just 
got even more useful despite me not running XFS.

