Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19290 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755461AbcKWC5w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 21:57:52 -0500
Subject: Re: [PATCH v2 0/5] Make btrfs-progs really compatible with any kernel
 version
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <824aa945-fd1f-45a2-9123-2bd810f464d6@oracle.com>
 <20161114121335.GJ12522@suse.cz>
 <426cb2c7-b947-63d1-a8c4-8a575268377f@oracle.com>
 <20161122131631.GM12522@suse.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <cd34fe14-0fc0-9c31-ee8a-2096585f7b61@oracle.com>
Date: Wed, 23 Nov 2016 11:00:49 +0800
MIME-Version: 1.0
In-Reply-To: <20161122131631.GM12522@suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/22/16 21:16, David Sterba wrote:
> On Tue, Nov 22, 2016 at 04:54:58PM +0800, Anand Jain wrote:
>> On 11/14/16 20:13, David Sterba wrote:
>>> On Tue, Nov 08, 2016 at 09:14:39PM +0800, Anand Jain wrote:
>>>>   This patch isn't integrated, any idea why ?
>>>
>>> Because it does not cover all usecases.
>>
>>     You have stated one of the use case here
>>      https://www.spinics.net/lists/linux-btrfs/msg49391.html
>>
>>     which I have it implemented in these patches
>>       [PATCH 5/7] btrfs-progs: introduce framework version to features
>>       [PATCH 6/7] btrfs-progs: add -O comp= option for mkfs.btrfs
>>       [PATCH 7/7] btrfs-progs: add -O comp= option for btrfs-convert
>>
>>     was their more ?
>
> Yeah, it turned out there's more.
>
>>> I've committed the preparatory
>>> bits from branch where I've been working on that feature so we can
>>> actually get to the hard parts.
>>
>>   these patch set is a year old as well. are you planning to drop
>>   these patches ? the clarity is missing. IMO.
>
> Preparatory bits are in patches:
>
>   btrfs-progs: mkfs: add names of matching sysfs feature names
>   btrfs-progs: mkfs: enhance feature table
>   btrfs-progs: mkfs: extend mkfs features with compat, safe and default versions

  I don't seen these patches in the ML. Looks like it was integrated
  in 4.8.3.

> the core work is not yet done.
>
> The original usecase has been extended to allow for selecting features
> that are compatible, ie. can be mounted, safe, ie. are ok wrt The
> Status page, and default, ie. automatically selected by mkfs.

> Additionally to
> that, a system-wide preset from a config file in /etc.


  Certainly these patches could have been on (cleanup/enhancement)
  top of my patches which was sent a year back.



Thanks. Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
