Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34060 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbcHARyU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 13:54:20 -0400
Received: by mail-oi0-f52.google.com with SMTP id l65so202821776oib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Aug 2016 10:53:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <66ae3161-b57e-e531-36d5-afc726912563@gmail.com>
References: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
 <CAJCQCtQ8yPQf8O2LA92-Gd95GGXQiDp-ZomKZgP4bNv-MmKHYw@mail.gmail.com>
 <ac28e105-f228-de18-08c2-e504e304052d@gmail.com> <CAJCQCtQahbHJhcyKrdRGLNuzbd7MUL11nGBpiQ2U40nAn1ve2w@mail.gmail.com>
 <a582564a-e991-dd35-721f-31c807a24929@gmail.com> <CAJCQCtRgmfWVf9YB2=fVLDSRhm4-t7W+YHBabBaBsBZeSiDU1Q@mail.gmail.com>
 <ad6d5637-7d38-8527-513c-ffe000e5a2f1@gmail.com> <CAJCQCtQtxVOZ=7Phc=mjTbGbL+V5hMsjTL3vssJXH0pVZ2xrEg@mail.gmail.com>
 <66ae3161-b57e-e531-36d5-afc726912563@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 1 Aug 2016 11:47:15 -0600
Message-ID: <CAJCQCtTXNAC1aNpwmhMYYct2GVFO9syFom34XYwM9rGSB5xCJA@mail.gmail.com>
Subject: Re: systemd KillUserProcesses=yes and btrfs scrub
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 1, 2016 at 11:19 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-08-01 13:15, Chris Murphy wrote:

>> I've been using balance with &, and when I logout, the btrfs command
>> continues to flip between status D and R, just like before logout and
>> it appears to complete. I still get status messages of the balance
>> after logout, in kernel messages.
>>
> Interesting, maybe balance is explicitly white-listed?  Either that, or it
> just ignores whatever signal systemd uses to kill stuff in this context (I
> initially thought SIGTERM, but SIGHUP would make more sense in this
> context), which wouldn't surprise me either.

I'm not aware of any program specific white listing method with
KillUserProcesses=yes. However, there is KillExcludeUsers which by
default is KillExcludeUsers=root. Everything I run as sudo appears in
top and ps as use root. So are these processes exempt? And if so, why
is btrfs scrub becoming a zombie process? I don't know if it's
appropriate, but I asked about it (no response yet), whether all
things sudo should just be moved out of the user session. In my own
head I don't associate sudo commands with my user or my user session,
and at least top and ps agree with the former, so why not have sudo'd
processes put in a different scope from the outset?


-- 
Chris Murphy
