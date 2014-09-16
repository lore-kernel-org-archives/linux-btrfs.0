Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:34942 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751298AbaIPRRZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 13:17:25 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Problem with a filesystem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <54185D48.5060701@bordeaux.inra.fr>
Date: Tue, 16 Sep 2014 11:17:18 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <4F2E9AE1-4B33-42BB-8B75-C5A66118A7CB@colorremedies.com>
References: <54185D48.5060701@bordeaux.inra.fr>
To: Tovo Rabemanantsoa <tovo.rabemanantsoa@bordeaux.inra.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 16, 2014, at 9:54 AM, Tovo Rabemanantsoa <tovo.rabemanantsoa@bordeaux.inra.fr> wrote:

> Hi all,
> I have a server running debian 7.5 and meet issues for mounting a btrfs
> filesystem. This fs had worked for almost one year now but crashed last
> sunday. I'm unable to mount the fs and each btrfs-* commands ends with
> something like :
> Ignoring transid failure
> btrfsck: ctree.c:1550: leaf_space_used: Assertion `!(data_len < 0)' failed.
> Aborted
> 
> Ignoring transid failure
> btrfs-zero-log: ctree.c:1550: leaf_space_used: Assertion `!(data_len <
> 0)' failed.
> Aborted
> 
> 
> Ignoring transid failure
> btrfs: ctree.c:1550: leaf_space_used: Assertion `!(data_len < 0)' failed.
> Aborted
> 
> So, I can't fsck, restore, repair ou erase logs on it.
> I have followed what is told here [1] or there [2] but now, I'm out of
> ideas.

Debian 7.5 is based on kernel 3.2 which is very old in Btrfs terms. What kernel version are you using, and version of btrfs-progs?

Chris Murphy