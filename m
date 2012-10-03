Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:50663 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932930Ab2JCAV6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Oct 2012 20:21:58 -0400
Date: Tue, 2 Oct 2012 20:21:56 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Chen Yang <chenyang.fnst@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] Btrfs-progs, btrfsck: add block group check function
Message-ID: <20121003002156.GI3214@shiny>
References: <501A530D.2020107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <501A530D.2020107@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 02, 2012 at 04:14:37AM -0600, Miao Xie wrote:
> From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
> 
> This patch adds the function to check correspondence between block group,
> chunk and device extent.

Excellent, thank you.  Could you please put this into a git tree?  I'm
having trouble with whitespace (tabs -> spaces) in the patch.

-chris
