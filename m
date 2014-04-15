Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:36526 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaDOTXU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 15:23:20 -0400
Received: by mail-ob0-f181.google.com with SMTP id gq1so1416241obb.12
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 12:23:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397580617-13815-1-git-send-email-dsterba@suse.cz>
References: <1397580617-13815-1-git-send-email-dsterba@suse.cz>
Date: Tue, 15 Apr 2014 14:23:19 -0500
Message-ID: <CAKcLGm9ktxwiZ812P8Trw3GG3QrJhY0845ksNJa5-iwt22Q2yg@mail.gmail.com>
Subject: Re: [PATCH 3.15-rc2] btrfs: replace error code from btrfs_drop_extents
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 15, 2014 at 11:50 AM, David Sterba <dsterba@suse.cz> wrote:
> There's a case which clone does not handle and used to BUG_ON instead,
> (testcase xfstests/btrfs/035), now returns EINVAL. This error code is
> confusing to the ioctl caller, as it normally signifies errorneous
> arguments.
>
> Change it to ENOPNOTSUPP which allows a fall back to copy instead of
> clone. This does not affect the common reflink operation.
>

Minor spelling error in the commit message, you clearly mean
EOPNOTSUPP, not ENOPNOTSUPP.
