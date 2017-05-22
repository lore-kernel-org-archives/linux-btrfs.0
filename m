Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33854 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759582AbdEVUz0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 16:55:26 -0400
Received: by mail-oi0-f43.google.com with SMTP id b204so177335279oii.1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 May 2017 13:55:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c2e1824a-b395-53da-8cd2-cade09449313@cn.fujitsu.com>
References: <CAMp4zn8CfdzPn7UAHf7S2PT1F8ysf95jMi7F8RBUuyBvqYT5xw@mail.gmail.com>
 <c2e1824a-b395-53da-8cd2-cade09449313@cn.fujitsu.com>
From: Sargun Dhillon <sargun@sargun.me>
Date: Mon, 22 May 2017 13:54:45 -0700
Message-ID: <CAMp4zn-oFVhrM6C4U-z9EQa1HXw-yzTLRyVoHfati-dX1WVU5Q@mail.gmail.com>
Subject: Re: QGroups Semantics
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: BTRFS ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 21, 2017 at 5:59 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 05/19/2017 05:07 PM, Sargun Dhillon wrote:
>>
>> I have some questions about the *intended* qgroups semantics, and why
>> we allow certain operations:
>>
>> 1) Why can you create a level 0 qgroup for a non-existent subvolume?
>> It looks like it just gets reset when you create the subvol anyway?
>> Should we prevent this?
>
>
> Personally speaking, I didn't see much meaning of allowing this, except
> setting limit before creating the subvolume.
>
> But that can also be done by setting up higher level qgroup and attach new
> subvolume to that higher level qgroup.
>
> IIRC there are some guys hoping to disable multi-level qgroup completely, if
> one day we decide to do that, then current behavior may be quite important.
>
>>
>> 2) Why do we allow deleting a level 0 qgroup for a currently existing
>> subvolume? It seems to me that just setting the limit to 0, and/or
>> removing relations would work equally well? Perhaps a new ioctl to
>> clear the qgroup would make sense to do this.
>
>
> At least I didn't see the meaning to allow deleting qgroup for existing
> subvolume.
>
> It won't even improve any performance since we still need to do the time
> consuming backref walk.
>
>>
>> 3) Why don't we remove the associated level 0 qgroup when you remove
>> the subvol with that id?
>
> This may be related to question 1).
> Sometimes we may want to keep the limit?
>
> Despite of that, I didn't see any reason to keep the orphan level 0 qgroup.
>
>>
>> 4) I noticed in qgroup.c, one of the outstanding items is to determine
>> how to  autocleanup. Are there any stated semantics around that, or
>> opinions?
>
>
> As long as we're going to stick with multi level qgroups, then autocleanup
> seems to be a good idea.
>
> Thanks,
> Qu
>
I propose the following changes:
1) We always cleanup level-0 qgroups by default, with no opt-out.
I see absolutely no reason to keep these around.

2) We do not allow the creation of level-0 qgroups for (sub)volumes
that do not exist.
If people want to have a limit at creation time, they should create a
higher level qgroup, and add the new qgroup to that one.

3) We add two new ioctls: qgroup_create_v2, and qgroup_delete_v2, and
add a pr_warn_once message when we see usage of the old API.

4) Add a flag to the qgroup_delete_v2 ioctl, NO_SUBVOL_CHECK.
If the flag is present, it will allow you to delete qgroups which
reference active subvolumes.

Opinions?

>>
>> PS:
>> If the answer to any of these is "it just needs to be worked on" --
>> I'm currently poking around this code path for some enhancements we're
>> doing for our usecase. I'm just trying to figure out how much of what
>> I'm doing is generalizable.
>>
>> -Thanks,
>> Sargun
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
