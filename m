Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:36441 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbeHVEIF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Aug 2018 00:08:05 -0400
MIME-Version: 1.0
Message-ID: <trinity-027dce98-0517-4aae-b76c-aa383a151d9b-1534898719880@3c-app-mailcom-bs13>
From: "Su Yue" <Damenly_Su@gmx.com>
To: "Nikolay Borisov" <nborisov@suse.com>
Cc: damenly.su@gmail.com, linux-btrfs@vger.kernel.org,
        "Su Yue" <suy.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 0/2] btrfs-progs: task: add prefn() to task_info and
 simplify task_start()
Content-Type: text/plain; charset=UTF-8
Date: Wed, 22 Aug 2018 02:45:19 +0200
In-Reply-To: <ddba11ae-495a-58e1-59a8-c9ffc7cf868d@suse.com>
References: <20180821182311.13997-1-suy.fnst@cn.fujitsu.com>
 <ddba11ae-495a-58e1-59a8-c9ffc7cf868d@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> Sent: Wednesday, August 22, 2018 at 3:38 AM
> From: "Nikolay Borisov" <nborisov@suse.com>
> To: damenly.su@gmail.com, linux-btrfs@vger.kernel.org
> Cc: "Su Yue" <suy.fnst@cn.fujitsu.com>
> Subject: Re: [PATCH 0/2] btrfs-progs: task: add prefn() to task_info and simplify task_start()
>
> 
> 
> On 21.08.2018 21:23, damenly.su@gmail.com wrote:
> > From: Su Yue <suy.fnst@cn.fujitsu.com>
> > 
> > This patchset is a prepare work for further process of check.
> > 
> > patch[1] adds prefn() to task_info and call it before pthread_create().
> > 
> > patch[2] moves time and count initializations into the new init_ctx(),
> > assign it to prefun(). Remove arguments start_time and item_count.
> > 
> 
> The patches look good albeit being isolated it's hard to see their
> merit. I'd advise to submit them alongside whatever larger refactoring
> you have in mind.
> 
OK, it will be submitted together with others.

Thanks,
Su

> > 
> > Su Yue (2):
> >   btrfs-progs: task: add prefn() into struct task_info
> >   btrfs-progs: task: add init_ctx and clean up arguments of task_start()
> > 
> >  check/main.c   | 27 +++++++++++++++++++--------
> >  convert/main.c |  6 +++---
> >  task-utils.c   | 17 +++++++++--------
> >  task-utils.h   |  5 +++--
> >  4 files changed, 34 insertions(+), 21 deletions(-)
> > 
> 
