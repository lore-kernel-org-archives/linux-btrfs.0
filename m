Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754294AbeEaJuc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 05:50:32 -0400
Date: Thu, 31 May 2018 11:47:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4.1b 2/3] btrfs: balance: add args info during start and
 resume
Message-ID: <20180531094747.GM3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180523063508.18695-3-anand.jain@oracle.com>
 <20180525030547.23367-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180525030547.23367-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 25, 2018 at 11:05:47AM +0800, Anand Jain wrote:
> Balance arg info is an important information to be reviewed for the
> system audit. So this patch adds them to the kernel log.
> 
> Example:
> ->btrfs bal start -f -mprofiles=raid1,convert=single,soft -dlimit=10..20,usage=50 /btrfs
> 
> kernel: BTRFS info (device sdb): balance: start -f -dusage=50,limit=10..20 -msoft,profiles=raid1,convert=single -ssoft,profiles=raid1,convert=single
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v4->v4.1b: Rename last missed sz to size_buf.

Please send a full version instead of the incremental bumps to
individual patches. I try to take the last version but am never sure
what exactly gets merged.

> +static u32 describe_balance_args(struct btrfs_balance_args *bargs, char *buf,
> +				 u32 size_buf)
> +{
> +	char *bp = buf;
> +	u64 flags = bargs->flags;
> +	char tmp_buf[128];
> +
> +	if (!flags)
> +		return 0;
> +
> +	if (flags & BTRFS_BALANCE_ARGS_SOFT)
> +		bp += snprintf(bp, buf - bp + size_buf, "soft,");

I have some suspicion that this snprintf conscturct is not safe when the
value of 'buf - bp + size_buf' becomes accidentally negative. A quick
test showed that a sequence of snprintf and incremented bp does not stop
writing when the size_buf limit is hit and happily overwrites the
memory.

We'd have to check that the negative value is never passed to snprintf.
The patches are potponed until the issue is resolved, either to verify
that it's a false alert or the bounds are correctly checked.

The bug should not be in the original code as the buffer is known to be
large enough for all the printed bg flags.

I'm sorry to delay the patches, the log messages are useful, but I want
to be sure that there are no random memory overwrites introduced.
