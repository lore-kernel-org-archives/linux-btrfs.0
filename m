Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755659AbbAWQK0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 11:10:26 -0500
Date: Fri, 23 Jan 2015 17:10:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] fstests: btrfs/079: Fix wrong value passed to
 available space check.
Message-ID: <20150123161025.GP13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421820518-27797-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421820518-27797-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 21, 2015 at 02:08:37PM +0800, Qu Wenruo wrote:
> Wrong value is passed to _require_fs_space, which should be in unit of
> kilobyte(1024), but passed in unit of gigabyte(1024^3).
> 
> Fix it.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
