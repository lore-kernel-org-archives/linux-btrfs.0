Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152Ab3GCRSl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 13:18:41 -0400
Date: Wed, 3 Jul 2013 19:18:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org, wangsl-fnst@cn.fujitsu.com
Subject: Re: [PATCH 1/2] Btrfs-progs: make pretty_sizes() works less error
 prone
Message-ID: <20130703171839.GR18204@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1372867658-4144-1-git-send-email-wangshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372867658-4144-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 04, 2013 at 12:07:37AM +0800, Wang Shilong wrote:
> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> In the original code, pretty_sizes() may return NULL in two cases:
> <1> Allocating memory dynamically fails

Turning it into static allocation looks much better than calling
malloc for ~30 bytes.

> <2> Overflow happens(size exceeds YB)

However we're limited to 16 EiB both theoretically and practically due
to everything being 64bit, we can drop the zetta- and yotta- suffixes
eventually.

thanks,
david
