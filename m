Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751792AbdCUGHw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Mar 2017 02:07:52 -0400
Date: Tue, 21 Mar 2017 14:05:33 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Btrfs in-band de-duplication test cases
Message-ID: <20170321060533.GS14226@eguan.usersys.redhat.com>
References: <20170316090851.21608-1-quwenruo@cn.fujitsu.com>
 <20170321045155.GR14226@eguan.usersys.redhat.com>
 <5a01bd29-d691-24e0-8c8f-3c5dc30370ca@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5a01bd29-d691-24e0-8c8f-3c5dc30370ca@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 21, 2017 at 01:22:33PM +0800, Qu Wenruo wrote:
> 
> 
> At 03/21/2017 12:51 PM, Eryu Guan wrote:
> > Hi Qu,
> > 
> > On Thu, Mar 16, 2017 at 05:08:48PM +0800, Qu Wenruo wrote:
> > > Btrfs in-band de-duplication test cases for in-memory backend, which covers
> > > the bugs exposed during the development.
> > 
> > Do you have a kernel tree that contains the in-band patches so that I
> > and others could try and run these tests?
> 
> Of course.
> 
> Kernel tree:
> https://github.com/adam900710/linux.git wang_dedupe_latest
> 
> Btrfs-progs tree:
> https://github.com/adam900710/btrfs-progs.git dedupe_20170306

Thanks! But I guess it's branch 'dedupe_20170316' of btrfs-progs repo,
right? There's no dedupe_20170306 branch.

Thanks,
Eryu
