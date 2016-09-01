Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay06.ispgateway.de ([80.67.31.101]:34487 "EHLO
        smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754814AbcIAHug (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 03:50:36 -0400
Received: from [77.13.68.6] (helo=hermione.invalid)
        by smtprelay06.ispgateway.de with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.84)
        (envelope-from <envelope@m-berberich.de>)
        id 1bfMfX-0000RT-Pf
        for linux-btrfs@vger.kernel.org; Thu, 01 Sep 2016 09:44:15 +0200
Received: from berberic by hermione.invalid with local (Exim 4.87)
        (envelope-from <envelope@m-berberich.de>)
        id 1bfMfX-0002Wa-9K
        for linux-btrfs@vger.kernel.org; Thu, 01 Sep 2016 09:44:15 +0200
Date: Thu, 1 Sep 2016 09:44:15 +0200
From: M G Berberich <btrfs@oss.m-berberich.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: your mail
Message-ID: <20160901074415.pz32d72d4h6pk77t@invalid>
References: <CAD1x5BA5k9MUdzT-s0kzFfb5+idoJSFaOux0xQS-jd_D0HTDWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAD1x5BA5k9MUdzT-s0kzFfb5+idoJSFaOux0xQS-jd_D0HTDWA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, den 31. August schrieb Fennec Fox:
> Linux Titanium 4.7.2-1-MANJARO #1 SMP PREEMPT Sun Aug 21 15:04:37 UTC
> 2016 x86_64 GNU/Linux
> btrfs-progs v4.7
> 
> Data, single: total=30.01GiB, used=18.95GiB
> System, single: total=4.00MiB, used=16.00KiB
> Metadata, single: total=1.01GiB, used=422.17MiB
> GlobalReserve, single: total=144.00MiB, used=0.00B
> 
> {02:50} Wed Aug 31
> [fennectech@Titanium ~]$  sudo fstrim -v /
> [sudo] password for fennectech:
> Sorry, try again.
> [sudo] password for fennectech:
> /: 99.8 GiB (107167244288 bytes) trimmed
> 
> {03:08} Wed Aug 31
> [fennectech@Titanium ~]$  sudo fstrim -v /
> [sudo] password for fennectech:
> /: 99.9 GiB (107262181376 bytes) trimmed
> 
>   I ran these commands minutes after echother ane each time it is
> trimming the entire free space
> 
> Anyone else seen this?   the filesystem is the root FS and is compressed

You should be very happy that it is trimming at all. Typical situation
on a used btrfs is

  # fstrim -v /
  /: 0 B (0 bytes) trimmed

even if there is 33G unused space ob the fs:

  # df -h /
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/sda2        96G   61G   33G  66% /


	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | mail@m-berberich.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | 
