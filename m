Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60434 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751573AbeDETQu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Apr 2018 15:16:50 -0400
Date: Thu, 5 Apr 2018 21:16:48 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: dsterba@suse.cz, Sasha Levin <Alexander.Levin@microsoft.com>,
        Liu Bo <bo.liu@linux.alibaba.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix NULL pointer dereference in log_dir_items
Message-ID: <20180405191648.GB19589@kroah.com>
References: <1522691988-127156-1-git-send-email-bo.liu@linux.alibaba.com>
 <DM5PR2101MB1032B5A71C5024A50654000AFBBB0@DM5PR2101MB1032.namprd21.prod.outlook.com>
 <20180405171114.GL2635@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180405171114.GL2635@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 05, 2018 at 07:11:14PM +0200, David Sterba wrote:
> On Thu, Apr 05, 2018 at 04:42:34PM +0000, Sasha Levin wrote:
> > Hi.
> > 
> > [This is an automated email]
> > 
> > This commit has been processed by the -stable helper bot and determined
> > to be a high probability candidate for -stable trees. (score: 9.9156)
> > 
> > The bot has tested the following trees: v4.15.15, v4.14.32, v4.9.92, v4.4.126, 
> > 
> > v4.15.15: Build OK!
> > v4.14.32: Build OK!
> > v4.9.92: Build OK!
> > v4.4.126: Build OK!
> > 
> > Please let us know if you'd like to have this patch included in a stable tree.
> 
> Yes, in this case we expect that the Fixes: tag will let the patch flow
> to stable after it gets applied to master.

Fixes: tags almost never cause that to happen, unless I am bored and go
digging for them.

Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly if you want a patch applied to the stable
tree.

thanks,

greg k-h
