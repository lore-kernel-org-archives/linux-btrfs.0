Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:51975 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbbAFLqz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Jan 2015 06:46:55 -0500
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Cc: Lennart Poettering <lennart@poettering.net>
Subject: Re: btrfs_inode_item's otime?
Date: Tue, 06 Jan 2015 22:47 +1100
Message-ID: <1891475.iuyauiTsCQ@quad>
In-Reply-To: <20150105172152.GB19126@gardel-login>
References: <20150105172152.GB19126@gardel-login>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 5 Jan 2015 06:21:52 PM Lennart Poettering wrote:

> Is this on purpose, or simply an oversight?


The only hint I can see that it's deliberate is the comment in fs/btrfs/send.c 
that says:

/* TODO Add otime support when the otime patches get into upstream */

However...

> It should be easy to initialize it to the mtime when the inode is
> first created...

This I agree with, well worth doing anyway.

I'll see if I can knock up a patch.

All the best,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


