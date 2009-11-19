From: John Dong <jdong@ubuntu.com>
Subject: Re: btrfsctl -d race with df -h causes hang?
Date: Thu, 19 Nov 2009 18:10:35 -0500
Message-ID: <30183CDB-9359-493D-B400-3312291C968B@ubuntu.com>
References: <549778BA-0D47-458D-8CE1-022885B2A2BB@ubuntu.com>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: John Dong <jdong@ubuntu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <549778BA-0D47-458D-8CE1-022885B2A2BB@ubuntu.com>
List-ID: <linux-btrfs.vger.kernel.org>

I forgot to mention, this is using Ubuntu Karmic's 2.6.31 kernel, with btrfs modules built from the btrfs-unstable.git latest head.
On Nov 19, 2009, at 6:05 PM, John Dong wrote:

> While attempting to do a full filesystem defrag and checking output of df -h, I've been able to fairly consistently generate a hang:
> 
> 
> i.e. find / -type f -print0 | xargs -0i btrfsctl -d '{}'
> 
> and in another terminal, did "watch df -h"
> 
> Before long, everything hangs, iowait is near 100%, and no IO happens. I'm unable to get anything out of the kernel logs postmortem, dmesg also hangs.
> 
> 
> FWIW, I was mounted -o compress.--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

