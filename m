Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43007 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbcDZOXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 10:23:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7B43D20142
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 14:23:04 +0000 (UTC)
Received: from mail-ig0-f178.google.com (mail-ig0-f178.google.com [209.85.213.178])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 2286D20138
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 14:23:03 +0000 (UTC)
Received: by mail-ig0-f178.google.com with SMTP id bi2so98211331igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 07:23:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHji153V8MOcdf6immv3_3CgsZNAR_KHEsj+BHeg0vV-WE5M-w@mail.gmail.com>
References: <1461546072-11154-1-git-send-email-fdmanana@kernel.org>
	<CAHji153V8MOcdf6immv3_3CgsZNAR_KHEsj+BHeg0vV-WE5M-w@mail.gmail.com>
Date: Tue, 26 Apr 2016 15:23:02 +0100
Message-ID: <CAL3q7H5-pkMBX3OARTD29ExjMPUpmcQ0OCNsCbMAxmdc-fV-FQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Fixes for races in relocation and avoid start and
 wait for unrelated IO
From: Filipe Manana <fdmanana@kernel.org>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 26, 2016 at 2:42 PM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:
> On Mon, Apr 25, 2016 at 3:01 AM,  <fdmanana@kernel.org> wrote:
>> The following patches fix 2 hard to hit races in relocation that make its
>> first phase (MOVE_DATA_EXTENTS) miss extents, triggers a warning in the
>> second phase (UPDATE_DATA_PTRS) and leaves metadata in an invalid state
>> (file extent items pointing to areas corresponding to the deleted block
>> group), leading to a BUG_ON() when attempting to read those extents after
>> the relocation finishes.
>
> Never saw this particular race/error, but decided to give these
> patches a workout
> to see whether they cause any new or unrelated problems.
>
> Continuous rebalancing (full, partial) for ~30m while unpacking and
> deleting kernel
> trees on a 16GB tmpfs-backed loopback device did not cause any problem;
> balance just cruises along at (sometimes) up to ~1GB/s and does its thing.
> Finally btrfs check also found nothing wrong.
>
> Not sure if this qualifies as testing, but anyway:
>
> Tested-by: Holger Hoffstaette <holger.hoffstaette@googlemail.com>

Thanks. I've now realized I sent the wrong version and patch 1
shouldn't be in the set. I'll resend a v2.


>
> cheers,
> Holger
