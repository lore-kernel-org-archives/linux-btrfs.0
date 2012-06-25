Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:42303 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab2FYWtH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 18:49:07 -0400
Date: Tue, 26 Jun 2012 00:49:00 +0200
From: David Sterba <dave@jikos.cz>
To: Dmitry MiksIr <miksir@maker.ru>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: how to cleanup old superblock
Message-ID: <20120625224900.GN28144@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <jsafma$896$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <jsafma$896$1@dough.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2012 at 11:54:50PM +0400, Dmitry MiksIr wrote:
> Hello!
> Long time ago I created btrfs on /dev/sda
> After some changes btrfs moved to /dev/sda1 (well, to md, and sda1 is part
> of md).
> 
> As result, <btrfs fi show> show me 2 filesystems: new one and old one.
> Probably I need to do some cleaning. Can someone tell me what to do.

quick aid is to run this command:

dd if=/dev/zero of=/dev/sda bs=1k count=4 seek=64

(deletes just the btrfs superblock and will not touch anything
else)


david
