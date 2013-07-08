Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38012 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3GHNY4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jul 2013 09:24:56 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4BBFB7C0689
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jul 2013 07:24:56 -0600 (MDT)
Date: Mon, 8 Jul 2013 09:24:53 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Franziska =?iso-8859-1?Q?N=E4pelt?=
	<franziska.naepelt@hiperscan.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs crashes
Message-ID: <20130708132453.GH2260@localhost.localdomain>
References: <51DA6039.9080107@hiperscan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <51DA6039.9080107@hiperscan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 08, 2013 at 08:46:17AM +0200, Franziska Näpelt wrote:
> Hi everybody,
> 
> we are using a btrfs RAID 1 with four 2TB hard drives on a Debian 7.1
> (Kernel 3.9.6).
> 
> After about one year of working, there was an error in messages log and the
> filesystem was mounted read-only.
> 
> After that I restarted the system but that doesn't fix the bug. The
> btrfs-filesystem couldn't be mounted.
> 
> I attach four logs:
> 
> -> when the error occured
> -> after the error occured
> -> when rebooting the system
> -> when I tried ti mount manually
> 
> Before I rebuilt the filesystem (formatting everything and creating a new
> btrfs-pool) I made a btrfs-image. I can provide it to you.
> 

Can you file a bugzilla at bugzilla.kernel.org (make sure the component is set
to btrfs) with all of this information and a link to the image, and the output
of btrfsck?  Please use the most recent version of btrfs-progs

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

Thanks,

Josef
