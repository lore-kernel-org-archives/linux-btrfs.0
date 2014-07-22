Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbaGVTQB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 15:16:01 -0400
Date: Tue, 22 Jul 2014 21:15:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND 1/4] btrfs-progs: Check fstype in find_mount_root()
Message-ID: <20140722191559.GJ1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 10, 2014 at 11:05:10AM +0800, Qu Wenruo wrote:
> When calling find_mount_root(), caller in fact wants to find the mount
> point of *BTRFS*.
> 
> So also check ent->fstype in find_mount_root() and output proper error
> messages if needed.

The utils.c functions should be mostly silent about the errors as this
this the common code and it's up to the callers to print the messages.
The existing printf in find_mount_root had appeared before the function
was moved to utils.c.

> This will suppress a lot of "Inapproiate ioctl for device" error
> message.

Catching the error early is a good thing of course.
