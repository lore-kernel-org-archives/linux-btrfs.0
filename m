Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33573 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751046AbdKFV05 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 16:26:57 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A420FACEA
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 21:26:55 +0000 (UTC)
Subject: Re: [PATCH 00/10] Cleanup unnecessary get_extent parameters
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1509996091.git.dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <831c9c09-c974-eb38-0e26-fa9a6e8309ee@suse.com>
Date: Mon, 6 Nov 2017 23:26:54 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1509996091.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  6.11.2017 21:30, David Sterba wrote:
> There are several functions that take a generic get_extent parameter, but not
> all of them use it to distinguish between btree_get_exnent (for metadata) and
> btrfs_get_extent (for data). This is namely extent_read_full_page and
> __do_readpage.

I wonder whether we can do some similar collpasing withe some of the
hooks we have i.e. readpage_end_io_hook (resp.
btrfs_readpage_end_io_hook and btree_readpage_end_io_hook). All those
callbacks don't necessarily help readability...

