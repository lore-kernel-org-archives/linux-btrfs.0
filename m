Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55976 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751156AbdGOKfW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Jul 2017 06:35:22 -0400
Subject: Re: [PATCH] Btrfs: fix early ENOSPC due to delalloc
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        kernel-team@fb.com
References: <0cf8577381f6ebe99b584ca60f920c630000c343.1499407060.git.osandov@fb.com>
 <20170714213645.GC13690@vader.DHCP.thefacebook.com>
 <1b7c8283-b585-27c4-6b95-12e889b3b96f@suse.com>
 <20170715070942.GA10038@vader>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <65d606fc-75bd-39f0-c81d-1aec4be4f13f@suse.com>
Date: Sat, 15 Jul 2017 13:35:19 +0300
MIME-Version: 1.0
In-Reply-To: <20170715070942.GA10038@vader>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 15.07.2017 10:09, Omar Sandoval wrote:
> On Sat, Jul 15, 2017 at 09:43:18AM +0300, Nikolay Borisov wrote:
>>
>>
>> On 15.07.2017 00:36, Omar Sandoval wrote:
>>> On Thu, Jul 06, 2017 at 10:59:27PM -0700, Omar Sandoval wrote:
>>>> From: Omar Sandoval <osandov@fb.com>
>>>>
>>>> If a lot of metadata is reserved for outstanding delayed allocations, we
>>>> rely on shrink_delalloc() to reclaim metadata space in order to fulfill
>>>> reservation tickets. However, shrink_delalloc() has a shortcut where if
>>>> it determines that space can be overcommitted, it will stop early. This
>>>> made sense before the ticketed enospc system, but now it means that
>>>> shrink_delalloc() will often not reclaim enough space to fulfill any
>>>> tickets, leading to an early ENOSPC. (Reservation tickets don't care
>>>> about being able to overcommit, they need every byte accounted for.)
>>>>
>>>> Fix it by getting rid of the shortcut so that shrink_delalloc() reclaims
>>>> all of the metadata it is supposed to. This fixes early ENOSPCs we were
>>>> seeing when doing a btrfs receive to populate a new filesystem.
>>>
>>> Jeff, Nikolay, did either of you get a chance to test this yet?
>>
>> I tested this patch with generic/273 and it didn't prevent ENOSPC there.
> 
> Weird, I've never seen generic/273 fail. Anyways, I'm more interested in
> the installer ENOSPCs Jeff mentioned.

It's failing even on current upstream kernels with premature ENOSPC.

> 
