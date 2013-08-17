Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:59393 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab3HQDTk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 23:19:40 -0400
Received: by mail-bk0-f50.google.com with SMTP id mz11so841003bkb.23
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 20:19:39 -0700 (PDT)
MIME-Version: 1.0
From: Tom Gundersen <teg@jklm.no>
Date: Sat, 17 Aug 2013 11:19:19 +0800
Message-ID: <CAG-2HqVFdRjnK1LHnLDPm8frw1MtG2k44N=n4hhdv9kpdf4VoQ@mail.gmail.com>
Subject: Question: btrfs-progs releases?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Chris Mason <chris.mason@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

I package btrfs-progs for Arch Linux, and I'm wondering about its
current status.

I have seen repeated talk of making regular releases, but so far we
haven't had a proper release since v19 four years ago.

Are we to take from this that btrfs-progs is not suitable for
distribution yet, and if so, would we be better off not shipping it at
all? Or are there other reasons releases are not made?

I get frequent requests for shipping new git snapshots, but I'd rather
not ship something that upstream does not deem ready for release.

Any guidance would be greatly appreciated.

Cheers,

Tom
