Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbcAMP4e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jan 2016 10:56:34 -0500
Date: Wed, 13 Jan 2016 16:56:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Geliang Tang <geliangtang@163.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add lz4 compression support
Message-ID: <20160113155630.GR4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <b966f4dc11df3ae96e90d8836d2f54b33ca41f2c.1452693396.git.geliangtang@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b966f4dc11df3ae96e90d8836d2f54b33ca41f2c.1452693396.git.geliangtang@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 13, 2016 at 10:01:01PM +0800, Geliang Tang wrote:
> Like lzo in btrfs, this patch added lz4 compression support so that
> users can have a third option.

https://btrfs.wiki.kernel.org/index.php/FAQ#Will_btrfs_support_LZ4.3F
