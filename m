Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:54556 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbbAUM0J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Jan 2015 07:26:09 -0500
Received: by mail-lb0-f171.google.com with SMTP id u14so2453323lbd.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jan 2015 04:26:08 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAKVY-+9cjRKfXFVVEamtNVLaWE1+jc44M4kyrJOOk915v2fxtA@mail.gmail.com>
References: <CAKVY-+9cjRKfXFVVEamtNVLaWE1+jc44M4kyrJOOk915v2fxtA@mail.gmail.com>
Date: Wed, 21 Jan 2015 12:26:07 +0000
Message-ID: <CAL3q7H6+hdRSE_3E8NsR=NekUeLJxS6rcVBstYPriJfnfRLM-Q@mail.gmail.com>
Subject: Re: Snapshot cannot be deleted
From: Filipe David Manana <fdmanana@gmail.com>
To: Andreas Philipp <philipp.andreas@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 20, 2015 at 12:28 PM, Andreas Philipp
<philipp.andreas@gmail.com> wrote:
> Hi,
>
> Due to the known (and fixed) bug in kernel 3.17.0 one of my btrfs
> volume suffers from unreadable and - even worse - uneraseable
> snapshots. Whenever such a snapshot is accessed there is "parent
> transid verify failed" in dmesg.
> Is there any way to delete these snapshots?

It can be fixed with btrfs-progs v3.17 and later (3.18.x is the latest release).
To confirm that you are affected by the 3.17 kernel issue, run btrfsck
in readonly mode first (without --repair or any other flags), which
will print one message with the following format for each corrupt
snapshot:

"root %llu has a root item with a more recent gen (%llu) compared to
the found root node (%llu)\n"

Any other error messages are likely unrelated and therefore associated
with other eventual issues.
As usual, before running btrfsck with --repair (which fixes the issue
and the snapshots will be fully repaired), create backups of your
data.

Hope it helps.

>
> Thanks,
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
