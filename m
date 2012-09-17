Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45893 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab2IQCVI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Sep 2012 22:21:08 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8H2L2F3012351
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 10:21:03 +0800
Message-ID: <5056890C.5020208@cn.fujitsu.com>
Date: Mon, 17 Sep 2012 10:21:00 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: cleanup duplicated division functions
References: <5051BAB8.7080200@cn.fujitsu.com> <20120914135418.GM17430@twin.jikos.cz>
In-Reply-To: <20120914135418.GM17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On fri, 14 Sep 2012 15:54:18 +0200, David Sterba wrote:
> On Thu, Sep 13, 2012 at 06:51:36PM +0800, Miao Xie wrote:
>> div_factor{_fine} has been implemented for two times, cleanup it.
>> And I move them into a independent file named math.h because they are
>> common math functions.
> 
> You removed the sanity checks:
> 
> -       if (factor <= 0)
> -               return 0;
> -       if (factor >= 100)
> -               return num;

As inline functions, they should not contain complex checks, the caller should
make sure the parameters are right. I think.

> in new version. And I don't think it's necessary to add an extra include
> with a rather generic name and trivial code. A separate .h/.c with
> non-filesystem related support code like this looks more suitable.
> 
> Do you intend to use the functions out of extent-tree.c ?

They are used in both extent-tree.c and volumes.c from the outset, but they
were implemented in these two files severally.
