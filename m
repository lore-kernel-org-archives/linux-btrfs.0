Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:51475 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704Ab2IYKv6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 06:51:58 -0400
Date: Tue, 25 Sep 2012 12:51:54 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not async metadata csums if we have hardware
 crc32c
Message-ID: <20120925105154.GS14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348510264-5781-1-git-send-email-jbacik@fusionio.com>
 <20120924210349.GP14582@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120924210349.GP14582@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 11:03:49PM +0200, David Sterba wrote:
> Could you please put the check into a separate helper

Please note that checksum will become a variable per-filesystem
property, stored within the superblock, so the helper should be passed a
fs_info pointer.

thanks,
david
