Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36950 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbcHLRAs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Aug 2016 13:00:48 -0400
Received: by mail-wm0-f49.google.com with SMTP id i5so46372116wmg.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Aug 2016 10:00:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
 <pan$d9b53$c31dc60$985cf806$b833643c@cox.net> <CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Fri, 12 Aug 2016 19:00:26 +0200
Message-ID: <CAA7pwKOZ0nznh9cL2SOBHzKnoHbvhbco7T+KDSFSGbCh2v2vAw@mail.gmail.com>
Subject: Re: checksum error in metadata node - best way to move root fs to new drive?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10 August 2016 at 23:21, Chris Murphy <lists@colorremedies.com> wrote:
>
> I'm using LUKS, aes xts-plain64, on six devices. One is using mixed-bg
> single device. One is dsingle mdup. And then 2x2 mraid1 draid1. I've
> had zero problems. The two computers these run on do have aesni
> support. Aging wise, they're all at least a  year old. But I've been
> using Btrfs on LUKS for much longer than that.

FWIW:
I've had 5 spinning disks with LUKS + Btrfs raid1 for 1,5 years.
Also xts-plain64 with AES-NI acceleration.
No problems so far. Not using Btrfs compression.
