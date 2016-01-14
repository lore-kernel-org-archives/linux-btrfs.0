Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36142 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbcANQNA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 11:13:00 -0500
Received: by mail-ig0-f179.google.com with SMTP id z14so179222030igp.1
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Jan 2016 08:13:00 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 14 Jan 2016 16:13:00 +0000
Message-ID: <CAGkb5vfzcOmj1Js=pBR6=-Uad7jY2bJy5ht3F-m-1TEOBjwCYA@mail.gmail.com>
Subject: Query about proposed dedup patches and behaviours
From: James Hogarth <james.hogarth@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The duperemove[1] tool is in the process for packaging for Fedora at
present but I was wondering what future this may have with the 4.5
dedup patches being proposed.

WIll the btrfs command have the ability to out-of-line dedup files
similar to duperemove (thus negating the need for it) or will this
only control in-line dedup with a tool like duperemove still being
required for periodic only (or restricted path) dedup?

To avoid memory usage bloat if the btrfs command can order dedup  of X
files on the path correctly can it be passed a path to carry the hash
map in some form (similar to how dupeemeove can use sqlite for this)
or is this another use case for the external tool?

Finally what's the present situation with regards to defragmentation
and deduplication? Is it safe to turn on autodefrag now when using
snapshots and duperemove? What should the behaviour be with the
proposed 4.5 dedup patches if both inline dedup and autodefrag are
enabled as mount options?

Cheers,

James

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1244678
