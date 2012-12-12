Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36981 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab2LLBw0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 20:52:26 -0500
Date: Wed, 12 Dec 2012 09:50:40 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: put delayed iput tracking list inside in-memory
 inode
Message-ID: <20121212015038.GD12318@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1354274683-17762-1-git-send-email-bo.li.liu@oracle.com>
 <20121211145750.GC3126@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121211145750.GC3126@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 11, 2012 at 09:57:50AM -0500, Josef Bacik wrote:
> On Fri, Nov 30, 2012 at 04:24:43AM -0700, Liu Bo wrote:
> > This can save us a dynamic memory allocation/free.
> > 
> 
> You can have multiple outstanding delayed iputs per inode, so this will result
> in inodes still being in use on unmount, so this isn't going to work.

Yeah, you're right, but what if we add a check

if (list_empty(&bi->iput_list))
	list_add(&bi->iput_list, &fs_info->iput_list));

Am I missing something?

thanks,
liubo
