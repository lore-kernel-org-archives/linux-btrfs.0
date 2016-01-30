Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35379 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbcA3ToB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jan 2016 14:44:01 -0500
Received: by mail-ig0-f175.google.com with SMTP id t15so10750602igr.0
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jan 2016 11:44:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA7pwKOejWxV7SfCcs0KPbBkLKzkPR3F+OmGnVSAy2RfhqvjqA@mail.gmail.com>
References: <20160122034538.GA25196@coach.student.rit.edu>
	<pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
	<20160123214127.GA601@fox.wireless.rit.edu>
	<CAJCQCtRLAoN+w_hy=jxwtCPkJPo_x5OGOshLr4aQ0=ZX3u91xw@mail.gmail.com>
	<20160127224549.GA4891@fox.rh.rit.edu>
	<20160127235528.GA5498@fox.rh.rit.edu>
	<56AA0A0A.1060807@gmail.com>
	<20160128153756.GA19617@fox.rh.rit.edu>
	<CAJCQCtRQZOM3cYiG_KyJYWRS-OR7Q+xMm6o1vBD6BTy=Eb2MUw@mail.gmail.com>
	<20160128184736.GB1167@fox.rh.rit.edu>
	<56AA6E17.3060104@gmail.com>
	<CAJCQCtTJ75C2vz0b6v_=qzV304FyhR3q5CdPDqCsRD8U2kspMw@mail.gmail.com>
	<56AA70DC.1000201@gmail.com>
	<CAJCQCtR=+H94a=6H4=RPSpFb8GWN1g26NMhrwat9bgLWHYuZiA@mail.gmail.com>
	<56AA7D94.4030706@gmail.com>
	<CAJCQCtRd70PW6h_peaAmM2UD3xhPW8JX3MMnQK4eH56ybxbfwg@mail.gmail.com>
	<56AB57B9.6090801@gmail.com>
	<CAA7pwKOejWxV7SfCcs0KPbBkLKzkPR3F+OmGnVSAy2RfhqvjqA@mail.gmail.com>
Date: Sat, 30 Jan 2016 12:44:00 -0700
Message-ID: <CAJCQCtS0UBHeg9V0MZ0zNwJZu49pO0eYua_YVPUqUTnOA5xsTw@mail.gmail.com>
Subject: Re: RAID1 disk upgrade method
From: Chris Murphy <lists@colorremedies.com>
To: Patrik Lundquist <patrik.lundquist@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 30, 2016 at 7:50 AM, Patrik Lundquist
<patrik.lundquist@gmail.com> wrote:
> On 29 January 2016 at 13:14, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
>>
>> Last I checked, Seagate's 'NAS' drives and whatever they've re-branded their other enterprise line as, as well as WD's 'Red' drives support both SCT ERC and FUA, but I don't know about any other brands (most of the Hitachi, Toshiba, and Samsung drives I've seen do not support FUA).
>
> I don't know about WD Red Pro but my WD Reds don't support FUA.
>
> Can I list supported commands with something like hdparm? I'm curious
> about a WD Re in a LSI RAID.

Blast from the past.

https://lwn.net/Articles/400541/

I kinda wonder where things are at with all of this now, especially
since the VFS changes that have happened recently. There were also
some Btrfs fsync patches a while back to improve performance. There
are so many apps that are asking for fsync and fdatasync now, it seems
almost overkill, and now there are optimizations to handle all of that
(sometimes unnecessary) fsyncing. I also wonder about the differences
between file systems in that respect and whether it is, or is
possible, to better abstract such things from developers so they don't
have to do file system specific stuff.


-- 
Chris Murphy
