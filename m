Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37611 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754058AbdEZSjp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 14:39:45 -0400
Date: Fri, 26 May 2017 20:38:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: tree-log.c: Wrong printk information about namelen
Message-ID: <20170526183845.GO30842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170524013132.7521-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170524013132.7521-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 24, 2017 at 09:31:32AM +0800, Su Yue wrote:
> In verify_dir_item, it wants to printk name_len of dir_item but
> printk data_len acutally.

Good catch, thanks.

Reviewed-by: David Sterba <dsterba@suse.com>
