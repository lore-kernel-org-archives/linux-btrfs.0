Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-6.smtp-out.eu-west-1.amazonses.com ([54.240.4.6]:47678 "EHLO
        a4-6.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751129AbeGJIiv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jul 2018 04:38:51 -0400
Subject: Re: Transaction aborted (error -28)
 btrfs_run_delayed_refs*0x163/0x190
To: Pete <pete@petezilla.co.uk>, linux-btrfs@vger.kernel.org
References: <c641cf2f-1b94-f7ed-3bb5-95a0c4bd2493@petezilla.co.uk>
From: Martin Raiber <martin@urbackup.org>
Message-ID: <010201648357d71c-04a86c88-517f-4aca-904b-ba94aae5d99f-000000@eu-west-1.amazonses.com>
Date: Tue, 10 Jul 2018 08:38:49 +0000
MIME-Version: 1.0
In-Reply-To: <c641cf2f-1b94-f7ed-3bb5-95a0c4bd2493@petezilla.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10.07.2018 09:04 Pete wrote:
> I've just had the error in the subject which caused the file system to
> go read-only.
>
> Further part of error message:
> WARNING: CPU: 14 PID: 1351 at fs/btrfs/extent-tree.c:3076
> btrfs_run_delayed_refs*0x163/0x190
>
> 'Screenshot' here:
> https://drive.google.com/file/d/1qw7TE1bec8BKcmffrOmg2LS15IOq8Jwc/view?usp=sharing
>
> The kernel is 4.17.4.  There are three hard drives in the file system.
> dmcrypt (luks) is used between btrfs and the disks.
This is probably a known issue. See
https://www.spinics.net/lists/linux-btrfs/msg75647.html
You could apply the patch in this thread and mount with enospc_debug to
confirm it is the same issue.
