Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60522 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750957AbdJBOoL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Oct 2017 10:44:11 -0400
Date: Mon, 2 Oct 2017 16:42:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: right-align number columns in btrfs-debugfs
 output
Message-ID: <20171002144235.GZ31640@suse.cz>
Reply-To: dsterba@suse.cz
References: <59f60b49-3e74-547d-5124-8ce0097059ff@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <59f60b49-3e74-547d-5124-8ce0097059ff@applied-asynchrony.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 30, 2017 at 05:54:27PM +0200, Holger Hoffstätte  wrote:
> 
> The values for block group offset, length etc. in btrfs-debugfs' output
> are left-aligned, which creates unaligned output and makes the usage
> percentage hard to read/process further. This patch adds right-aligning
> format specifiers for the number values.
> Ideally the format values wouldn't be hardcoded but instead derived from
> the filesystem size, but this seems to work for now.
> 
> Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>

Applied, thanks.
