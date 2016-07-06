Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36141 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbcGFS5S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 14:57:18 -0400
Received: by mail-oi0-f44.google.com with SMTP id f189so283591711oig.3
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 11:57:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA91j0VEBRDUW+MehjtUqhZHi2dehnbY9w-_quEihRc1D=cpvQ@mail.gmail.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de> <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <CAJCQCtSZ=7v5PgD4mYKhayg03UfVqCV0ADBSjTsFDHiVcdxAjw@mail.gmail.com> <CAA91j0VEBRDUW+MehjtUqhZHi2dehnbY9w-_quEihRc1D=cpvQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 6 Jul 2016 12:57:16 -0600
Message-ID: <CAJCQCtTVKA0DEqDhDDduTMMONo7XUrGD-VaDt2Zfsg_mqP762Q@mail.gmail.com>
Subject: Re: 64-btrfs.rules and degraded boot
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 12:24 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> On Wed, Jul 6, 2016 at 8:19 PM, Chris Murphy <lists@colorremedies.com> wrote:
>>
>> I'm mainly concerned with rootfs. And I'm mainly concerned with a very
>> simple 2 disk raid1. With a simple user opt in using
>> rootflags=degraded, it should be possible to boot the system. Right
>> now it's not possible. Maybe just deleting 64-btrfs.rules would fix
>> this problem, I haven't tried it.
>>
>
> While deleting this rule will fix your specific degraded 2 disk raid 1
> it will break non-degraded multi-device filesystem. Logic currently
> implemented by systemd assumes that mount is called after
> prerequisites have been fulfilled. Deleting this rule will call mount
> as soon as the very first device is seen; such filesystem is obviously
> not mountable.

Seems like we need more granularity by btrfs ioctl for device ready,
e.g. some way to indicate:

0 all devices ready
1 devices not ready (don't even try to mount)
2 minimum devices ready (degraded mount possible)


Btrfs multiple device single and raid0 only return code 0 or 1. Where
raid 1, 5, 6 could return code 2. The systemd default policy for code
2 could be to wait some amount of time to see if state goes to 0. At
the timeout, try to mount anyway. If rootflags=degraded, it mounts. If
not, mount fails, and we get a dracut prompt.

That's better behavior than now.

> Equivalent of this rule is required under systemd and desired in
> general to avoid polling. On systemd list I outlined possible
> alternative implementation as systemd service instead of really
> hackish udev rule.

I'll go read it there. Thanks.


-- 
Chris Murphy
