Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout09.t-online.de ([194.25.134.84]:44279 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2GOFpv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jul 2012 01:45:51 -0400
Date: 15 Jul 2012 07:20:00 +0200
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CCthSbPuCXB@helmut.hullen.de>
In-Reply-To: <CAF7mNP4oQ=sSXf-gVSMF2Xq89OL25L7HnWL4MbqSONxr8=RRTQ@mail.gmail.com>
Subject: Re: bug: raid10 filesystem has suddenly ceased to mount
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, ????,

Du meintest am 14.07.12:

> The problem is that the BTRFS raid10 filesystem without any
> understandable cause refuses to mount.

> Here is dmesg output:
> [77847.845540] device label linux-btrfs-raid10 devid 3 transid 45639
> /dev/sdc1 [77848.633912] btrfs: allowing degraded mounts
> [77848.633917] btrfs: enabling auto defrag
> [77848.633919] btrfs: use lzo compression
> [77848.633922] btrfs: turning on flush-on-commit
> [77848.658879] parent transid verify failed on 2363592273920 wanted
> 31596 found 25250
> [77848.659060] parent transid verify failed on 2363592273920 wanted
> 31596 found 25250

[...]

Sounds familiar ...

Re-install your backup.

Viele Gruesse!
Helmut
