Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932404AbcF3O7G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 10:59:06 -0400
Date: Thu, 30 Jun 2016 22:58:53 +0800
From: Eryu Guan <eguan@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 5/6] fstests: btrfs: test RAID1 device reappear and
 balanced
Message-ID: <20160630145853.GH23649@eguan.usersys.redhat.com>
References: <1463495530-425-5-git-send-email-anand.jain@oracle.com>
 <1465980527-19031-1-git-send-email-anand.jain@oracle.com>
 <20160621133137.GY5140@eguan.usersys.redhat.com>
 <e4fb70f9-2e96-1c32-fbe7-0c1fa4cf8b95@oracle.com>
 <20160627092916.GU23649@eguan.usersys.redhat.com>
 <a845e059-4717-dd9f-ec34-37a66390fb50@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a845e059-4717-dd9f-ec34-37a66390fb50@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 30, 2016 at 07:04:06PM +0800, Anand Jain wrote:
> 
> 
> Thanks for review comments.
> more below..
> 
> On 06/27/2016 05:29 PM, Eryu Guan wrote:
> > On Wed, Jun 22, 2016 at 07:01:54PM +0800, Anand Jain wrote:
> > > 
> > > 
> > > On 06/21/2016 09:31 PM, Eryu Guan wrote:
> > > > On Wed, Jun 15, 2016 at 04:48:47PM +0800, Anand Jain wrote:
> > > > > From: Anand Jain <Anand.Jain@oracle.com>
> > > > > 
> > > > > The test does the following:
> > > > >   Initialize a RAID1 with some data
> > > > > 
> > > > >   Re-mount RAID1 degraded with _dev1_ and write up to
> > > > >   half of the FS capacity
> > > > 
> > > > If test devices are big enough, this test consumes much longer test
> > > > time. I tested with 15G scratch dev pool and this test ran ~200s on my
> > > > 4vcpu 8G memory test vm.
> > > 
> > >  Right. Isn't that a good design? So that it gets tested differently
> > >  on different HW config. ?
> > 
> > Not in fstests. We should limit the run time of tests to an acceptable
> > amount, for auto group it's within 5 minutes.
> 
> > >  However the test time can be reduced by using smaller vdisk.
> > 
> > I think either limit the write size or _notrun if the $max_fs_size is
> > too big (say 30G).
> 
> Fixed in v3 to have a fixed scratch data.

Thanks! I've queued this patchset up, will let them go through some
testings.

Thanks,
Eryu
