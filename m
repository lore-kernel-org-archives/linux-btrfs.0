Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40079 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755418AbeAHTCb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 14:02:31 -0500
Date: Mon, 8 Jan 2018 20:00:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: check: do not reset ret after
 try_repair_inode
Message-ID: <20180108190022.GI13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171121101524.2014-1-suy.fnst@cn.fujitsu.com>
 <20171121101524.2014-2-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171121101524.2014-2-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 21, 2017 at 06:15:23PM +0800, Su Yue wrote:
> After failure of try_repair_inode(), the value @ret will be reseted
> anyway. Then counter @error won't be incremented.

Can you pleae expand the changelog? I don't see how this patch helps,
the extra line does not hurt readability so I don't see a strong reason
to remove it.
