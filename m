Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43142 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753158AbdK1QJJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:09:09 -0500
Date: Tue, 28 Nov 2017 17:07:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 1/3] btrfs-progs: fi defrag: clean up duplicate code
 if find errors
Message-ID: <20171128160711.GW3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171128091450.21789-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 28, 2017 at 05:14:48PM +0800, Su Yue wrote:
> In function cmd_filesystem_defrag(), lines of code for error handling
> are duplicate and hard to expand in further.
> 
> Create a jump label for errors.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Applied, thanks.
