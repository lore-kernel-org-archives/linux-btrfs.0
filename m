Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:33300 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab3FKNPP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 09:15:15 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 612BF7C0427
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 07:15:15 -0600 (MDT)
Date: Tue, 11 Jun 2013 09:15:12 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: anand jain <anand.jain@oracle.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] btrfs: add framework to read fs info and dev info
 from the kernel
Message-ID: <20130611131512.GA658@localhost.localdomain>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
 <1370876355-16584-1-git-send-email-anand.jain@oracle.com>
 <1370876355-16584-3-git-send-email-anand.jain@oracle.com>
 <20130610194030.GB10307@localhost.localdomain>
 <51B721B4.8030202@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51B721B4.8030202@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 11, 2013 at 07:10:12AM -0600, anand jain wrote:
> 
> 
> On 06/11/2013 03:40 AM, Josef Bacik wrote:
> > On Mon, Jun 10, 2013 at 08:59:15AM -0600, Anand Jain wrote:
> >> This adds two ioctl BTRFS_IOC_GET_FSIDS and BTRFS_IOC_GET_DEVS
> >> which reads the btrfs_fs_devices and btrfs_device structure
> >> from the kernel respectively.
> >>
> >> The information in these structure are useful to report the
> >> device/fs information in line with the kernel operations and
> >> thus immediately addresses the problem that 'btrfs fi show'
> >> command reports the stale information after device device add
> >> remove operation is performed. That is because btrfs fi show
> >> reads the disks directly.
> >>
> >> Further the frame-work provided here would help to enhance
> >> the btrfs-progs/library to read the other fs information and
> >> its device information. Also the frame work provided here is
> >> easily extensible to retrieve any other structure as future
> >> needs.
> >>
> >
> > Please submit an xfstest along with this to test the new functionality so we
> > have something to test it with.  Make sure it runs properly if your patches are
> > not in place since they obviously won't be for most people.  Once you have an
> > xfstest I can properly test these patches.  Thanks,
> 
>   This kernel patch supports a new cli option --kernel
>   under the existing command 'btrfs filesystem show'.
>   xfstest first of all would need testcase to test the
>   btrfs filesystem show which isn't there yet. Doing it
>   here deviate too much from the point here. But let
>   me try to quick get that.
> 

No you just need a testcase to make sure --kernel is working properly, so make
it use SCRATCH_DEV_POOL and do things like make a file system, remove a device,
make sure its no longer there, add it back and make sure it pops up again, that
sort of thing.  We are trying to make btrfs more stable and I have no interest
in taking in new features/ioctls without a way to test them properly, so it is
not beside the point.  Thanks,

Josef
