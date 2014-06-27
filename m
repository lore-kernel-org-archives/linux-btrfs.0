Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:49171 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbaF0KCr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 06:02:47 -0400
Received: from mailext.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id 1D37B42B9DB
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 12:02:44 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Blocked tasks on 3.15.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 27 Jun 2014 12:02:43 +0200
From: Tomasz Chmielewski <tch@virtall.com>
Message-ID: <52e3cfababa49919100759860b59aa7c@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I've been getting blocked tasks on 3.15.1 generally at times when the
> filesystem is somewhat busy (such as doing a backup via scp/clonezilla
> writing to the disk).
> 
> A week ago I had enabled snapper for a day which resulted in a daily
> cleanup of about 8 snapshots at once, which might have contributed,
> but I've been limping along since.

I've started seeing similar on several servers, after upgrading to 3.15 
or 3.15.1. With 3.16-rc1 it was even crashing for me.
I've rolled back to the latest 3.14.x, and it's still behaving fine.

I've signalled it before on the list in "btrfs filesystem hang with 
3.15-rc3 when doing rsync" thread.

-- 
Tomasz Chmielewski
http://www.sslrack.com

