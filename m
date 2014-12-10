Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37441 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaLJAGr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 19:06:47 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so2267164wgg.5
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Dec 2014 16:06:46 -0800 (PST)
MIME-Version: 1.0
Reply-To: andrew.j.wade@gmail.com
In-Reply-To: <CAJCQCtR98rCHHmZ9zjB93znfwEEitGxbnrMzDqRn1wV0sxvi=w@mail.gmail.com>
References: <m5imaf$s9b$1@ger.gmane.org>
	<CAAuLxcZJ1VDTrvRtaaXgqUo91sBcBkLYUUTe-_CNLm1zMEZp7g@mail.gmail.com>
	<CAJCQCtR98rCHHmZ9zjB93znfwEEitGxbnrMzDqRn1wV0sxvi=w@mail.gmail.com>
Date: Tue, 9 Dec 2014 19:06:46 -0500
Message-ID: <CAAuLxcYYGiJwGEh7yU4+dCfPt6jKP2VT=2K_c8bTwiAAWJhiDQ@mail.gmail.com>
Subject: Re: Kernel lockup: "fs/btrfs/delayed-inoce.c:1410 btrfs_assert_delayed_root_empty"
From: Andrew Wade <andrew.j.wade@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Bernardo Donadio <bcdonadio@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 7, 2014 at 2:20 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sat, Dec 6, 2014 at 7:45 PM, Andrew Wade <andrew.j.wade@gmail.com> wrote:
>> ...
>
> Typically a dev will want to see the result of sysrq+w to show details
> on the blocked tasks. I suggest reproducing the conditions, then issue
> sysrq+w, then recapture dmesg. And also you might look at your own
> previous post in the archives and see if it formats legibly because
> the result I've got in gmail (above) is wrapping poorly and makes it
> hard to read. If you can't figure that out, then it's easier to just
> file a bug at bugzilla.kernel.org, and attach the dmesg output as a
> text file, then cite the bug URL in this thread.
>
> https://www.kernel.org/doc/Documentation/sysrq.txt
>

Thanks Chris.

I found an exiting bug for my issue and attached a log with sysrq+w

https://bugzilla.kernel.org/show_bug.cgi?id=82251

thanks,
Andrew
