Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f54.google.com ([209.85.212.54]:61272 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3LKP7t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 10:59:49 -0500
Received: by mail-vb0-f54.google.com with SMTP id g10so1736278vbg.41
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 07:59:48 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 11 Dec 2013 15:59:48 +0000
Message-ID: <CALOYprXUt5DqRHWX0jvF8t3mLssiHVW46bXF7gW930hfyMuDUw@mail.gmail.com>
Subject: btrfs-progs integration branch versioning
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

It's not a big deal, but I've just noticed that the most recent
unstable-integration btrfs tools (built from [1]) are still reporting
their version as v0.20-rc1-638-g8e44385, rather than
v3.12-xxx-xxxxxxxx. I believe this is because the master branch in the
devel repository has not been tagged with the new version.

The github clone/mirror(?) of the devel repository [2] has no tags for
some reason, and the btrfs tools built from it report their version
simply as v0.20-rc1 or v3.12 (depending on which branch you check
out). This seems like a worse situation to me, as there's no way to
tell which branch they were built from.

I feel that this inconsistency is confusing, though I admit that
anyone using the devel repo should be competent enough to know what
branch they're checking out. Still, would it be possible to bring the
tags up to date, so that versions are consistent?

Thanks,


WorMzy Tykashi


[1] http://repo.or.cz/r/btrfs-progs-unstable/devel.git
[2] https://github.com/kdave/btrfs-progs
