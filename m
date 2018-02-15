Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57820 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1426422AbeBOQpz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 11:45:55 -0500
Date: Thu, 15 Feb 2018 17:43:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs: verify max_inline mount parameter
Message-ID: <20180215164338.GC10193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180213094950.9412-1-anand.jain@oracle.com>
 <20180213094950.9412-2-anand.jain@oracle.com>
 <20180213162822.GW3003@twin.jikos.cz>
 <74fb8a4b-24d7-7871-8050-2c4e3113580c@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <74fb8a4b-24d7-7871-8050-2c4e3113580c@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 15, 2018 at 01:20:55AM +0800, Anand Jain wrote:
> 
> 
> On 02/14/2018 12:28 AM, David Sterba wrote:
> > On Tue, Feb 13, 2018 at 05:49:50PM +0800, Anand Jain wrote:
> >> We aren't verifying the parameter passed to the max_inline mount option,
> >> so we won't report and fail the mount if a junk value is specified for
> >> example, -o max_inline=abc.
> >> This patch converts the max_inline option to %d and checks if it's a
> >> number >= 0.
> > 
> > As the max_inline is a size, the suffixes are allowed here and this is
> > documented in the btrfs(5) page. I've checked all current options and
> > max_inline should be the only one where we want the suffixes.
> 
>   Oh. I ran out of ideas how to fix this.
>   One idea is ... step1: memparse() 4K (for example) so we would get
>   4096, step2: convert obtained 4096 back to 4K and step3: do string cmp
>   of step1 and step2. This way we eliminate other junk chars passed.
>   But looks like there isn't any tool to do the step2.

Memparse has 2nd parameter that will point after the parsed string, so
we can check if it's empty. This is already done in the resize string
parsing	(in btrfs_ioctl_resize), but missing from other memparse uses.
