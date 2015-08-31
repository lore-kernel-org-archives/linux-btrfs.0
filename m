Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36981 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751862AbbHaGQE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 02:16:04 -0400
Date: Sun, 30 Aug 2015 23:15:57 -0700
From: Omar Sandoval <osandov@fb.com>
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: mount command now shows subvol and subvolid
Message-ID: <20150831061557.GA18469@huxley.hsd1.ca.comcast.net>
References: <CAJCQCtSx8yvtbm+7i3bNtv1DaRtTAgRTdk+iMTrk5nNhssgRLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAJCQCtSx8yvtbm+7i3bNtv1DaRtTAgRTdk+iMTrk5nNhssgRLQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 30, 2015 at 11:17:44AM -0600, Chris Murphy wrote:
> Does anyone know when this changed? Maybe it's a 4.2 thing... anyway
> it's very much welcome!
> 
> /dev/sda2 on /home type btrfs
> (rw,relatime,seclabel,space_cache,subvolid=258,subvol=/home)
> 
> /dev/sdc1 on /brick0 type btrfs
> (rw,relatime,seclabel,space_cache,subvolid=5,subvol=/)
> 
> /dev/sde on /brick1 type btrfs
> (rw,relatime,seclabel,space_cache,subvolid=5,subvol=/)
> 
> 
> 
> 
> -- 
> Chris Murphy

Yup, 4.2 :)

c8d3fe028f64 Btrfs: show subvol= and subvolid= in /proc/mounts
05dbe6837b60 Btrfs: unify subvol= and subvolid= mounting
bb289b7be62d Btrfs: fail on mismatched subvol and subvolid mount options
fa3306595071 Btrfs: clean up error handling in mount_subvol()
e6e4dbe894ef Btrfs: remove all subvol options before mounting top-level
773cd04ec191 Btrfs: lock superblock before remounting for rw subvol

-- 
Omar
