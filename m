Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32604 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaB0IMt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 03:12:49 -0500
Date: Thu, 27 Feb 2014 16:12:36 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Btrfs: check if directory has already been
 created smarter
Message-ID: <20140227081235.GC15138@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1393487254-17978-1-git-send-email-bo.li.liu@oracle.com>
 <1393487254-17978-2-git-send-email-bo.li.liu@oracle.com>
 <530EF0D3.7090805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530EF0D3.7090805@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 27, 2014 at 04:01:23PM +0800, Wang Shilong wrote:
> On 02/27/2014 03:47 PM, Liu Bo wrote:
> >Currently to check whether a directory has been created, we search
> >DIR_INDEX items one by one to check if children has been processed.
> >
> >Try to picture such a scenario:
> >    .
> >    |-- dir            (ino X)
> >          |-- foo_1    (ino X+1)
> >          |-- ...
> >          |-- foo_k    (ino X+k)
> >
> >With the current way, we have to check all the k DIR_INDEX items
> >to find it is a fresh new one.
> >
> >So this introduced a rbtree to store those directories which are
> >created out of order, and in the above case, we just need an O(logn)
> >search instead of O(1) search.
> Just a reminder, we ususally call O(n) rather O(1) here.
> If we falls O(1) to O(logn)..things are becoming worse~~

Good catch, my bad.

thanks,
-liubo
