Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35839 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758055AbcHaW6d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Aug 2016 18:58:33 -0400
Received: by mail-oi0-f65.google.com with SMTP id e80so6120308oig.2
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Aug 2016 15:58:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
References: <1471023419.16857.9.camel@gmail.com> <57C426AB.3020607@cn.fujitsu.com>
 <1472485953.3290.0.camel@gmail.com> <57C4EB85.7030000@cn.fujitsu.com>
 <1472561404.3179.3.camel@gmail.com> <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com> <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com> <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 31 Aug 2016 16:58:29 -0600
Message-ID: <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 31, 2016 at 4:47 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 8/31/16 5:48 PM, Chris Murphy wrote:
>> OK it looks like with -w flag I can get a reliable indication of
>> whether quota is enabled or not:
>>
>> [root@f24s ~]# btrfs quota enable /mnt/0
>> [root@f24s ~]# btrfs quota rescan -w /mnt/0
>> quota rescan started
>> [root@f24s ~]# btrfs quota disable /mnt/0
>> [root@f24s ~]# btrfs quota rescan -w /mnt/0
>> ERROR: quota rescan failed: Invalid argument
>>
>>
>> So if you did not enable quota support, and aren't sure if it's
>> enabled you can try 'btrfs quota rescan -w <mp>' but this might
>> actually be a bad idea, a rescan could take a while if you're actually
>> using quotas, I have no idea because I don't use them.
>
> It can take a while, but the code is smart enough not to get too much in
> the way of other activity.  It maintains a progress marker and only does
> live accounting on extents that have already been scanned.
>
>> Perhaps someone can point out an easier way to determine whether
>> quotas are enabled?
>
> btrfs qgroup show <path>

Wow, thanks but that's not obvious at all. man btrfs quota is
described as "btrfs-quota - control the global quota status of a btrfs
filesystem" so it stands to reason the state command for whether it's
enabled or disabled would be in that subcommand not in some other
subcommand.

But this is sidetracking. Does Ronan's call trace showing
/fs/btrfs/qgroup.c:2667
> btrfs_qgroup_free_meta implicate qgroups as a possible source of his problem? That trace would only happen if quotas were enabled, right?

-- 
Chris Murphy
