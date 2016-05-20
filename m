Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35006 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755801AbcETPWE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 11:22:04 -0400
Received: by mail-oi0-f67.google.com with SMTP id w198so24413219oiw.2
        for <linux-btrfs@vger.kernel.org>; Fri, 20 May 2016 08:22:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1463719510-3014-1-git-send-email-fdmanana@kernel.org>
References: <1463719510-3014-1-git-send-email-fdmanana@kernel.org>
Date: Fri, 20 May 2016 11:22:03 -0400
Message-ID: <CAEzrpqeO7RUFsk8w-fGzBeCXxPMeEsavT0Uo=YD5qAgD0DpDVw@mail.gmail.com>
Subject: Re: [PATCH 5/6] Btrfs: fix race setting block group back to RW mode
 during device replace
From: Josef Bacik <josef@toxicpanda.com>
To: fdmanana@kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 20, 2016 at 12:45 AM,  <fdmanana@kernel.org> wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> After it finishes processing a device extent, the device replace code sets
> back the block group to RW mode and then after that it sets the left cursor
> to match the logical end address of the block group, so that future writes
> into extents belonging to the block group go both the source (old) and
> target (new) devices. However from the moment we turn the block group
> back to RW mode we have a short time window, that lasts until we update
> the left cursor's value, where extents can be allocated from the block
> group and written to, in which case they will not be copied/written to
> the target (new) device. Fix this by updating the left cursor's value
> before turning the block group back to RW mode.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
