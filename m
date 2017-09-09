Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:38787 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdIIEnc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Sep 2017 00:43:32 -0400
Received: by mail-vk0-f42.google.com with SMTP id x85so5287024vkx.5
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Sep 2017 21:43:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <730f6392-f156-ce05-0911-d1bf07ebfe57@gmx.com>
References: <20170908173622.GU31874@twin.jikos.cz> <730f6392-f156-ce05-0911-d1bf07ebfe57@gmx.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Sat, 9 Sep 2017 10:12:51 +0530
Message-ID: <CAKuJGC9stdPUWtQgnWZExpHqZUtR=PTEANcox5dpT0689QDeDQ@mail.gmail.com>
Subject: Re: btrfs-progs task tracking on github
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba <dsterba@suse.cz>, btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Existing project list is good.

Reg: "Project tests:  Build and test coverage: pre-built images on
docker hub"  If we don't have pre-built images on docker hub, I'll
pick up this task and start working on it. thanks.

----
Cheers,
Lakshmipathi.G



On Sat, Sep 9, 2017 at 5:43 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2017年09月09日 01:36, David Sterba wrote:
>>
>> Hi,
>>
>> in order to make more visible which tasks for btrfs-progs are in
>> progress or desired, I've started to populate the github Projects [1]
>> some time ago. I haven't fleshed out the workflow so this hasn't been
>> announced yet.
>>
>> The aim is to help contributors to join progs development and start from
>> one point with the tasks to choose from. Current practice is to either
>> ask on IRC or find something on the wiki, hoping that the projects are
>> still up to date. Not all of them are, wiki is not the best tool for
>> task tracking.
>>
>> Using github issues and projects is diversion from the current model
>> similar to the kernel part of btrfs, ie. mailinglist for everything.
>> This does suite all the needs but I don't want to completely switch to
>> github-only workflow.  Leaving both options means that bug/patchset
>> discussions will not be visible to both audiences directly, but web
>> archives or publicly accessible github pages should be enough for
>> cross-references.
>>
>> The exact workflow from a task to a merge is not yet defined, I hope
>> we'll be able to find out and document it once the first guinea pig
>> volunteers. The Projects use the kanban-style, I made a bit familiar
>> with that but have no prior experience with it.
>>
>> There are categories for tasks and some brief descriptions. The rough
>> idea is to:
>>
>> 1. move a task from TODO to WIP
>> 2. create issue from the task, for discussions etc
>> 3. work on patches, review cycle
>> 4. when finished, move to next stage on the project page, and ask for
>> merge
>> 5. task is done, code merged and released
>>
>> Who does what and how exactly will have to be found on the way and
>> documented eventually.
>>
>> [1] https://github.com/kdave/btrfs-progs/projects
>
>
> This looks quite good.
>
> BTW, is that only repo owner be able to modify the status?
> In fact I found that some projects like offline scrub doesn't show up in
> either WIP or TODO list.
>
> Thanks,
> Qu
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
