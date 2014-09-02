Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbaIBLZW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 07:25:22 -0400
Date: Tue, 2 Sep 2014 13:25:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: make 'btrfs replace' signal-handling works.
Message-ID: <20140902112518.GD5888@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1407287827-28694-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1407287827-28694-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 06, 2014 at 09:17:07AM +0800, Qu Wenruo wrote:
> Current BTRFS_IOC_DEV_REPLACE ioctl is synchronous, and during the ioctl
> program is fallen into kernel and unable to handle signal, the original
> signal function will never be executed until the dev replace is done.
> This is very annoying for someone who wants to stop dev replace by
> Ctrl-c (we have to admit that's the most users will do when replacing
> dev with nodatacow/nodatasum mount option).
> 
> This patch will create a thread to do the ioctl things, making the main
> thread able to handle signal correctly.

As described under the kernel patch, I'd like to use the respective
cancel ioctls instead of signals.
