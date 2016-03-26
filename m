Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:33205 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbcCZUsa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Mar 2016 16:48:30 -0400
Received: by mail-ig0-f174.google.com with SMTP id ig19so31164308igb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 13:48:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA7pwKMnj5+pLoBPg1z3aRQZJ-kWJefSc+Cg6JrhGSzdW4WFnQ@mail.gmail.com>
References: <1458906560.3786108.559411242.3678497C@webmail.messagingengine.com>
	<CAA7pwKNj+qEUk+RhzyceRFqThzhUkroYMxS3b3gAn_5KEyawMQ@mail.gmail.com>
	<CAA7pwKNgDi9C8E+duwNA6H8MrT1nVEHkWAm4=JZp3GjFgAvZ1g@mail.gmail.com>
	<1458926454.3855039.559662618.4F365498@webmail.messagingengine.com>
	<CAA7pwKP90OTQLdOw4LHtGxZEBWhz3bZCam2E2-CHwA1p9CMdnA@mail.gmail.com>
	<CAGGqMYR9LdCiqHfO5Rn5zY1G7_YKYjrEzkovTVVaFRXqQ7vpeQ@mail.gmail.com>
	<56F5FD42.5010701@oracle.com>
	<CAA7pwKMnj5+pLoBPg1z3aRQZJ-kWJefSc+Cg6JrhGSzdW4WFnQ@mail.gmail.com>
Date: Sat, 26 Mar 2016 14:48:29 -0600
Message-ID: <CAJCQCtT=PXWw4XEGxBuPOuw0VeufNi0Xm4AtvRQJEz79cFuvOw@mail.gmail.com>
Subject: Re: Possible Raid Bug
From: Chris Murphy <lists@colorremedies.com>
To: Patrik Lundquist <patrik.lundquist@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 26, 2016 at 5:51 AM, Patrik Lundquist
<patrik.lundquist@gmail.com> wrote:

> # btrfs replace start -B 4 /dev/sde /mnt; dmesg | tail
>
> # btrfs device stats /mnt
>
> [/dev/sde].write_io_errs   0
> [/dev/sde].read_io_errs    0
> [/dev/sde].flush_io_errs   0
> [/dev/sde].corruption_errs 0
> [/dev/sde].generation_errs 0
>
> We didn't inherit the /dev/sde error count. Is that a bug?

I'm not sure where this information is stored. Presumably in the fs
metadata? So when mounted degraded the counter is zero's is that
what's going on?



-- 
Chris Murphy
