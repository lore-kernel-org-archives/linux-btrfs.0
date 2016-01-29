Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36834 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbcA2UlM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 15:41:12 -0500
Received: by mail-io0-f172.google.com with SMTP id g73so102672644ioe.3
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jan 2016 12:41:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56AB57B9.6090801@gmail.com>
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
Date: Fri, 29 Jan 2016 13:41:10 -0700
Message-ID: <CAJCQCtSt9iFZ4uqe6YZgPBHiDbbVjDdkW9CpfwJncJw_MwhM=Q@mail.gmail.com>
Subject: Re: RAID1 disk upgrade method
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Sean Greenslade <sean@seangreenslade.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 29, 2016 at 5:14 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

>
> That said, you may want to test the performance difference with the write
> cache disabled, depending on how the kernel is trying to emulate write
> barriers, it may actually speed things up.

With all of the laptop drives I've tested, WDC Blue and Black, an HST,
and Toshiba, using hdparm to disable the write cache resulting in
writes becoming absolutely abysmal. Instead of ~120MB/s writes, they
went to 4MB/s. Unusuable. It's so bad I'm thinking it might even be a
bug.




-- 
Chris Murphy
