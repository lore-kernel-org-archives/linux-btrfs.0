Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13232 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753494Ab3LJNZf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 08:25:35 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <clm@fb.com>
To: Pedro Fonseca <pfonseca@mpi-sws.org>, <linux-btrfs@vger.kernel.org>
References: <52A63302.4020301@mpi-sws.org>
In-Reply-To: <52A63302.4020301@mpi-sws.org>
Message-ID: <20131210132529.16869.59608@ret>
Subject: Re: Warning in inode_tree_add() -- !(entry->vfs_inode.i_state & (I_WILL_FREE
 | I_FREEING)
Date: Tue, 10 Dec 2013 08:25:29 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Pedro Fonseca (2013-12-09 16:15:46)
> Hi,
> 
> I've got multiple instances of warnings caused by the statement 
> "WARN_ON(!(entry->vfs_inode.i_state & (I_WILL_FREE | I_FREEING)));" in 
> inode_tree_add(). The tests were executed on the official 3.12.2 kernel. 
> Do you think it's something serious?

Definitely.  You're in the autodefrag code here and an iget is replacing
an existing inode that wasn't ready to be replaced.  What test are you
running?

-chris
