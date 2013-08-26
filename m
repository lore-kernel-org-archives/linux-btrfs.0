Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22853 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab3HZJah (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 05:30:37 -0400
Date: Mon, 26 Aug 2013 17:30:22 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Thomas Koch <thomas@koch.ro>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: check for reflink capability and for shared data
Message-ID: <20130826093021.GB17457@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <201308241809.58701.thomas@koch.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201308241809.58701.thomas@koch.ro>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 24, 2013 at 06:09:58PM +0200, Thomas Koch wrote:
> Hi,
> 
> how can I do the following in a shell script:
> 
> - check whether my file system supports cp --reflink?
> - check whether two files share the same data on disk, i.e. one has been 
> created by cp --reflink of the other?

Someone has proposed to teach 'du(1)' to show this, ie. 'du --shared'[1].

It's written for ocfs2 originally, besides btrfs, ocfs2 also can share
data between two files.

[1]: https://oss.oracle.com/pipermail/ocfs2-devel/2010-September/007287.html

-liubo
