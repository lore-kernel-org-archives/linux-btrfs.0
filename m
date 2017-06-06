Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50928 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751305AbdFFM6e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Jun 2017 08:58:34 -0400
Date: Tue, 6 Jun 2017 14:57:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 1/9] btrfs: Introduce btrfs_is_name_len_valid to avoid
 reading beyond boundary
Message-ID: <20170606125729.GA2918@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
 <20170606095708.494-2-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170606095708.494-2-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 05:57:00PM +0800, Su Yue wrote:
> +	if (item_end != read_end &&
> +	    item_end - read_end < size) {

This fits on line, no need to split. Fixed.
