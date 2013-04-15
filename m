Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:32288 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3DOKx6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 06:53:58 -0400
Message-ID: <516BDC15.8010001@gmx.net>
Date: Mon, 15 Apr 2013 12:53:09 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
CC: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH 1/2] Btrfs: rescan for qgroups
References: <1365161897-19448-1-git-send-email-list.btrfs@jan-o-sch.net> <1365161897-19448-2-git-send-email-list.btrfs@jan-o-sch.net> <20130410164741.GS18193@twin.jikos.cz> <516B93C3.4080306@jan-o-sch.net> <516B9701.9040409@jan-o-sch.net> <516B9968.90701@cn.fujitsu.com> <516BA498.8090807@jan-o-sch.net> <516BAA07.3070702@cn.fujitsu.com>
In-Reply-To: <516BAA07.3070702@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15.04.2013 09:19, Wang Shilong wrote:
> Hello Jan,
> 
>> On Mon, April 15, 2013 at 08:08 (+0200), Wang Shilong wrote:
> 
>>> Hello Jan,
>>>
>>>> On Mon, April 15, 2013 at 07:44 (+0200), Jan Schmidt wrote:
>>>>> Thanks, v2 to come.
>>>> Uh, but not immediately. I didn't get tracking of "exclusive" right. That will
>>>> need some time to fix and test.
>>>
>>> 'exclusive' adds the complexity of btrfs qgroup.
>>> So if you send V2. I'd like you add more lines in changelog.
>>
>> Yes, the commit message will be longer as you requested previously. This does
>> not include a complete description on how "exclusive" works. The qgroup pdf
>> explains that.
> 
> 
> Yeah, changelog really helps for newbies(like me ^_^)
> 
>>
>>> Besides, i have a question in my mind.(I have not seen you code)..
>>> When qgroup rescan  will happen?
>>>
>>> 1> when quota is enabled
>>
>> That's what the second patch does, yes. Your patches should be merged in a way
>> that we first create the level 0 qgroups for all subvolumes and then start the
>> rescan, obviously.
>>
>>> 2> if a new qgroup relations is created, rescan should happen?
>>
>> With your patches, there will be no subvolume qgroups missing. For the higher
>> level groups, one needs expert knowledge anyway. I think it's best to leave that
>> decision to the administrator configuring those qgroups.
> 
> 
> IMO, it is better that qgroup rescan automatically if a qgroup relation
> is added.

I think we should leave it as it is, for several reasons:

a) the administrator might want to add multiple configurations. Only after
   the last one a rescan makes sense.
b) the config changes might not make a rescan necessary. For example, you
   could prepare a configuration for newly created or not-yet-existent
   qgroups. In this case, a rescan of the complete filesystem might be
   unnecessary. A rescan might even be harmful, as during the rescan the
   quota is wrong and users can go over quota. Also, a rescan adds significant
   load to the system.

-Arne
> 
> Thank,
> Wang
> 
>>
>>> 2> user call qgroup rescan..
>>
>> Of course, yes.
>>
>> -Jan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

