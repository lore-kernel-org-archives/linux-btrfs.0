Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52576 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932069AbeCITZI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Mar 2018 14:25:08 -0500
Subject: Re: Btrfs remounted read-only due to ENOSPC in btrfs_run_delayed_refs
To: Martin Svec <martin.svec@zoner.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <5a54af49-c18f-3534-7d58-5224363926c7@zoner.cz>
 <3622d05f-b31e-6f3d-a70c-d32c4667ef43@suse.com>
 <7ce06292-6598-2b97-11a3-93174ec597bc@zoner.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5165505d-4467-99a3-8392-57402db0c9a1@suse.com>
Date: Fri, 9 Mar 2018 21:25:05 +0200
MIME-Version: 1.0
In-Reply-To: <7ce06292-6598-2b97-11a3-93174ec597bc@zoner.cz>
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  9.03.2018 21:03, Martin Svec wrote:
> Being curious, how do you know that my global rsv is almost unused? During backups, I see that
> the usage is sometimes very close to the 512 MiB limit. I tried to increase the limit to 1 GiB but it
> didn't help.

Well according to your output:
 Global reserve:              512.00MiB      (used: 0.00B)

In the end it might turn out that you are indeed hitting enospc because
you can't free enough in the critical section of the transaction.
