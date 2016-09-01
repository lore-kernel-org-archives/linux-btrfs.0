Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:38240 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932354AbcIAVUE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 17:20:04 -0400
Received: by mail-it0-f51.google.com with SMTP id c198so4217136ith.1
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Sep 2016 14:20:04 -0700 (PDT)
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Jeff Mahoney <jeffm@suse.com>,
        Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
References: <1471023419.16857.9.camel@gmail.com>
 <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
 <57C4EB85.7030000@cn.fujitsu.com> <1472561404.3179.3.camel@gmail.com>
 <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
 <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
 <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
 <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com>
 <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com>
 <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
Date: Thu, 1 Sep 2016 14:47:05 -0400
MIME-Version: 1.0
In-Reply-To: <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-01 13:12, Jeff Mahoney wrote:
> On 9/1/16 1:04 PM, Austin S. Hemmelgarn wrote:
>> On 2016-09-01 12:34, Ronan Arraes Jardim Chagas wrote:
>>> Em Qui, 2016-09-01 às 09:21 -0400, Austin S. Hemmelgarn escreveu:
>>>> Yes, you can just run `btrfs quota disable /` and it should
>>>> work.  This
>>>> ironically reiterates that one of the bigger problems with BTRFS is
>>>> that
>>>> distros are enabling unstable and known broken features by default
>>>> on
>>>> install.  I was pretty much dumbfounded when I first learned that
>>>> OpenSUSE is enabling BTRFS qgroups by default since they are known
>>>> to
>>>> not work reliably and cause all kinds of issues.
>>>
>>> Thanks Austin! I executed the command and now I get:
>>>
>>> btrfs qgroup show /
>>> ERROR: can't perform the search - No such file or directory
>>> ERROR: can't list qgroups: No such file or directory
>>>
>>> as expected. Now I will wait for +- 1 week to see if the problem will
>>> occur and, if not, I will send an e-mail to openSUSE factory mailing
>>> list to start a discussion if it is better to not enable qgroups by
>>> default.
>> I have a feeling that you'll probably have no issues.
>>
>> As far as having qgroups enabled by default, I think the reasoning is to
>> emulate having separate filesystems with their own space limits.  I can
>
> It's not.  We use qgroups because that's the only way we can track how
> much space each subvolume is using, regardless of whether anyone wants
> to do enforcement.  When it's working properly, snapper can make use of
> that information to make informed decisions on how much space will
> actually be released when removing old snapshots.
This is all well and good, but it ignores a few specific things:
1. There are numerous known issues with qgroups right now.  This 
includes among other things returning ENOSPC when it should return 
EDQUOT (this isn't your fault, but you haven't tried to fix it either), 
and all kinds of general usability issues (systems tend to misbehave 
when at or near the quotas for example).
2. Snapper's default snapshot creation configuration is absolutely 
pathological in nature, generating insane amounts of background resource 
usage and taking up huge amounts of space.  If this were changed, you 
would be a lot less dependent on being able to free up snapshots based 
on space usage.
3. It is fully possible (now, it may not have been when this choice was 
made) to get this info without using qgroups.  btrfs filesystem du can 
be used to determine essentially the same information (summing the 
values in the second column will give you a reasonable estimate of how 
much space deleting the snapshot will free).
4. Enabling such a marginal technology without user intervention with no 
warnings about it or other notice that it's being used is a pretty solid 
example of something that a developer should not do.

It's poor choices like this that fall into the category of 'Ooh, this 
looks cool, let's do it!' made by major distros that are most of the 
reason that BTRFS has such a bad reputation right now.  This is not 
something that should reasonably be on a production system, especially 
considering that even most of the BTRFS developers don't use qgroups, 
and that apparently your own customer support people couldn't tell that 
qgroups were to blame (seriously, your _ABSOLUTE FIRST SUGGESTION_ 
should have been to disable qgroups and see if the issue went away).

I get that you want something on par with Windows Restore Points or the 
bootable snapshot functionality provided by ZFS on Solaris, but qgroups 
really aren't at all essential to that, and even if they were, such 
functionality isn't even remotely ready for production usage on Linux yet.
>
>> entirely understand this use case, and TBH it's about the only use case
>> I'd consider quota groups for (per-user subvolumes for home directories
>> are great, but there are numerous perfectly legitimate reasons to have
>> very large amounts of data in your home directory for very short periods
>> of time, so I wouldn't personally use qgroups there).  The problem
>> arises from the fact that it doesn't _look_ like separate filesystems
>> (single entry in df, all the mounts point at the same device, etc), and
>
> On SUSE-based kernels, the inodes on different subvolumes report the
> anonymous device associated with the subvolume.
>
> That said, I have a WIP that creates (and auto-tears down) vfsmounts for
> each subvolume.  It's not all the way to a working df that would use the
> qgroup information to report space usage, but it's a start.
So in other words even more dependence on a feature that doesn't even 
work reliably?

