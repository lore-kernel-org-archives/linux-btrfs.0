Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46735 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2FEQFK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 12:05:10 -0400
Received: by obbtb18 with SMTP id tb18so8928786obb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jun 2012 09:05:10 -0700 (PDT)
Message-ID: <4FCE2E33.6090209@webstarts.com>
Date: Tue, 05 Jun 2012 12:05:07 -0400
From: Jim <jim@webstarts.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: delete disk proceedure
References: <4FCE19D3.4090908@webstarts.com> <20120605154737.GH15986@carfax.org.uk> <4FCE2B70.9020107@webstarts.com> <20120605160019.GI15986@carfax.org.uk>
In-Reply-To: <20120605160019.GI15986@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[resent after getting rid of the damn signature]
Sorry I missed the list last time, I hit reply too fast.  Yes, this 
sounds like a good idea.  I will try it and let you know.
Jim Maloney

On 06/05/2012 12:00 PM, Hugo Mills wrote:
> [Please keep replies on the list]
>
> On Tue, Jun 05, 2012 at 11:53:20AM -0400, Jim wrote:
>> Thanks for the response.  When I say mounts don't work I mean that
>> when I try to mount an exported directory on an older os (most of my
>> machines are centos 5.7) with a non btrfs kernel I get an "unknown
>> filesystem" error.  If we can get around this I would be very happy.
>     On my NFS exports, I found that I have to set the fsid to something
> unique for each subvolume I export. In my case, this prevents all of
> the exported filesystems being the same, but it might also help with
> your problem.
>
> /media/video			  *(ro,async,fsid=0x13570,no_subtree_check)
>
>     Hugo.
>
>> On 06/05/2012 11:47 AM, Hugo Mills wrote:
>>> On Tue, Jun 05, 2012 at 10:38:11AM -0400, Jim wrote:
>>>> Good morning btrfs list,
>>>> I had written about 2 weeks ago about using extra btrfs space in an
>>>> nfs file system setup.  Nfs seems to export the files but the mounts
>>>> don't work on older machines without btrfs kernels.
>>>     "The mounts don't work" -- can you be more specific here?
>>>
>>>     It would seem that if we can get to the bottom of that problem, you
>>> won't have to muck around with your current set-up at all.
>>>
>>>     Hugo.
>>>

-
