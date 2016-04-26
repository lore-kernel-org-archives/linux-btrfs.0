Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35980 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbcDZNms (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 09:42:48 -0400
Received: by mail-oi0-f65.google.com with SMTP id i2so1979138oib.3
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 06:42:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1461546072-11154-1-git-send-email-fdmanana@kernel.org>
References: <1461546072-11154-1-git-send-email-fdmanana@kernel.org>
Date: Tue, 26 Apr 2016 15:42:47 +0200
Message-ID: <CAHji153V8MOcdf6immv3_3CgsZNAR_KHEsj+BHeg0vV-WE5M-w@mail.gmail.com>
Subject: Re: [PATCH 0/3] Fixes for races in relocation and avoid start and
 wait for unrelated IO
From: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 25, 2016 at 3:01 AM,  <fdmanana@kernel.org> wrote:
> The following patches fix 2 hard to hit races in relocation that make its
> first phase (MOVE_DATA_EXTENTS) miss extents, triggers a warning in the
> second phase (UPDATE_DATA_PTRS) and leaves metadata in an invalid state
> (file extent items pointing to areas corresponding to the deleted block
> group), leading to a BUG_ON() when attempting to read those extents after
> the relocation finishes.

Never saw this particular race/error, but decided to give these
patches a workout
to see whether they cause any new or unrelated problems.

Continuous rebalancing (full, partial) for ~30m while unpacking and
deleting kernel
trees on a 16GB tmpfs-backed loopback device did not cause any problem;
balance just cruises along at (sometimes) up to ~1GB/s and does its thing.
Finally btrfs check also found nothing wrong.

Not sure if this qualifies as testing, but anyway:

Tested-by: Holger Hoffstaette <holger.hoffstaette@googlemail.com>

cheers,
Holger
