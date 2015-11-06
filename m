Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37173 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411AbbKFKXs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Nov 2015 05:23:48 -0500
Received: by wmll128 with SMTP id l128so36756724wml.0
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2015 02:23:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANznX5EE2YcnTc6-gsQ8R_2p1yt8GSJdRRsXtsEf7VW9Au+P+A@mail.gmail.com>
References: <g7loe3red3ksp64hmb0vsbs2.1445476794489@email.android.com>
 <CANznX5EFZA=HvLkViF_56Pt_VPFiQ6NufoJjx3s42FVTEeGyew@mail.gmail.com> <CANznX5EE2YcnTc6-gsQ8R_2p1yt8GSJdRRsXtsEf7VW9Au+P+A@mail.gmail.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Fri, 6 Nov 2015 11:23:28 +0100
Message-ID: <CAA7pwKMU6J4EfGY26GrzpJtLc96KR1ZGPJ80Vvr_nvQg81oW-Q@mail.gmail.com>
Subject: Re: Btrfs/RAID5 became unmountable after SATA cable fault
To: "Janos Toth F." <toth.f.janos@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6 November 2015 at 10:03, Janos Toth F. <toth.f.janos@gmail.com> wrote:
>
> Although I updated the firmware of the drives. (I found an IMPORTANT
> update when I went there to download SeaTools, although there was no
> change log to tell me why this was important). This might changed the
> error handling behavior of the drive...?

I've had Seagate drives not reporting errors until I updated the
firmware. They tended to timeout instead. Got a shitload of SMART
errors after I updated, but they still didn't handle errors very well
(became unresponsive).
