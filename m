Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:34414 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbcGFLzo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 07:55:44 -0400
Received: by mail-qk0-f172.google.com with SMTP id t127so312298167qkf.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 04:55:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <10018aa9-a2e2-dd2a-b8d9-9945e0e170af@gmail.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de> <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com> <10018aa9-a2e2-dd2a-b8d9-9945e0e170af@gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Wed, 6 Jul 2016 14:55:37 +0300
Message-ID: <CAA91j0VUTBc8W2CBFQJZFR4RxJAYL1bkw6GTJLsxu9mMBZ4yDw@mail.gmail.com>
Subject: Re: 64-btrfs.rules and degraded boot
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 2:45 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-07-06 05:51, Andrei Borzenkov wrote:
>>
>> On Tue, Jul 5, 2016 at 11:10 PM, Chris Murphy <lists@colorremedies.com>
>> wrote:
>>>
>>> I started a systemd-devel@ thread since that's where most udev stuff
>>> gets talked about.
>>>
>>>
>>> https://lists.freedesktop.org/archives/systemd-devel/2016-July/037031.html
>>>
>>
>> Before discussing how to implement it in systemd, we need to decide
>> what to implement. I.e.
>>
>> 1) do you always want to mount filesystem in degraded mode if not
>> enough devices are present or only if explicit hint is given?
>> 2) do you want to restrict degrade handling to root only or to other
>> filesystems as well? Note that there could be more early boot
>> filesystems that absolutely need same treatment (enters separate
>> /usr), and there are also normal filesystems that may need be mounted
>> even degraded.
>> 3) can we query btrfs whether it is mountable in degraded mode?
>> according to documentation, "btrfs device ready" (which udev builtin
>> follows) checks "if it has ALL of it’s devices in cache for mounting".
>> This is required for proper systemd ordering of services.
>
>
> To be entirely honest, if it were me, I'd want systemd to fsck off.  If the
> kernel mount(2) call succeeds, then the filesystem was ready enough to
> mount, and if it doesn't, then it wasn't, end of story.

How should user space know when to try mount? What user space is
supposed to do during boot if mount fails? Do you suggest

while true; do
  mount /dev/foo && exit 0
done

as part of startup sequence? And note that nowhere is systemd involved so far.

> The whole concept
> of trying to track in userspace something the kernel itself tracks and knows
> a whole lot more about is absolutely stupid.

It need not be user space. If kernel notifies user space when
filesystem is mountable, problem solved. It could be udev event,
netlink, whatever. Until kernel does it, user space need to either
poll or somehow track it based on available events.

> It makes some sense when
> dealing with LVM or MD, because that is potentially a security issue
> (someone could inject a bogus device node that you then mount instead of
> your desired target),

I do not understand it at all. MD and LVM has exactly the same problem
- they need to know when they can assemble MD/VG. I miss what it has
to do with security, sorry.

> but it makes no sense here, because there's no way to
> prevent the equivalent from happening in BTRFS.
>
> As far as the udev rules, I'm pretty certain that _we_ ship those with
> btrfs-progs,

No, you do not. You ship rule to rename devices to be more
"user-friendly". But the rule in question has always been part of
udev.

> I have no idea why they're packaged with udev in CentOS (oh
> wait, I bet they package every single possible udev rule in that package
> just in case, don't they?).
