Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:36769 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545AbcA3OvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jan 2016 09:51:07 -0500
Received: by mail-lb0-f169.google.com with SMTP id dx2so54753719lbd.3
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jan 2016 06:51:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56AB57B9.6090801@gmail.com>
References: <20160122034538.GA25196@coach.student.rit.edu> <pan$ab5ec$b21ab56e$f67a3d97$7303502@cox.net>
 <20160123214127.GA601@fox.wireless.rit.edu> <CAJCQCtRLAoN+w_hy=jxwtCPkJPo_x5OGOshLr4aQ0=ZX3u91xw@mail.gmail.com>
 <20160127224549.GA4891@fox.rh.rit.edu> <20160127235528.GA5498@fox.rh.rit.edu>
 <56AA0A0A.1060807@gmail.com> <20160128153756.GA19617@fox.rh.rit.edu>
 <CAJCQCtRQZOM3cYiG_KyJYWRS-OR7Q+xMm6o1vBD6BTy=Eb2MUw@mail.gmail.com>
 <20160128184736.GB1167@fox.rh.rit.edu> <56AA6E17.3060104@gmail.com>
 <CAJCQCtTJ75C2vz0b6v_=qzV304FyhR3q5CdPDqCsRD8U2kspMw@mail.gmail.com>
 <56AA70DC.1000201@gmail.com> <CAJCQCtR=+H94a=6H4=RPSpFb8GWN1g26NMhrwat9bgLWHYuZiA@mail.gmail.com>
 <56AA7D94.4030706@gmail.com> <CAJCQCtRd70PW6h_peaAmM2UD3xhPW8JX3MMnQK4eH56ybxbfwg@mail.gmail.com>
 <56AB57B9.6090801@gmail.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Sat, 30 Jan 2016 15:50:45 +0100
Message-ID: <CAA7pwKOejWxV7SfCcs0KPbBkLKzkPR3F+OmGnVSAy2RfhqvjqA@mail.gmail.com>
Subject: Re: RAID1 disk upgrade method
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29 January 2016 at 13:14, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
>
> Last I checked, Seagate's 'NAS' drives and whatever they've re-branded their other enterprise line as, as well as WD's 'Red' drives support both SCT ERC and FUA, but I don't know about any other brands (most of the Hitachi, Toshiba, and Samsung drives I've seen do not support FUA).

I don't know about WD Red Pro but my WD Reds don't support FUA.

Can I list supported commands with something like hdparm? I'm curious
about a WD Re in a LSI RAID.
