Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58504 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab3DVNmw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 09:42:52 -0400
Date: Mon, 22 Apr 2013 15:42:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Ridley <mark@backupsystems.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS 3.8.7 Kernel Crash =?utf-8?Q?Rep?= =?utf-8?B?b3J04oCP?=
Message-ID: <20130422134249.GN16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <loom.20130422T151604-250@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20130422T151604-250@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 22, 2013 at 01:19:41PM +0000, Mark Ridley wrote:
> If I then use rsync --inplace to update the images, I get a btrfs stack trace 
> and btrfs hangs:
> 
> This happens every night.

> [<ffffffffa00bd5c1>] btrfs_set_item_key_safe+0x141/0x150 [btrfs]

The check fails because it finds keys in reverted order. Given the
conditions under which it happens I think it's an on-disk corruption and
fsck should be able to at least detect it.

david
