Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:35470 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752719AbdLSROx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 12:14:53 -0500
Subject: Re: kernel hangs during balance
To: Rich Rauenzahn <rrauenza@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAG+QAKXycv-a3G9QKts4V9RWtKxgRgTtSd6mkZP=Dagmi9Ebtg@mail.gmail.com>
 <CAG+QAKUbtQc0V0njpXoC_UZL5NF1BP+qoH6Zbh4KgEN_2EiOdw@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <83e041e2-a440-845f-df54-ecde29bd10dd@mendix.com>
Date: Tue, 19 Dec 2017 18:14:51 +0100
MIME-Version: 1.0
In-Reply-To: <CAG+QAKUbtQc0V0njpXoC_UZL5NF1BP+qoH6Zbh4KgEN_2EiOdw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/2017 06:08 PM, Rich Rauenzahn wrote:
> What's also confusing is I just ran a manual balance on the fs using
> defaults (which are aggressive) and it completed with no problems.
> It smells more like a race condition than a particular corruption.

Just wild first guess... are you also using btrfs send/receive
functionality where the system having problems is the sending part?

> On Tue, Dec 19, 2017 at 8:09 AM, Rich Rauenzahn <rrauenza@gmail.com> wrote:
>> I'm running 4.4.106-1.el7.elrepo.x86_64 and I do a btrfs balance everynight.
>>
>> Every night I'm getting a kernel hang, sometimes caught by my
>> watchdog, sometimes not.  Last night's hang was on the balance of DATA
>> on / at 70.
>>
>> I'm not sure how to further trace this down to help you -- the console
>> by the time I notice just has lots of messages on it without the
>> initial ones.

Capturing more logs is definitely the first thing to do.

Look if the output of `dmesg` still shows the btrfs errors. Otherwise,
if something is spamming there, turn that off, or if you don't have the
errors in a log file because the log files are on the same btrfs, then
you have to find out another way to capture them. E.g. make the kernel
buffer for messages bigger, use netconsole or just pragmatic things like
ssh from another server and `dmesg -w` and store it on the other machine.

>>   The last items in /var/log/message aren't helpful, but
>> I'm pretty sure it is the nightly balance.
>>
>> I've run btrfs check on / with no issues recently.

-- 
Hans van Kranenburg
