Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:33284 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbbKITwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 14:52:34 -0500
Received: by wmec201 with SMTP id c201so98760354wme.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 11:52:33 -0800 (PST)
From: dcg <diegocg@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Reproducible corruption issue in stable, with possible patch unmerged?
Date: Mon, 09 Nov 2015 20:52:27 +0100
Message-ID: <1577930.BqffQ3G4ml@archlinux>
In-Reply-To: <20151107201727.GB26661@ret.masoncoding.com>
References: <CAFhRPx8LiHHuuv+JfZZV+d9+rCDv2Y97WYm-eniFJTBhwKmdsw@mail.gmail.com> <20151107201727.GB26661@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Saturday 07 November 2015 15:17:27 Chris Mason escribió:
> > error output. The patch doesn't seem to have been merged:
> Good catch.  Can you describe your configuration?

pool of 3 spinning disks, configured with raid0 for data and raid1
for metadata

Total devices 3 FS bytes used 749.78GiB
        devid    1 size 1.81TiB used 254.00GiB path /dev/sdc1
        devid    2 size 465.76GiB used 253.01GiB path /dev/sdb1
        devid    3 size 463.76GiB used 252.01GiB path /dev/sda3

x86-64 system, 4 cores, 16 GB RAM
