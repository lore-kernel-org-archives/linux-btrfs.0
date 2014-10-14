Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:52612 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453AbaJNOwD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 10:52:03 -0400
Received: by mail-vc0-f170.google.com with SMTP id hy10so7648150vcb.15
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Oct 2014 07:52:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPF83mtWrTRyfT34nNm7yjLDq+6uRegNJStkDK6+n_7fpmRTDQ@mail.gmail.com>
References: <CAPF83msBVh_EqHAFxzmicnQjZKe7k4ioNEd8q3vwTxLNDx5prA@mail.gmail.com>
	<543B372F.10509@oracle.com>
	<CAPF83mufgJvTKscpAS_SwFdSrA+1dK3T89A2UiuSHArr5wDn8A@mail.gmail.com>
	<543C86C3.7040804@oracle.com>
	<CAPF83mtWrTRyfT34nNm7yjLDq+6uRegNJStkDK6+n_7fpmRTDQ@mail.gmail.com>
Date: Tue, 14 Oct 2014 10:52:01 -0400
Message-ID: <CAGfcS_nK5w+7Z70+5WMou-Z7HCVPaebFcPzOSKhGO8_=YN1oEQ@mail.gmail.com>
Subject: Re: what is the best way to monitor raid1 drive failures?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Suman C <schakrava@gmail.com>
Cc: Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 14, 2014 at 10:48 AM, Suman C <schakrava@gmail.com> wrote:
>
> The new drive shows up as sdb. btrfs fi show still prints drive missing.
>
> mounted the filesystem with ro,degraded
>
> tried adding the "new" sdb drive which results in the following error.
> (-f because the new drive has a fs from past)
>
> # btrfs device add -f /dev/sdb /mnt2/raid1pool
> /dev/sdb is mounted
>
> Unless I am missing something, this looks like a bug.
>

You need to first run btrfs device delete missing /mnt2/raid1pool I
believe (missing is a keyword for a missing device in the array - if
the device were still present you could specify it by /dev/sdX).

--
Rich
