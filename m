Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50726 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727498AbeGPQzh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 12:55:37 -0400
Date: Mon, 16 Jul 2018 18:27:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: lowmem: fix false alerts of referencer
 count mismatch for blocks relocated
Message-ID: <20180716162720.GQ3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180703075851.8346-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180703075851.8346-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 03, 2018 at 03:58:50PM +0800, Su Yue wrote:
> Btrfs lowmem check reports such false alerts:
...

1 and 2 applied, thanks.
