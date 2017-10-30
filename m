Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47739 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752257AbdJ3NYo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 09:24:44 -0400
Date: Mon, 30 Oct 2017 14:22:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: Re: [PATCH] btrfs: Remove redundant mirror_num arg
Message-ID: <20171030132253.GT3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1508835039-26342-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1508835039-26342-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 24, 2017 at 11:50:39AM +0300, Nikolay Borisov wrote:
> The following callpath is always invoked with mirror_num set to 0, so let's
> remove it as an argument and directly pass 0 to __do_redpage. No functional 
> change
> 
> extent_readpages
>   __extent_readpages
>     __do_contiguous_readpages
>       __do_readpage
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
