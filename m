Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63006 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaFUTTa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Jun 2014 15:19:30 -0400
Received: by mail-ob0-f174.google.com with SMTP id va2so2520760obc.33
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Jun 2014 12:19:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK5rZE4yA0PDR3S2RgTgXyQ=8ViRwSPg__DacPKXSpCmjzpW4w@mail.gmail.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
 <2316027.LZEnVG8laK@xev> <CAK5rZE4GVJ7qh4w=ecTZhZMANT0A6cU-6+jAbifNtoWFeYtf4Q@mail.gmail.com>
 <CAK5rZE4yA0PDR3S2RgTgXyQ=8ViRwSPg__DacPKXSpCmjzpW4w@mail.gmail.com>
From: =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>
Date: Sat, 21 Jun 2014 21:19:09 +0200
Message-ID: <CAPLrYET=97qfHWiDh0oKoYBU1r_RSkyma_mWKE=GSoTBFhm7GQ@mail.gmail.com>
Subject: Re: btrfs on whole disk (no partitions)
To: Imran Geriskovan <imran.geriskovan@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-06-19 11:11 GMT+02:00 Imran Geriskovan <imran.geriskovan@gmail.com>:
> On 6/19/14, Russell Coker <russell@coker.com.au> wrote:

>
> Grub installs itself and boots from Partitionless Btrfs disk.
> It is handy for straight forward installations.
>
> However, IF you need boot partition (ie. initramfs and kernel to boot
> from encrypted root) its another story.

zfs "solved" this problem in grub (libzfs). I think we can find a
solution to work around this problem.
