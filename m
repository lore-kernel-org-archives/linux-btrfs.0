Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33085 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab3DBAqs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2013 20:46:48 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 1E2179A0356
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Apr 2013 18:46:48 -0600 (MDT)
Date: Mon, 1 Apr 2013 20:46:45 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Roman Mamedov <rm@romanrm.ru>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS error in __btrfs_inc_extent_ref:1935: Object already exists
Message-ID: <20130402004645.GM1876@localhost.localdomain>
References: <20130401041540.4b8a4ab3@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130401041540.4b8a4ab3@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 31, 2013 at 04:15:40PM -0600, Roman Mamedov wrote:
> Hello,
> 
> Trying to balance a 2TB filesystem on the 3.8.5 kernel:
> 
> Label: 'p2'  uuid: 01f6cc8b-d305-40e1-bac8-8fdd548f611e
> 	Total devices 1 FS bytes used 1.32TB
> 	devid    1 size 1.80TB used 1.37TB path /dev/sda2
> 
> System: total=4.00MB, used=156.00KB
> Data+Metadata: total=1.37TB, used=1.32TB
> 
> I am getting a Segmentation fault in 'btrfs' utility, and following in dmesg.
> What is the problem here?
> 

I just posted a patch for this bug, I can mount your image now without it
panicing and it passes fsck on either side of the mount.  Let me know if it
doesn't work for you.  Thanks,

Josef
