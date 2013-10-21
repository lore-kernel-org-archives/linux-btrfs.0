Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:35477 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab3JUEgz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 00:36:55 -0400
Date: Mon, 21 Oct 2013 13:36:44 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: jgoerzen@complete.org, linux-btrfs@vger.kernel.org
Subject: Re: Lots of trouble hanging when rm files with many extents
Message-ID: <20131021133644.172387f5@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > I'll do some more tests with lots of extents to see if it's
> > reproducible here as well.
> 
> Interestingly, I've generally had qgroups enabled here as well,
> possibly on all of these systems.  Could that be the culprit?

Possibly.

Is there a reliable way to create files with many extents? I've tried
playing with fallocate, but couldn't create files with too many extents
with it.


-- 
Tomasz Chmielewski
http://wpkg.org
