Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:36365 "EHLO
	mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbcGFLp1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 07:45:27 -0400
Received: by mail-it0-f43.google.com with SMTP id g4so63703369ith.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 04:45:27 -0700 (PDT)
Subject: Re: 64-btrfs.rules and degraded boot
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de>
 <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
Cc: Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <10018aa9-a2e2-dd2a-b8d9-9945e0e170af@gmail.com>
Date: Wed, 6 Jul 2016 07:45:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-06 05:51, Andrei Borzenkov wrote:
> On Tue, Jul 5, 2016 at 11:10 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> I started a systemd-devel@ thread since that's where most udev stuff
>> gets talked about.
>>
>> https://lists.freedesktop.org/archives/systemd-devel/2016-July/037031.html
>>
>
> Before discussing how to implement it in systemd, we need to decide
> what to implement. I.e.
>
> 1) do you always want to mount filesystem in degraded mode if not
> enough devices are present or only if explicit hint is given?
> 2) do you want to restrict degrade handling to root only or to other
> filesystems as well? Note that there could be more early boot
> filesystems that absolutely need same treatment (enters separate
> /usr), and there are also normal filesystems that may need be mounted
> even degraded.
> 3) can we query btrfs whether it is mountable in degraded mode?
> according to documentation, "btrfs device ready" (which udev builtin
> follows) checks "if it has ALL of it’s devices in cache for mounting".
> This is required for proper systemd ordering of services.

To be entirely honest, if it were me, I'd want systemd to fsck off.  If 
the kernel mount(2) call succeeds, then the filesystem was ready enough 
to mount, and if it doesn't, then it wasn't, end of story.  The whole 
concept of trying to track in userspace something the kernel itself 
tracks and knows a whole lot more about is absolutely stupid.  It makes 
some sense when dealing with LVM or MD, because that is potentially a 
security issue (someone could inject a bogus device node that you then 
mount instead of your desired target), but it makes no sense here, 
because there's no way to prevent the equivalent from happening in BTRFS.

As far as the udev rules, I'm pretty certain that _we_ ship those with 
btrfs-progs, I have no idea why they're packaged with udev in CentOS (oh 
wait, I bet they package every single possible udev rule in that package 
just in case, don't they?).
