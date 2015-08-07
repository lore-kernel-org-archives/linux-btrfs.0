Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:58713 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbbHGJSH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 05:18:07 -0400
From: Russell Coker <russell@coker.com.au>
To: Robert Krig <robert.krig@render-wahnsinn.de>
Subject: Re: btrfs raid1 metadata, single data
Date: Fri, 7 Aug 2015 19:18:02 +1000
Cc: "linux-btrfs" <linux-btrfs@vger.kernel.org>
References: <55C47136.2080402@render-wahnsinn.de>
In-Reply-To: <55C47136.2080402@render-wahnsinn.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201508071918.02231.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 7 Aug 2015 06:49:58 PM Robert Krig wrote:
> What exactly is contained in btrfs metadata?

Much the same as in metadata for every other filesystem.

> I've read about some users setting up their btrfs volumes as
> data=single, but metadata=raid1
> 
> Is there any actual benefit to that? I mean, if you keep your data as
> single, but have multiple copies of metadata, does that still allow you
> to recover from data corruption? Or is metadata redundancy a benefit to
> ensure that your btrfs volume remains mountable/readable?

If you have redundant metadata and experience corruption then you will know 
the name of every file that has data corruption, this is really good for 
restoring from backup.  Also you will be protected against corruption of a 
root directory causing massive data loss.

If you have the bad luck to have certain metadata structures corrupted with no 
redundancy then you can face massive data loss and possibly have the entire 
filesystem become at least temporarily unusable.  While corruption of the root 
directory is unlikely it is possible.  With "dup" metadata I've seen a BTRFS 
filesystem remain usable after 12,000+ read errors.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
