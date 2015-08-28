Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:36841 "EHLO
	mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbbH1Pm4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 11:42:56 -0400
Received: by vkbc123 with SMTP id c123so11206895vkb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 08:42:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150828093502.GO23769@carfax.org.uk>
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
	<20150826165024.05af044f@natsu>
	<55DDAB1C.90406@gmail.com>
	<CAG__1a4x_bv2DURyT0ZW0p+udh43ifcn=bHjUKM4NF1Tk=cYDw@mail.gmail.com>
	<20150828093502.GO23769@carfax.org.uk>
Date: Fri, 28 Aug 2015 09:42:55 -0600
Message-ID: <CAJCQCtSx8nOtLL=_AeNRH0Vn2Fw0PQYTyfbOp-ehkEUCrr+3vg@mail.gmail.com>
Subject: Re: Understanding BTRFS storage
From: Chris Murphy <lists@colorremedies.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        George Duffield <forumscollective@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 28, 2015 at 3:35 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Aug 28, 2015 at 10:50:12AM +0200, George Duffield wrote:
>> Running a traditional raid5 array of that size is statistically
>> guaranteed to fail in the event of a rebuild.
>
>    Except that if it were, you wouldn't see anyone running RAID-5
> arrays of that size and (considerably) larger. And successfully
> replacing devices in them.
>
>    As I understand it, the calculations that lead to the conclusion
> you quote are based on the assumption that the bit error rate (BER) of
> the drive is applied on all reads -- this is not the case. The BER is
> the error rate of the platter after the device has been left unread
> (and powered off) for some long period of time. (I've seen 5 years
> been quoted for that).

I think the confusion comes from the Unrecovered Read Error (URE) or
"Non-recoverable read errors per bits read" in the drive spec sheet.
e.g. on a WDC Red this is written as "<1 in 10^14" but this gets
(wrongly) reinterpreted into an *expected* URE once every 12.5TB (not
TiB) read, which is of course complete utter bullshit. But it gets
repeated all the time.

It's as if symbols have no meaning, and < is some sort of arrow, or
someone got bored and just didn't want to use a space. That symbol
makes the URE value a maximum for what is ostensibly a scientific
sample of drives. We have no idea what the minimum is, we don't even
know the mean, and it's not in the manufacturer's best interest to do
that. The mean between consumer SATA and enterprise SAS may not be all
that different, while the maximum is two orders magnitude better for
enterprise SAS so it makes sense to try to upsell us with that
promise.


-- 
Chris Murphy
