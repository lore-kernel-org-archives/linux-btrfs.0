Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45094 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772AbbCWVNl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 17:13:41 -0400
Date: Mon, 23 Mar 2015 17:13:35 -0400
From: Chris Mason <clm@fb.com>
To: Chris Murphy <chris@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: kvm bug, guest I/O blk device errors when qcow2 backing file is
 on Btrfs
Message-ID: <20150323211334.GA11155@ret.masoncoding.com>
References: <CAJCQCtSmjNVWZaqKr_NcOnpRbSn8mzfutz5jeTDrk=qAT-Z2Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAJCQCtSmjNVWZaqKr_NcOnpRbSn8mzfutz5jeTDrk=qAT-Z2Vw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 23, 2015 at 02:01:41PM -0600, Chris Murphy wrote:
> I can't tell if this is a kvm virtio blk device regression, with
> cache=none and cache=directsync, or if it's a Btrfs regression.
> 
> The summary is that on a host using (Fedora) kernel 3.18.9, 3.19.2, or
> any 4.0.0 kernel, with qcow2 on Btrfs, and either cache=none or
> directsync, the guest Linux OS experiences many I/O blk device errors.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1204569
> 
> If I put the qcow2 on XFS, the problem doesn't happen.
> 
> If I keep the qcow2 on Btrfs, and change the cache= to writeback,
> writethrough, or unsafe, the problem doesn't happen.
> 
> It happens with either qcow2 compat 0.10 or 1.1. Raw files were not
> tested. And block devices other than virtio were not tested.
> 
> In the guest, all file systems experience this and complain, some more
> than others. Btrfs is most tolerant mainly reporting write errors but
> completes an OS installation; ext4 complains a lot but also completes
> an OS installation; XFS complains and eventually gives up with a
> hardware I/O error and the OS installation fails.
> 
> I did this test maybe two years ago and this combination was safe at that time.

The last time we tracked down a similar problem, Josef found it was only
on windows guests.  Basically he tracked it down to buffers changing
while in flight.  I'll take a look.

-chris

