From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs hung tasks
Date: Thu, 28 Jul 2011 10:22:54 -0400
Message-ID: <20110728142253.GA3524@dhcp231-156.rdu.redhat.com>
References: <20110728062343.GA4656@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110728062343.GA4656@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2011 at 07:23:43AM +0100, Stephane Chazelas wrote:
> Hiya, I got below those last night. That was 3 minutes after a
> bunch of rsync and ntfsclone processes started.
> 
> It's the first time it happens. I upgraded from 3.0rc6 to 3.0
> yesterday.
> 

Ok I fixed that recently and Chris just sent it to Linus.  The patch you are
looking for is

Btrfs: use a worker thread to do caching

Thanks,

Josef
