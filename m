Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:57449 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbbBMDiQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 22:38:16 -0500
Received: by mail-yh0-f54.google.com with SMTP id z6so6855850yhz.13
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Feb 2015 19:38:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRAz66sT_sKpy_JOhHnWf4ZvVMtYQyJXrMGLPx-oPDp8Q@mail.gmail.com>
References: <11865500.KaKfdqacBs@zafu>
	<CAJCQCtRAz66sT_sKpy_JOhHnWf4ZvVMtYQyJXrMGLPx-oPDp8Q@mail.gmail.com>
Date: Thu, 12 Feb 2015 20:38:15 -0700
Message-ID: <CAJCQCtQX_wDt0bFyJpHe428uYX2PEr+nuuLMdVncLsVsjwA7HA@mail.gmail.com>
Subject: Re: BTRFS RAID-1 leaf size change scenario
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm going to amend what I wrote earlier. The problem with the seed
device method, it won't let you change the leafsize. And that means
you'll need to go with a new volume with mkfs, and migrate data with
btrfs send receive instead.

And to clarify, you don't need to thin out subvolume to start out with
on the existing volume. Do the thinning as part of the send/receive
strategy. Keep the old raid1 mirror as a read only archive until
you're clear you don't need it as much as you need a new backup
volume. I wouldn't combine archive and backup in a single device.

Chris Murphy
