Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42834 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934374AbdKBVLz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 17:11:55 -0400
Date: Thu, 2 Nov 2017 14:11:45 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH RFC] Btrfs: remove max_active and thresh
Message-ID: <20171102211144.GA22697@dhcp-10-11-181-183.us.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <20171030171440.27044-3-bo.li.liu@oracle.com>
 <94b02faa-8072-946e-3116-9348f683bc32@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <94b02faa-8072-946e-3116-9348f683bc32@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 31, 2017 at 07:53:47AM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年10月31日 01:14, Liu Bo wrote:
> > First and foremost, here are the problems we have right now,
> > 
> > a) %thread_pool is configurable via mount option, however for those
> >    'workers' who really needs concurrency, there are at most
> >    "min(num_cpus+2, 8)" threads running to process works, and the
> >    value can't be tuned after mount because they're tagged with
> >    NO_THRESHOLD.
> > 
> > b) For THRESHOLD workers, btrfs is adjusting how concurrency will
> >    happen by starting with the minimum max_active and calling
> >    btrfs_workqueue_set_max() to grow it on demand, but it also has a
> >    upper limit, "min(num_cpus+2, 8)", which means at most we can have
> >    such many threads running at the same time.
> 
> I was also wondering this when using kernel workqueue to replace btrfs
> workqueue.
> However at that time, oct-core CPU is even hard to find in servers.
> 
> > 
> > In fact, kernel workqueue can be created on demand and destroyed once
> > no work needs to be processed.  The small max_active limitation (8)
> > from btrfs has prevented us from utilizing all available cpus, and
> > that is against why we choose workqueue.
> 
> 
> Yep, I'm also wondering should we keep the old 8 threads up limits.
> Especially nowadays oct-core CPU is getting cheaper and cheaper (thanks
> AMD and its Ryzen).
> 
> > 
> > What this patch does:
> > 
> > - resizing %thread_pool is totally removed as they are no long needed,
> >   while keeping its mount option for compatibility.
> > 
> > - The default "0" is passed when allocating workqueue, so the maximum
> >   number of running works is typically 256.  And all fields for
> >   limiting max_active are removed, including current_active,
> >   limit_active, thresh etc.
> 
> Any benchmark will make this more persuasive.
> Especially using low frequency but high thread count CPU.
> 
> The idea and the patch looks good to me.
> 
> Looking forward to some benchmark result.
>

OK, will work out some numbers, and I'm going to make these workqueues
global for all btrfs on one system, the reason is that all unbound
workqueues have already shared kthreads belonged to all available numa
nodes, so no need to do it per-fs.

Thanks,

-liubo
