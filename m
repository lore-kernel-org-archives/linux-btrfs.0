Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:36206 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab2IQQSN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 12:18:13 -0400
Date: Mon, 17 Sep 2012 18:17:53 +0200
From: David Sterba <dave@jikos.cz>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Root dentry has weird name <>
Message-ID: <20120917161753.GU17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120914170912.GH19051@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120914170912.GH19051@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 10:09:12AM -0700, Marc MERLIN wrote:
> I only have btrfs on my laptop and just started getting this.

Afaik, this is not directly related to btrfs. Search for the "Root
dentry has weird name" message and you'll see occurences from kernel
3.0, 3.1.

> I'm not too clear about whether it's in memory or on my filesystem somewhere.

It's reflecting a in-memory state.

> Can you recommend what I should do: reboot? fsck somehow? other?

Reboot should help, also check for potential NFS problems, like
unreachable server.


david
