Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:40277 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab2HVNr0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Aug 2012 09:47:26 -0400
Date: Wed, 22 Aug 2012 15:47:20 +0200
From: David Sterba <dave@jikos.cz>
To: Anand jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: seg fault in get_label_unmounted
Message-ID: <20120822134720.GQ17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1345019393-6168-1-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1345019393-6168-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 15, 2012 at 04:29:53PM +0800, Anand jain wrote:
> From: Anand Jain <anand.jain@oracle.com>
> 
> btrfs f l /
> No valid Btrfs found on /
> Segmentation fault (core dumped)

Patches fixing this have been sent like 4 times, last one was from
Alexander's 'btrfs prop', that modified it a bit more (to return the
label instead of printing it).

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/18287

while Danny fixes more instances of unhandled error code from open_ctree

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/15305

JFYI,
david
