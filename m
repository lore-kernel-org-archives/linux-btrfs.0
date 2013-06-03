Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45636 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433Ab3FCCqw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Jun 2013 22:46:52 -0400
Date: Mon, 3 Jun 2013 10:47:06 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: George Mitchell <george@chinilu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Is there a way to flag specific directories "nodatacow"?
Message-ID: <20130603024705.GA26405@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <51AB5974.3080803@chinilu.com>
 <20130603012848.GA26016@liubo.jp.oracle.com>
 <51ABFD46.90601@chinilu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51ABFD46.90601@chinilu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 02, 2013 at 07:19:50PM -0700, George Mitchell wrote:
> On 06/02/2013 06:28 PM, Liu Bo wrote:
> >On Sun, Jun 02, 2013 at 07:40:52AM -0700, George Mitchell wrote:
> >>I am seeing massive journal corruptions that seem to be unique to
> >>btrfs and I am suspecting that cow might be causing them.  My
> >>bandaid fix for this will be to mark the /var filesystem "nodatacow"
> >>at boot.  But I am wondering if their is any way to flag a
> >>particular directory as "nodatacow" outside of the mount process.  I
> >>would like to be able to mark /var/log/journal as "nodatacow" for
> >>example, without having to declare it a subvolume and mount it
> >>separately.
> >Hi George,
> >
> >We actually have per-file/directory nodatacow :)
> >
> >But please note if you set nodatacow on the particular directory, only
> >new-created or zero-size files in the directory can follow the nocow rule.
> >
> >'chattr' in the latest e2fsprogs can fit your requirements,
> ># chattr +C /var/log/journal
> >
> >Also, what kind of massive journal corruptions?  Does it look like a
> >btrfs specific bug?
> >
> >thanks,
> >liubo
> >
> >
> I am also assuming that all directories later created under
> /var/log/journal will inherit the nodatacow profile?

Yes, indeed.
