Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35647 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759266AbcLAUcJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Dec 2016 15:32:09 -0500
Received: by mail-oi0-f42.google.com with SMTP id b126so243127740oia.2
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Dec 2016 12:32:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161201184305.3415-1-ahferroin7@gmail.com>
References: <20161201184305.3415-1-ahferroin7@gmail.com>
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Date: Thu, 1 Dec 2016 20:32:08 +0000
Message-ID: <CAMU1PDi_iTUMJOejS-yVxyZH6oWpk4A6Po7h=7Z3Sqq40EZxXw@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: add dev stats returncode option
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1 December 2016 at 18:43, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> Currently, `btrfs device stats` returns non-zero only when there was an
> error getting the counter values.  This is fine for when it gets run by a
> user directly, but is a serious pain when trying to use it in a script or
> for monitoring since you need to parse the (not at all machine friendly)
> output to check the counter values.
>
> This patch adds an option ('-s') which causes `btrfs device stats`
> to set bit 7 in the return code if any of the counters are non-zero.
> This greatly simplifies checking from a script or monitoring software
> if any errors have been recorded.  In the event that this switch is
> passed and an error occurs reading the stats, the return code will have
> bit 0 set (so if there are errors reading counters, and the counters
> which were read were non-zero, the return value will be 129).

I don't think using bit 7 is a good idea.  Bash (and I think all
shells) report exist status 128+SIGNUM when the process is killed by a
signal.  I.e. status 129 would be returned when a process is killed by
SIGHUP.

Perhaps bit 6 would be OK to use.

Thanks,
Mike

https://tiswww.case.edu/php/chet/bash/bashref.html#Exit-Status
"Exit statuses fall between 0 and 255, though, as explained below, the
shell may use values above 125 specially. ...

When a command terminates on a fatal signal whose number is N, Bash
uses the value 128+N as the exit status. ...

If a command is not found, the child process created to execute it
returns a status of 127. If a command is found but is not executable,
the return status is 126."
