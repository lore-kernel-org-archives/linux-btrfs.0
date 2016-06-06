Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35431 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbcFFBr1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 21:47:27 -0400
Received: by mail-oi0-f48.google.com with SMTP id w184so205049479oiw.2
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jun 2016 18:47:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <73123a36-6502-d735-c813-fce43b620e5a@smoothware.net>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
	<aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
	<CAJCQCtQ4i0PWisxi708EmrTuPHH7hNEkKfY28GjTG2s4Sk3DYQ@mail.gmail.com>
	<73123a36-6502-d735-c813-fce43b620e5a@smoothware.net>
Date: Sun, 5 Jun 2016 19:47:26 -0600
Message-ID: <CAJCQCtTDbb47n8G0Skay5QEcY_9Qjjv_gRyCkG+-L7YKyes=7g@mail.gmail.com>
Subject: Re: Recommended why to use btrfs for production?
From: Chris Murphy <lists@colorremedies.com>
To: Mladen Milinkovic <maxrd2@smoothware.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Martin <rc6encrypted@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 5, 2016 at 4:45 AM, Mladen Milinkovic <maxrd2@smoothware.net> wrote:
> On 06/03/2016 04:05 PM, Chris Murphy wrote:
>> Make certain the kernel command timer value is greater than the driver
>> error recovery timeout. The former is found in sysfs, per block
>> device, the latter can be get and set with smartctl. Wrong
>> configuration is common (it's actually the default) when using
>> consumer drives, and inevitably leads to problems, even the loss of
>> the entire array. It really is a terrible default.
>
> Since it's first time i've heard of this I did some googling.
>
> Here's some nice article about these timeouts:
> http://strugglers.net/~andy/blog/2015/11/09/linux-software-raid-and-drive-timeouts/comment-page-1/
>
> And some udev rules that should apply this automatically:
> http://comments.gmane.org/gmane.linux.raid/48193

Yes it's a constant problem that pops up on the linux-raid list.
Sometimes the list is quiet on this issue but it really seems like
it's once a week. From last week...

http://www.spinics.net/lists/raid/msg52447.html

And you wouldn't know it because the subject is "raid 5 crashed" so
you wouldn't think, oh bad sectors are accumulating because they're
not getting fixed up and they're not getting fixed up because the
kernel command timer is resetting the link preventing the drive from
reporting a read error and the associated sector LBA. It starts with
that, and then you get a single disk failure, and now when doing a
rebuild, you hit the bad sector on an otherwise good drive and in
effect that's like a 2nd drive failure and now the raid5 implodes.
It's fixable, sometimes, but really tedious.



-- 
Chris Murphy
