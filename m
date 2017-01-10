Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from untroubled.org ([69.5.1.51]:41071 "HELO untroubled.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
        id S1755899AbdAJWdX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 17:33:23 -0500
Date: Tue, 10 Jan 2017 16:33:19 -0600
From: Bruce Guenter <bruce@untroubled.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs subvolume delete --commit-after doesn't wait for deletions
Message-ID: <20170110223319.GA17070@untroubled.org>
References: <20170105014656.GA19542@untroubled.org>
 <495af306-19bc-6af1-4411-e2eefe143891@cn.fujitsu.com>
 <20170106224306.GA8756@untroubled.org>
 <811cdb20-3123-ba7d-376e-69a1a17ddb7e@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <811cdb20-3123-ba7d-376e-69a1a17ddb7e@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 09, 2017 at 09:44:15AM +0800, Qu Wenruo wrote:
> At 01/07/2017 06:43 AM, Bruce Guenter wrote:
> > On Thu, Jan 05, 2017 at 10:03:17AM +0800, Qu Wenruo wrote:
> >> To wait the deletion finish, please use "btrfs filesystem sync".
> >
> > That doesn't entirely work either. It does appear to wait for something,
> > but disk space available continues to increase after it exits.
> 
> Other than subvolume deleting, is there any other large file deletion?
> 
> File deletion in btrfs works in the same way, so the increasing disk 
> space may be related to delayed file deletion.

There is no other activity on the partition at all.

-- 
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/
