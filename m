Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:33181 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab2IXOHA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 10:07:00 -0400
Date: Mon, 24 Sep 2012 16:06:52 +0200
From: David Sterba <dave@jikos.cz>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: chris.mason@fusionio.com, yongjun_wei@trendmicro.com.cn,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs: fix return value check
Message-ID: <20120924140652.GH14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAPgLHd8F8r4i5HpAaDR_GKwxuw6At4nyKJKCp2Tk4k2xUG14fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPgLHd8F8r4i5HpAaDR_GKwxuw6At4nyKJKCp2Tk4k2xUG14fg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 24, 2012 at 09:42:26PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function btrfs_read_fs_root_no_name() returns
> ERR_PTR() and never returns NULL pointer. The NULL test in the return
> value check should be replaced with IS_ERR(), and remove useless
> NULL test.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
> v1 -> v2: remove null test from fs/btrfs/disk-io.c 
> ---

Reviewed-by: David Sterba <dsterba@suse.cz>
