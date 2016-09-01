Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay04.ispgateway.de ([80.67.31.31]:43008 "EHLO
        smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753032AbcIAVPY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 17:15:24 -0400
Received: from [77.13.67.237] (helo=hermione.invalid)
        by smtprelay04.ispgateway.de with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.84)
        (envelope-from <envelope@m-berberich.de>)
        id 1bfZKR-0002YO-1q
        for linux-btrfs@vger.kernel.org; Thu, 01 Sep 2016 23:15:19 +0200
Received: from berberic by hermione.invalid with local (Exim 4.87)
        (envelope-from <envelope@m-berberich.de>)
        id 1bfZKQ-0001TV-IP
        for linux-btrfs@vger.kernel.org; Thu, 01 Sep 2016 23:15:18 +0200
Date: Thu, 1 Sep 2016 23:15:18 +0200
From: M G Berberich <btrfs@oss.m-berberich.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: your mail
Message-ID: <20160901211518.jk5tpmwnhbb22xf4@invalid>
References: <CAD1x5BA5k9MUdzT-s0kzFfb5+idoJSFaOux0xQS-jd_D0HTDWA@mail.gmail.com>
 <20160901074415.pz32d72d4h6pk77t@invalid>
 <31a75b1a-445a-47cd-816e-1e7e9d1c4bb8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <31a75b1a-445a-47cd-816e-1e7e9d1c4bb8@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, den 01. September schrieb Austin S. Hemmelgarn:
> On 2016-09-01 03:44, M G Berberich wrote:
> > Am Mittwoch, den 31. August schrieb Fennec Fox:
> > > Linux Titanium 4.7.2-1-MANJARO #1 SMP PREEMPT Sun Aug 21 15:04:37 UTC
> > > 2016 x86_64 GNU/Linux
> > > btrfs-progs v4.7
> > > 
> > > Data, single: total=30.01GiB, used=18.95GiB
> > > System, single: total=4.00MiB, used=16.00KiB
> > > Metadata, single: total=1.01GiB, used=422.17MiB
> > > GlobalReserve, single: total=144.00MiB, used=0.00B
> > > 
> > > {02:50} Wed Aug 31
> > > [fennectech@Titanium ~]$  sudo fstrim -v /
> > > [sudo] password for fennectech:
> > > Sorry, try again.
> > > [sudo] password for fennectech:
> > > /: 99.8 GiB (107167244288 bytes) trimmed
> > > 
> > > {03:08} Wed Aug 31
> > > [fennectech@Titanium ~]$  sudo fstrim -v /
> > > [sudo] password for fennectech:
> > > /: 99.9 GiB (107262181376 bytes) trimmed
> > > 
> > >   I ran these commands minutes after echother ane each time it is
> > > trimming the entire free space
> > > 
> > > Anyone else seen this?   the filesystem is the root FS and is compressed
> > 
> > You should be very happy that it is trimming at all. Typical situation
> > on a used btrfs is
> > 
> >   # fstrim -v /
> >   /: 0 B (0 bytes) trimmed
> > 
> > even if there is 33G unused space ob the fs:
> > 
> >   # df -h /
> >   Filesystem      Size  Used Avail Use% Mounted on
> >   /dev/sda2        96G   61G   33G  66% /
> > 
> I think you're using an old kernel, this has been working since at least
> 4.5, but was broken in some older releases.

No, I’m always running a fairly up-to-date vanilla kernel on this
system. At the moment it’s:

  Linux hermione 4.7.2 #4 SMP PREEMPT Wed Aug 24 17:12:03 CEST 2016 x86_64 GNU/Linux

I’m running kernels ≥ 4.5.0 since about April and I first reported this
problem at 7 Jul 2016 (Subject: fstrim problem/bug) probably with a
4.6.3 kernel.

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | mail@m-berberich.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | 
