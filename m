Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:50534 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3F0Od6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 10:33:58 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 8FEAD9A0694
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 08:33:58 -0600 (MDT)
Date: Thu, 27 Jun 2013 10:33:55 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?Q?St=E9phane?= Mutz <stephane.mutz@gmail.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Problem with btrfsck / couurpted filesystem
Message-ID: <20130627143355.GR4288@localhost.localdomain>
References: <51CC4419.6030108@gmail.com>
 <20130627135842.GQ4288@localhost.localdomain>
 <51CC4AF1.2090209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <51CC4AF1.2090209@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 27, 2013 at 04:23:45PM +0200, Stéphane Mutz wrote:
> Hi,
> 
> I've built the GIT tools and run btrfsck (without options) following the
> wiki page.
> I got the following log:
> Checking filesystem on /dev/VG_NL-SAS/LV_snap
> UUID: de300fd0-1251-4767-9d80-84ce7ebfba9a
> checking extents
> checking free space cache
> free space inode generation (0) did not match free space cache
> generation (16583)
> free space inode generation (0) did not match free space cache
> generation (16579)
> checking fs roots
> checking csums
> checking root refs
> found 120489896006 bytes used err is 0
> total csum bytes: 380818020
> total tree bytes: 10396295168
> total fs tree bytes: 9423839232
> total extent tree bytes: 473616384
> btree space waste bytes: 1923163802
> file data blocks allocated: 455172272128
>  referenced 564086325248
> Btrfs v0.20-rc1-335-gf00dd83
> 
> It does not report any extends error.
> Can I consider all is fine now?
> 

Yup.  If you still have problems its likely just a kernel bug and not a
corruption problem.  And if that's the case dmesg would be nice so we can see
whats going on.  Thanks,

Josef
