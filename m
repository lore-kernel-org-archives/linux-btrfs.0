Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36102 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbcF1SG5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 14:06:57 -0400
Received: by mail-oi0-f41.google.com with SMTP id f189so34273353oig.3
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jun 2016 11:05:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5b7fbcfe-520a-cc00-f772-97a83fc9aa3d@fastmail.fm>
References: <5b7fbcfe-520a-cc00-f772-97a83fc9aa3d@fastmail.fm>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 28 Jun 2016 12:05:51 -0600
Message-ID: <CAJCQCtQXBhtMr71wcb9TW3gFycoKT1QEYj=+P59fW+FM+WogLQ@mail.gmail.com>
Subject: Re: Btrfs check command fails with "assertion failed" error
To: Francesco Turco <fturco@fastmail.fm>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 28, 2016 at 9:58 AM, Francesco Turco <fturco@fastmail.fm> wrote:
> When trying to repair a btrfs root filesystem I get the following error
> message:
>
> # losetup -f /home/fturco/Buffer/root-20160616.img
> # btrfs check --repair /dev/loop0
> enabling repair mode
> warning, device 4 is missing
> Checking filesystem on /dev/loop0
> UUID: 34fb5b58-f50f-47c3-a5b8-91d81a30eade
> checking extents
> Unable to find block group for 0
> extent-tree.c:289: find_search_start: Assertion `1` failed.

Well it probably shouldn't crash but the question is why is device 4
missing? We have no information what version of btrfs-progs or kernel
is used, or what the layout of this volume is: how many devices,
what's the profile breakdown, etc. Are you attempting to fix a
degraded volume and are the minimum number of devices present? Btrfs
fi show would be useful for this.

If it's relatively recent version of btrfs-progs then I'd file a bug
just because it shouldn't crash, it should give some sort of coherent
message about why it can't proceed.



-- 
Chris Murphy
