Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:39525 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752795AbeAHR11 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 12:27:27 -0500
Date: Mon, 8 Jan 2018 09:27:23 -0800
From: Tejun Heo <tj@kernel.org>
To: "jianchao.wang" <jianchao.w.wang@oracle.com>
Cc: jbacik@fb.com, jack@suse.cz, axboe@kernel.dk, clm@fb.com,
        kernel-team@fb.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, peterz@infradead.org,
        Bart.VanAssche@wdc.com
Subject: Re: [PATCH 5/7] blk-mq: remove REQ_ATOM_COMPLETE usages from blk-mq
Message-ID: <20180108172723.GY3668920@devbig577.frc2.facebook.com>
References: <20171216120726.517153-1-tj@kernel.org>
 <20171216120726.517153-6-tj@kernel.org>
 <64dfa760-d433-1537-9bc6-b12cda3c9dc6@oracle.com>
 <20171221135051.GE1084507@devbig577.frc2.facebook.com>
 <4e5aa629-f341-d077-961b-c778ceb31154@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4e5aa629-f341-d077-961b-c778ceb31154@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Jianchao.

On Fri, Dec 22, 2017 at 12:02:20PM +0800, jianchao.wang wrote:
> > On Thu, Dec 21, 2017 at 11:56:49AM +0800, jianchao.wang wrote:
> >> It's worrying that even though the blk_mark_rq_complete() here is
> >> intended to synchronize with timeout path, but it indeed give the
> >> blk_mq_complete_request() the capability to exclude with
>
> There could be scenario where the driver itself stop a request
> itself with blk_mq_complete_request() or some other interface that
> will invoke it, races with the normal completion path where a same
> request comes.

But what'd prevent the completion reinitializing the request and then
the actual completion path coming in and completing the request again?

> For example:
> a reset could be triggered through sysfs on nvme-rdma
> Then the driver will cancel all the reqs, including in-flight ones.
> nvme_rdma_reset_ctrl_work()
>     nvme_rdma_shutdown_ctrl()
>     >>>>
>         if (ctrl->ctrl.queue_count > 1) {
>             nvme_stop_queues(&ctrl->ctrl); //quiesce the queue
>             blk_mq_tagset_busy_iter(&ctrl->tag_set,
>                         nvme_cancel_request, &ctrl->ctrl); //invoke blk_mq_complete_request()
>             nvme_rdma_destroy_io_queues(ctrl, shutdown);
>         }
>     >>>>
> 
> These operations could race with the normal completion path of in-flight ones.
> It should drain all the in-flight ones first here. But there maybe some other
> places similar with this.

If there are any such places, they should be using an interface which
is propelry synchronized like blk_abort_request(), which btw is what
libata already does.  Otherwise, it's racy with or without these
patches.

Thanks.

-- 
tejun
