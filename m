Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:46244 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab2LKO5x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 09:57:53 -0500
Date: Tue, 11 Dec 2012 09:57:50 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: put delayed iput tracking list inside in-memory
 inode
Message-ID: <20121211145750.GC3126@localhost.localdomain>
References: <1354274683-17762-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1354274683-17762-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 30, 2012 at 04:24:43AM -0700, Liu Bo wrote:
> This can save us a dynamic memory allocation/free.
> 

You can have multiple outstanding delayed iputs per inode, so this will result
in inodes still being in use on unmount, so this isn't going to work.

Josef
