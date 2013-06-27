Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:50208 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3F0N6p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 09:58:45 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 2EA749A0694
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 07:58:45 -0600 (MDT)
Date: Thu, 27 Jun 2013 09:58:42 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?Q?St=E9phane?= Mutz <stephane.mutz@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Problem with btrfsck / couurpted filesystem
Message-ID: <20130627135842.GQ4288@localhost.localdomain>
References: <51CC4419.6030108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <51CC4419.6030108@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 27, 2013 at 03:54:33PM +0200, Stéphane Mutz wrote:
> Hello,
> 
> I'm trying to fix a btrfs file system. BTRFSCK reports errors in the
> extend tree.
> I've tryong to use --repair option but it ended up with an assertion
> failure.
> 
> I'm also trying to understand how the filesystem can have become corrupted.
> I'm running Ubuntu 12.10.
> 
> Any suggestion on ways to fix the problem would be really appreciated.
> 

Are you using the btrfs-progs from git?  If not pull that down and build it and
run the btrfsck in there, and then capture the output if it fails.  Thanks,

Josef
