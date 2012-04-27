From: Josef Bacik <josef@redhat.com>
Subject: Re: worker list corruption crash
Date: Fri, 27 Apr 2012 09:41:02 -0400
Message-ID: <20120427134102.GA2088@localhost.localdomain>
References: <CAMVG2ssoaPFDj9cBtBByE4xXuENYo=SXipgP=XxrXKmqaK=78w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMVG2ssoaPFDj9cBtBByE4xXuENYo=SXipgP=XxrXKmqaK=78w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2012 at 10:26:27AM +0800, Daniel J Blueman wrote:
> In 3.4-rc4, I've come across worker list corruption while scrubbing,
> leading to (in two separate cases) warning [1] and crashing [2]. The
> connection with scrubbing is likely the increased rate of worker
> threads starting and stopping.
> 
> In btrfs_stop_workers, access to worker->worker_list is done without
> holding worker->lock (it is in all other callsites). We can't take
> worker->lock there due to lock inversion deadlock (as it is the outer
> lock), and if we drop the workers->lock to acquire worker->lock and
> then workers->lock, we can't guarantee worker is still valid.
> 
> If feels like a global workers list pointer should be used and it's
> lock should be the outer one to avoid this scenario, or maybe I'm
> missing something?
> 

I think you are missing something, as I read it we're always holding
workers->lock when we touch the worker_list, so we should be safe, so I wonder
what could be going on here...

Josef
