Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33761 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbEZTcM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 15:32:12 -0400
Received: by wicmx19 with SMTP id mx19so74274383wic.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 12:32:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <556457b8.e72b980a.ee08.ffffce60@mx.google.com>
References: <556457b8.e72b980a.ee08.ffffce60@mx.google.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 26 May 2015 22:31:31 +0300
Message-ID: <CAGqmi76gUe5s3v0=SOmrPcBt8F-N9Vi72FLB1JqnR+8Uo-y+Ew@mail.gmail.com>
Subject: Re: RAID1: system stability
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh, i missing, i've test it on 3.19+ kernels
I can get trace from screen if it interesting for developers.

2015-05-26 14:23 GMT+03:00 Timofey Titovets <nefelim4ag@gmail.com>:
> Hi list,
> I'm regular on this list and I very like btrfs, I want use it on production server, and I want replace hw raid on it.
>
> Test case: server with N scsi discs
> 2 SAS disks used for raid 1 root fs
> If I just remove one disk physically, all okay, kernel show me write errors and system continue work some time. But after first sync call, example
> # sync
> # dd if=/Dev/zero of=/zero
>
> Kernel will crush and system freeze.
> Yes, after reboot, I can mount with degraded and recovery options, and I can add failed disk again, and btrfs will rebuild array.
> But kernel crush and reboot expected in this case, or I can skip it? How?
> # mount -o remount, degraded -> kernel crush
> Insert failed disk again -> kernel crush
>
> May be I missing something? I just want avoid shutdown time or/and reboot =.=



-- 
Have a nice day,
Timofey.
