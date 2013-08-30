Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146Ab3H3P6Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 11:58:25 -0400
Date: Fri, 30 Aug 2013 17:58:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 1/8] Btrfs-progs: add missing man page information for
 btrfsck
Message-ID: <20130830155821.GM23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1376454557-3041-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1376454557-3041-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 14, 2013 at 12:29:10PM +0800, Wang Shilong wrote:
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v2->v3: availiable parts is not true anymore,remove it.
> v1->v2: remove wrong copyrights.

Thanks for the updates, I've put the series into integration.

Note for future:

The manpages document the current state, ie. there are numerous separate
utilities which we would like to move under the main tool. When it
happens the man contents shall be moved as well.

david
