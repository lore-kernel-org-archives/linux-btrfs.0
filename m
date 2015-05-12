Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51850 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbELEDK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 00:03:10 -0400
Message-ID: <55517ADC.6000300@oracle.com>
Date: Tue, 12 May 2015 12:00:28 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8] Introduce offline fsid/chunk tree uuid change for
 btrfstune.
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com> <20150505152055.GH5099@twin.jikos.cz> <5549651D.6020005@cn.fujitsu.com> <20150506154347.GC23255@twin.jikos.cz> <554C7A6A.8040404@cn.fujitsu.com> <20150511162423.GV23255@twin.jikos.cz> <555160DF.9050902@cn.fujitsu.com>
In-Reply-To: <555160DF.9050902@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/12/2015 10:09 AM, Qu Wenruo wrote:
>
>
> -------- Original Message  --------
> Subject: Re: [PATCH 0/8] Introduce offline fsid/chunk tree uuid change
> for btrfstune.
> From: David Sterba <dsterba@suse.cz>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2015年05月12日 00:24
>
>> On Fri, May 08, 2015 at 04:57:14PM +0800, Qu Wenruo wrote:
>>>> Respecting the current syntax, the way to set the uuid is:
>>>>
>>>>    btrfs prop set -t filesytem /dev/sdx uuid ...UUID...
>>>>
>>>> In this special case, the property handler should check if the
>>>> device is
>>>> unmounted (and is a btrfs filesystem) and then do the rest.
>>> This is one good idea, but I'm afraid it may still be confusing.
>>> And things may get even worse when we try to move everything into
>>> btrfs-prop,
>>> E.g. if we auto move seeding flag to prop, we must give a quite detailed
>>> explain on which property is offline.
>>>
>>> So I prefer to add a new type called offline, and put uuid change with
>>> other btrfstune function into this type.
>>> IMHO this should provide a good explain on which is online and which is
>>> offline.
>>>
>>> How do you think about this method?
>>
>> I don't think that 'offline' is a good choice. The type should denote
>> the modified object, ie device, inode, filesystem. What's 'offline' in
>> this context?
> Right, 'offline' type here is just a easy trick for me to code, not a
> meaningful type.
>>
>> The property interface can be used to modify other features both for
>> mounted and unmounted filesystem, I agree that this should be done in a
>> way that's not confusing. There are operations that are allowed on an
>> unmounted fs (seeding), mounted + unmounted (extref feature) etc. so I
>> think we could add options like --check-unmounted that would not allow
>> to act on a mounted filesystem.
>
> Nice idea, but i prefer a option like "--offline" to enable the usage of
> offline operations.
> E.g, for normal online operations, nothing is changed.
>
> And for "btrfs prop set <DEV> uuid <UUID>", "--offline" must be
> specified to work.
> Or a message will be output to info user.
>
> What about this one?


Qu, Thanks for the feature.

Qu/David,

  I strongly recommend this feature to be part of btrfstune as
  of now, as originally planned by Qu. When its time to move
  to btrfs cli we could. If we do it wrongly now it would stay
  there forever.

  We could take better call, when all the features of progs are
  in place.

Thanks, Anand

> Thanks,
> Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
