Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbbBBNnP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Feb 2015 08:43:15 -0500
Date: Mon, 2 Feb 2015 14:43:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/5] btrfs-progs: Record orphan data extent ref to
 corresponding root.
Message-ID: <20150202134313.GA24227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1420182753-2724-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1420182753-2724-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 02, 2015 at 03:12:29PM +0800, Qu Wenruo wrote:
> v2:
>    Do not record file extent if the file extent pointed by the data
>    backref exists but only bytenr mismatch.
>    This fix a regression bug causing fsck-test 001 fail.

Patches 1-5 applied to 3.19, thanks.
