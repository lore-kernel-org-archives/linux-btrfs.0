Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437AbaEPQHs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 12:07:48 -0400
Date: Fri, 16 May 2014 18:07:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: add sys_chunk_array and backup roots
 info to show-super
Message-ID: <20140516160746.GB6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400203417-22875-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400203417-22875-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 16, 2014 at 09:23:37AM +0800, Gui Hecheng wrote:
> Add sys chunk array and backup roots info if the new option '-f'
> if specified.
> This may be useful for debugging sys_chunk related issues.

Nice, thanks.
