Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43160 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727058AbeGLGSS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 02:18:18 -0400
Subject: Re: Transaction aborted (error -28)
 btrfs_run_delayed_refs*0x163/0x190
To: Pete <pete@petezilla.co.uk>, linux-btrfs@vger.kernel.org
References: <c641cf2f-1b94-f7ed-3bb5-95a0c4bd2493@petezilla.co.uk>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <44fabb78-f0ec-d79c-be20-8689bd00d2cd@suse.com>
Date: Thu, 12 Jul 2018 09:10:12 +0300
MIME-Version: 1.0
In-Reply-To: <c641cf2f-1b94-f7ed-3bb5-95a0c4bd2493@petezilla.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.07.2018 10:04, Pete wrote:
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
> 
> I'm about to run a scrub.  On reboot the disks mounted fine.

Show the output of :

btrfs fi usage /path/to/fs


> 
> Pete
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
