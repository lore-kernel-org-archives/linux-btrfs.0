Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177AbcD2J7N (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:59:13 -0400
Date: Fri, 29 Apr 2016 05:59:11 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ming Lei <ming.lei@canonical.com>
cc: Jens Axboe <axboe@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Alan Cox <alan@linux.intel.com>, Neil Brown <neilb@suse.de>,
        Liu Bo <bo.li.liu@oracle.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 3/3] block: avoid to call .bi_end_io() recursively
In-Reply-To: <CACVXFVMp_zzs0GKJ0Yme8WBCNxD-uSPkVvyVwycJ6rpnZkivqg@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1604290541300.25113@file01.intranet.prod.int.rdu2.redhat.com>
References: <1461805789-3632-1-git-send-email-ming.lei@canonical.com> <1461805789-3632-3-git-send-email-ming.lei@canonical.com> <alpine.LRH.2.02.1604281127130.14065@file01.intranet.prod.int.rdu2.redhat.com> <CACVXFVPgPh3snp-B6=G9fShzJwwKz2NyQETSnMJBGp=HzTL_-w@mail.gmail.com>
 <alpine.LRH.2.02.1604281157180.6220@file01.intranet.prod.int.rdu2.redhat.com> <CACVXFVN7bE3tFs9KVGX-M3LCvOr0WuCMwyoGiW4qu5G4h8EzhA@mail.gmail.com> <alpine.LRH.2.02.1604281218180.10827@file01.intranet.prod.int.rdu2.redhat.com>
 <CACVXFVPSZWMTCOT0F__88pPr4T90t17etCv78EyLtpJjTSETSg@mail.gmail.com> <alpine.LRH.2.02.1604290430050.11338@file01.intranet.prod.int.rdu2.redhat.com> <CACVXFVMp_zzs0GKJ0Yme8WBCNxD-uSPkVvyVwycJ6rpnZkivqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 29 Apr 2016, Ming Lei wrote:

> > If some block device driver in a process context finds out that it needs
> > to terminate a bio, it calls bio_endio in a process context. Why would it
> > need to trigger an interrupt just to call bio_endio? (and how could it
> > trigger an interrupt if that driver perhaps doesn't use interrupts at
> > all?) I don't know what are you trying to suggest.
> 
> That should be the failure path, and this patch just aims at the normal bio
> complete path which is run at 99.999% time. And irq handler often
> borrows current process's stack and cause huge stack uses.

For some block devices it is common to call bi_endio from process context, 
for example dm-crypt or dm-verity do it for all read bios. loop driver 
calls bi_endio from process context on every bio it processes.

> >> It isn't easy to avoid the recursive calling in process context except you
> >> can add something 'task_struct' or introduce 'alloca()' in kernel. Or do you
> >> have better ideas?
> >
> > preempt_disable around the bi_endio callback should be sufficient.
> 
> How can a sleepable function be run in preempt disabled context?
>
> Looks you still don't believe the bi_endio scheduled to process context
> can sleep, do you?

I don't believe bi_endio function can sleep. bi_endio function doesn't 
know if it will be called from process or interrupt context - so it can't 
sleep. If bi_endio function slept, bug would happen if it were called from 
interrupt context.

btrfs is a special case where btrfs calls bio_endio on bios that it 
created on it own (note that this trick only works when the same driver 
creates a bio and terminates the bio with bio_endio - if some other driver 
terminated the bio, it wouldn't work because the other driver could 
terminate the bio from interrupt context).

That could be simply fixed by calling bio->bi_end_io or 
btrfs_endio_direct_read directly or making a new function btrfs_endio.

> >> Not mention wait_for_completion() in both __btrfs_correct_data_nocsum()
> >> and __btrfs_subio_endio_read(), which are called by btrfs_subio_endio_read()
> >> in btrfs_endio_direct_read().
> >
> > btrfs is calling bio_endio on bio that it created. So, bio_endio in btrfs
> > can be replaced with:
> > if (bio->bi_end_io == btrfs_endio_direct_read)
> >         btrfs_endio_direct_read(bio);
> > else
> >         bio_endio(bio);
> >
> > ... or just maybe just with this:
> > bio->bi_end_io(bio);
> 
> It is really ugly and should be avoided most of times.
> 
> >
> > This could be fixed easily.
> 
> Suppose it might be done in this way, and there may be other .bi_end_io
> which can sleep too, you need to make sure there isn't any such usage
> first before running it with preempt disabled.
> 
> Anyway looks you worry about the seldom-run failure path, which isn't
> addressed by this patch. And you can optimize that in future and that isn't
> contradictory with this patch.

Worrying about seldom-run failrure paths is nothing wrong. These paths are 
not any less important than the common code paths.

Mikulas

> Thanks,
> Ming
