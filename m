Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aristoteles.cuci.nl ([212.125.128.18]:56320 "EHLO
	aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbbLaQ17 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Dec 2015 11:27:59 -0500
Date: Thu, 31 Dec 2015 17:27:57 +0100
From: "Stephen R. van den Berg" <srb@cuci.nl>
To: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/send.c:1482
Message-ID: <20151231162757.GB5579@cuci.nl>
References: <20151231160416.GA5579@cuci.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151231160416.GA5579@cuci.nl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stephen R. van den Berg wrote:
>I'm running 4.4.0-rc7.
>This exact problem was present on 4.0.5 and 4.3.3 too though.

>I do a "btrfs send /var/lib/lxc/template64/rootfs", that generates
>the following error consistently at the same file, over and over again:

>Dec 29 14:49:04 argo kernel: kernel BUG at fs/btrfs/send.c:1482!

Ok, found part of the solution.
The kernel bug was being triggered by symbolic links in that
subvolume that have an empty target.  It is unknown how
these ever ended up on that partition.

The partitions have been created using regular btrfs.
The only strange thing that might have happened, is that I ran duperemove
over those partitions afterward.
-- 
Stephen.
