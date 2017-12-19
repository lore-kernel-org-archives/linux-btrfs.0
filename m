Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:38297 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdLSRsz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 12:48:55 -0500
Received: by mail-it0-f47.google.com with SMTP id r6so3744212itr.3
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 09:48:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <83e041e2-a440-845f-df54-ecde29bd10dd@mendix.com>
References: <CAG+QAKXycv-a3G9QKts4V9RWtKxgRgTtSd6mkZP=Dagmi9Ebtg@mail.gmail.com>
 <CAG+QAKUbtQc0V0njpXoC_UZL5NF1BP+qoH6Zbh4KgEN_2EiOdw@mail.gmail.com> <83e041e2-a440-845f-df54-ecde29bd10dd@mendix.com>
From: Rich Rauenzahn <rrauenza@gmail.com>
Date: Tue, 19 Dec 2017 09:48:54 -0800
Message-ID: <CAG+QAKViZXY-NguA+=Dy=1pye1Da+sM2+epohnxyefT=BPwXxw@mail.gmail.com>
Subject: Re: kernel hangs during balance
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 9:14 AM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:
> Just wild first guess... are you also using btrfs send/receive
> functionality where the system having problems is the sending part?

No.

>>> Every night I'm getting a kernel hang, sometimes caught by my
>>> watchdog, sometimes not.  Last night's hang was on the balance of DATA
>>> on / at 70.
>>>
>>> I'm not sure how to further trace this down to help you -- the console
>>> by the time I notice just has lots of messages on it without the
>>> initial ones.
>
> Capturing more logs is definitely the first thing to do.
>
> Look if the output of `dmesg` still shows the btrfs errors. Otherwise,

But I can't ...  I have to hit the reset button (or the watchdog does)
before I can get into the system again.

> if something is spamming there, turn that off, or if you don't have the
> errors in a log file because the log files are on the same btrfs, then
> you have to find out another way to capture them. E.g. make the kernel
> buffer for messages bigger, use netconsole or just pragmatic things like
> ssh from another server and `dmesg -w` and store it on the other machine.

Ah... yes, a permanent connection from another might work.

I also have a pfsense box -- I think it can take a syslogd daemon.
Maybe I can netconsole to it?

Will investigate.
