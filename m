Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbaG2MCs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 08:02:48 -0400
Date: Tue, 29 Jul 2014 14:02:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs-progs: Fix wrong indent in btrfs-progs.
Message-ID: <20140729120246.GN1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1404961513-14614-3-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404961513-14614-3-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 10, 2014 at 11:05:12AM +0800, Qu Wenruo wrote:
> When editing cmds-filesystem.c, I found cmd_filesystem_df() uses 7
> spaces as indent instead of 1 tab (or 8 spaces). which makes indent
> quite embarrassing.
> Such problem is especillay hard to detect when reviewing patches,
> since the leading '+' makes a tab only 7 spaces long, makeing 7 spaces
> look the same with a tab.
> 
> This patch fixes all the 7 spaces indent.

The whitespace changes cause patch conflicts and I'm inclined not to add
them or postpone after the patch queue is relatively calm.
