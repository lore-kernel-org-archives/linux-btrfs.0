Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50261 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3FCB2h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Jun 2013 21:28:37 -0400
Date: Mon, 3 Jun 2013 09:28:49 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: George Mitchell <george@chinilu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is there a way to flag specific directories "nodatacow"?
Message-ID: <20130603012848.GA26016@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <51AB5974.3080803@chinilu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51AB5974.3080803@chinilu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 02, 2013 at 07:40:52AM -0700, George Mitchell wrote:
> I am seeing massive journal corruptions that seem to be unique to
> btrfs and I am suspecting that cow might be causing them.  My
> bandaid fix for this will be to mark the /var filesystem "nodatacow"
> at boot.  But I am wondering if their is any way to flag a
> particular directory as "nodatacow" outside of the mount process.  I
> would like to be able to mark /var/log/journal as "nodatacow" for
> example, without having to declare it a subvolume and mount it
> separately.

Hi George,

We actually have per-file/directory nodatacow :)

But please note if you set nodatacow on the particular directory, only
new-created or zero-size files in the directory can follow the nocow rule.

'chattr' in the latest e2fsprogs can fit your requirements,
# chattr +C /var/log/journal

Also, what kind of massive journal corruptions?  Does it look like a
btrfs specific bug?

thanks,
liubo
