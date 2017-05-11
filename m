Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40103 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757292AbdEKSkf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 14:40:35 -0400
Date: Thu, 11 May 2017 20:40:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com,
        fdmanana@gmail.com
Subject: Re: [PATCH v3] btrfs: relocation: Enhance kernel error output for
 relocation
Message-ID: <20170511184021.GG27439@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170215013905.17677-1-quwenruo@cn.fujitsu.com>
 <20170509172943.GI5491@twin.jikos.cz>
 <436b506c-4ab7-408c-130b-1cebe00f2746@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <436b506c-4ab7-408c-130b-1cebe00f2746@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 10, 2017 at 11:39:40AM +0800, Qu Wenruo wrote:
> 
> 
> At 05/10/2017 01:29 AM, David Sterba wrote:
> > On Wed, Feb 15, 2017 at 09:39:05AM +0800, Qu Wenruo wrote:
> >> When balance(relocation) fails, btrfs-progs will report like:
> >>
> >> ERROR: error during balancing '/mnt/scratch': Input/output error
> >> There may be more info in syslog - try dmesg | tail
> >>
> >> However kernel can't provide may useful info in many cases to locate the
> >> problem.
> >>
> >> This patch will add error messages in relocation to help user and
> >> developer to locate the problem.
> > 
> > I think it's too verbose for a user, and not really helpful what to do
> > after such error message appears in the log. The errors translate name
> > of the last function that failed, so the user would need to be familiar
> > with the inner workings of the balance to make sense of it.
> 
> Yes, normal user may never need such verbose output.
> 
> But it will help developers or support guys to wipe out some really easy 
> cases.
> 
> > 
> > The meessages may make sense to a developer, but then it's not necessary
> > to print them as btrfs_err, but btrfs_debug.
> 
> I also considered btrfs_debug, but the problem is btrfs_debug() depend 
> on either CONFIG_DYANMIC_DEBUG or DEBUG.
> 
> So when problem happens in real world, we're too late to ensure such output.

The I think we need some way that is not as noisy as btrfs_err but also
compiled-in by default unlike the dynamic debug.
