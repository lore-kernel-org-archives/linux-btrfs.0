Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24190 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757509AbbEVPU5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 May 2015 11:20:57 -0400
Message-ID: <555F494F.2060404@oracle.com>
Date: Fri, 22 May 2015 23:20:47 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8] Introduce offline fsid/chunk tree uuid change for
 btrfstune.
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com> <20150505152055.GH5099@twin.jikos.cz> <5549651D.6020005@cn.fujitsu.com> <20150506154347.GC23255@twin.jikos.cz> <554C7A6A.8040404@cn.fujitsu.com> <20150511162423.GV23255@twin.jikos.cz> <555160DF.9050902@cn.fujitsu.com> <55517ADC.6000300@oracle.com> <20150513134329.GJ23255@suse.cz> <55561401.8020904@oracle.com> <20150521163057.GA23255@twin.jikos.cz>
In-Reply-To: <20150521163057.GA23255@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/22/2015 12:30 AM, David Sterba wrote:
> On Fri, May 15, 2015 at 11:42:57PM +0800, Anand Jain wrote:
>>
>>
>> On 05/13/2015 09:43 PM, David Sterba wrote:
>>> On Tue, May 12, 2015 at 12:00:28PM +0800, Anand Jain wrote:
>>>>     I strongly recommend this feature to be part of btrfstune as
>>>>     of now, as originally planned by Qu. When its time to move
>>>>     to btrfs cli we could. If we do it wrongly now it would stay
>>>>     there forever.
>>>
>>> I agree with that now. The code to change the uuid is straightforward,
>>> we'd got stuck on getting the interface right. At the moment it's more
>>> likely to get it wrong because the properties are not finalized.  A
>>> standalone tool for the uuid change is IMO not the right way either,
>>> btrfstune is usually packaged already.
>>
>>    How about placing the new sub-cli like below, until it finds its
>>    final home.
>>
>>    btrfs unstable <sub-cli>
>>    or
>>    btrfs experimental <sub-cli>
>
> You probably remember this
>
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/27396

  yes I remember it vaguely. thanks for pulling it out.
  I didn't anticipate this context of uncertainty in naming
  of sub cli before. you were right this is useful.

Thanks, Anand


> I'll revive the integration branches and merge the unfinished features
> there.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
