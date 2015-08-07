Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37468 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbbHGJa3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 05:30:29 -0400
Received: by wibhh20 with SMTP id hh20so57959596wib.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Aug 2015 02:30:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOFdcFMnYfLzw+xH71eNNgZyhqrgH4qOccak0m4OAnH31V_H=A@mail.gmail.com>
References: <CAOFdcFMnYfLzw+xH71eNNgZyhqrgH4qOccak0m4OAnH31V_H=A@mail.gmail.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Fri, 7 Aug 2015 11:30:08 +0200
Message-ID: <CAA7pwKO0detCTYWJDSDLX7fepthE+hBhURifnJjBPUe4XxGfVA@mail.gmail.com>
Subject: Re: Removing bad hdd from btrfs volume
To: Peter Foley <pefoley2@pefoley.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7 August 2015 at 00:17, Peter Foley <pefoley2@pefoley.com> wrote:
> Hi,
>
> I have an btrfs volume that spans multiple disks (no raid, just
> single), and earlier this morning I hit some hardware problems with
> one of the disks.
> I tried btrfs dev del /dev/sda1 /, but btrfs was unable to migrate the
> 1gb that appears to be causing the read errors.
> See http://sprunge.us/aeZC

You might want to try to save as much as possible from the failing
disk with the help of GNU ddrescue. Either by copying sda to a
replacement disk or by copying sda1 to a file for loopback mounting.

Unmount filesystem before copying and remove sda before you mount with the copy.
