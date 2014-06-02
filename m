Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbaFBQS5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jun 2014 12:18:57 -0400
Date: Mon, 2 Jun 2014 18:18:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] Btrfs-progs: fsck: only allow partial opening
 under repair mode
Message-ID: <20140602161856.GD22324@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401357597-9494-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401357597-9494-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 29, 2014 at 05:59:56PM +0800, Wang Shilong wrote:
> The reason that we allow partial opening is that sometimes,
> we may have some corrupted trees.(for example extent tree), for
> fsck repair case, the broken tree may be rebuilt later.
> 
> So if users only want to do check but not repair anything, this
> patch will make fsck return failure as soon as possible and
> tell users that some critial roots have been corrupted.

Ok, that partially answers my question under v1. This would be a
different mode, eg. a fast check, that would bail out quickly as you
intend. I'd really want to keep the (full) check and repair to do the
same sort of checks and verification.
