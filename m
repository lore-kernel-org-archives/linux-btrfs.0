Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34321 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbbLNHgN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 02:36:13 -0500
Received: by mail-ig0-f169.google.com with SMTP id g19so76300357igv.1
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Dec 2015 23:36:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <566DF757.8020807@birds-are-nice.me>
References: <566DF757.8020807@birds-are-nice.me>
Date: Mon, 14 Dec 2015 00:36:12 -0700
Message-ID: <CAJCQCtSG24eO0K6z471PzfyOM-W81p9-6Gq+QGF8dXMf1FBMyA@mail.gmail.com>
Subject: Re: Kernel lockup, might be helpful log.
From: Chris Murphy <lists@colorremedies.com>
To: Birdsarenice <Quail@birds-are-nice.me>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I can't help with the call traces. But several (not all) of the hard
resetting link messages are hallmark cases where the SCSI command
timer default of 30 seconds looks like it's being hit while the drive
itself is hung up doing a sector read recovery (multiple attempts).
It's worth seeing if 'smartctl -l scterc <dev>' will report back that
SCT is supported and that it's just disabled, meaning you can change
this to something sane like with 'smartctl -l 70,70 <dev>' which will
make the drive time out before the linux kernel command timer. That'll
let Btrfs do the right thing, rather than constantly getting poked in
both eyes by link resets.


Chris Murphy
