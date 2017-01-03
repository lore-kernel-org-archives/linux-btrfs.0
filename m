Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38099 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934612AbdACQVk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jan 2017 11:21:40 -0500
Date: Tue, 3 Jan 2017 17:21:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs: btrfs_defrag_root() doesn't support any option
Message-ID: <20170103162124.GQ12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161221074208.32597-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161221074208.32597-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 21, 2016 at 03:42:07PM +0800, Anand Jain wrote:
> Both BTRFS_IOC_DEFRAG and BTRFS_IOC_DEFRAG_RANGE call the same
> function- btrfs_ioctl_defrag(), however BTRFS_IOC_DEFRAG does
> not support any argument, so check that and return not supported
> if provided. This has valid impact at the user end, in the cli below
>   btrfs filesystem defrag -clzo /btrfs
> the -c option (or similarly other) is only applicable to the file
> defrag, which is either provided in the argument or when used along
> with the -r option, however as of now the above cli does not report
> any error. This patch will fix it.

I think it would be better to do the sanitization on the userspace side.
In this case combination of a compression option and bare directory
would not lead to the expected result.

IMO it's deciding between

  "pass any arguments to kernel" - here returning EOPNOTSUPP would be
  quite unclear what went wrong

vs.

  "validate as much arguments as we can before passing to kernel" - and
  we'll know early that the combination is not valid, also that we want
  to deprecate it etc.

I vote for #2 as we have enough information to give an informative error
message.
