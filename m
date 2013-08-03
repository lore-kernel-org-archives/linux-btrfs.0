Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:53030 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3HCH5z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Aug 2013 03:57:55 -0400
Received: by mail-qc0-f169.google.com with SMTP id m15so790763qcq.0
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Aug 2013 00:57:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <kthh5l$7ti$1@ger.gmane.org>
References: <kthh5l$7ti$1@ger.gmane.org>
From: Bart Noordervliet <bart@noordervliet.net>
Date: Sat, 3 Aug 2013 09:57:34 +0200
Message-ID: <CAGy7UtgYQ9=_DcnXBEmLrNcmTycuLcwCxfenJAm87MVM3_SSXA@mail.gmail.com>
Subject: Re: Which better: rsync or snapshot + rsync --delete
To: Martin <m_btrfs@ml1.co.uk>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

though I can't determine which is 'better' for you because I don't
know what your aims are, I can recommend 'btrfs snapshot' together
with 'rsync --inplace'. It is 'better' in the sense of disk-usage,
because only the modified parts of files take up space in your
snapshots. That only applies if you use snapshots to retain multiple
historic versions of your backups, though. The cost is more
fragmentation, though snapshot-aware autodefrag (in-kernel since at
least 3.10) might help out a little there, and the fact that your
snapshot will be in an inconsistent state until rsync finishes
successfully.

Regards,

Bart


On Sat, Aug 3, 2013 at 1:59 AM, Martin <m_btrfs@ml1.co.uk> wrote:
> Which is 'best' or 'faster'?
>
> Take a snapshot of an existing backup and then "rsync --delete" into
> that to make a backup of some other filesystem?
>
> Or use "rsync --link" to link a new backup tree against a previous
> backup tree for the some other filesystem?
>
> Which case does btrfs handle the better?
>
> Would there be any problems for doing this over an nfs mount of the btrfs?
>
>
> Both cases can take advantage of the raid and dedup and compression
> features of btrfs. Would taking a btrfs snapshot be better than rsync
> creating the hard links to unchanged files?
>
> Any other considerations?
>
> (There are perhaps about 5% new or changed files each time.)
>
> Thanks,
> Martin
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
