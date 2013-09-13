Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:54202 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3IMFcS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 01:32:18 -0400
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Fri, 13 Sep 2013 10:53:37 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 27365394004D
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Sep 2013 11:01:59 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay03.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r8D5YBuu43450622
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Sep 2013 11:04:11 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r8D5WBGP020048
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Sep 2013 11:02:11 +0530
From: chandan <chandan@linux.vnet.ibm.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, chandra.seetharaman@us.ibm.com
Subject: Re: [PATCH] btrfs-progs: btrfs.8.in: Add info about reverting back to root subvolume.
Date: Fri, 13 Sep 2013 11:02:10 +0530
Message-ID: <4614565.o0AhkXtA95@localhost.localdomain>
In-Reply-To: <20130912132952.GB6810@twin.jikos.cz>
References: <2061327.l3bBKU3J9X@localhost.localdomain> <20130912132952.GB6810@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, September 12, 2013 03:29:52 PM David Sterba wrote:
> 
> The number 5 is an implementation detail, we should recommend to use 0.
>
In the current btrfs kernel code if 0 is passed as the subvolume id,
the btrfs_ioctl_default_subvol() function sets the subvolume id to the
objectid of the current subvolume. The patch provided at
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg17973.html
should fix the issue.

