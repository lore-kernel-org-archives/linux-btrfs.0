Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:37859 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbbCaWPt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 18:15:49 -0400
Received: by igcxg11 with SMTP id xg11so30864491igc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 15:15:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b5hrub-586.ln1@hurikhan77.spdns.de>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
	<CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
	<CAJCQCtQ9PCv5pNMapQabLBKHOS86B+zavcKsQOiR2Q9qOrxv6g@mail.gmail.com>
	<b5hrub-586.ln1@hurikhan77.spdns.de>
Date: Tue, 31 Mar 2015 16:15:48 -0600
Message-ID: <CAJCQCtRn4sjDV1skkpJBjwjfXr18F502Q9G6p_4ZdRg27J4bXg@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
From: Chris Murphy <lists@colorremedies.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 31, 2015 at 3:45 PM, Kai Krakow <hurikhan77@gmail.com> wrote:

> I had this happen, too, lately. It's quite often happening after an unclean
> shutdown (which currently quite often happend to me due to the xorg intel
> driver having GPU freezes). SysRq+W shows that the mount process is locked
> somewhere in the btrfs code path and won't quit if Ctrl+C'd...
>
> Only way to fix it was to btrfs-zero-log.

The i915 regression right now is really annoying. With a Samsung 840
EVO I've  had inexplicable and non-deterministic boot failures. When
running btrfs check from the initramfs  (booting with
rd.break=pre-mount) I get a very long pile of complaints... minutes of
scrolling text of horrible sounding problems. Yet the same btrfs-progs
and the same kernel from Fedora 22 install media, zero complaints, and
mounts fine.

So I have no idea what's going on right now. It even corrupts the EFI
System partition, these crashes.

-- 
Chris Murphy
