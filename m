Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37286 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755533AbbHYQ1I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 12:27:08 -0400
Date: Tue, 25 Aug 2015 12:27:03 -0400
From: Chris Mason <clm@fb.com>
To: Vincent Olivier <vincent@up4.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Response to Bcachefs Claims
Message-ID: <20150825162703.GA25661@ret.masoncoding.com>
References: <1440516154.040713246@apps.rackspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1440516154.040713246@apps.rackspace.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 11:22:34AM -0400, Vincent Olivier wrote:
> Hi,
> 
> I have been using Btrfs for almost a year now with a 16x4TB RAID10 and
> its 8x4TB RAID0 backup (using incremental snapshots diffs). I have
> always tried to stay at the latest stable kernel (currently 4.1.6).
> But I might be moving to Fedora 22 because Centos 7 has significant
> incompatibilities with the 4.1.x kernel series.
> 
> I have seen the news about Bcachefs aiming to be Btrfs-complete while
> being extX-stable.
> 
> What are the chances Bcachefs beats Btrfs at being the Linux kernel's
> next "official" file system ? I chose Btrfs over ZFS because it seemed
> like the only "next-gen" heir to ext4/xfs.

Kent is a smart guy, and I'm always glad to see more work in Linux
filesystems.  We all work on the parts we think are important and people
use the best tool they can find for their workloads.  Sometimes that'll
be btrfs, sometimes not.  Btrfs has certainly come a long way and is
continuing to improve pretty dramatically.

> 
> I have been having a few problems with Btrfs myself. I have only one
> that remains unresolved : I haven't found the best way to mount Btrfs
> at boot time. "LABEL=" won't work for known reasons (I don't
> understand however why a mount can't do its own "device scan"
> transparently). "UUID=" won't work for unknown reasons (haven't got a
> reply on this, maybe it's the same as "LABEL="). And I will use /dev/*
> in fstab for stability reasons. Right now I'm mounting the fs manually
> after a "device scan" and picking up the first device that shows up in
> the "fi show" run. I can "live" with that but I suppose that things
> like this contribute to the feeling that Btrfs is actually still
> experimental contrarily to claims that it is production-ready.
> 

LABEL= and UUID= both need a scan on multi device filesystems.  If your
initrd does it, things will work fine.

-chris
