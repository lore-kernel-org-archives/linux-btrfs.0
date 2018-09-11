Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37104 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727508AbeIKRno (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 13:43:44 -0400
Date: Tue, 11 Sep 2018 16:44:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: dump-tree: print invalid argument and
 strerror
Message-ID: <20180911144419.GC2997@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180830090804.13264-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180830090804.13264-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 05:08:04PM +0800, Su Yue wrote:
> Before this patch:
> $ ls nothingness
> ls: cannot access 'nothingness': No such file or directory
> $ btrfs inspect-internal dump-tree nothingness
> ERROR: not a block device or regular file: nothingness
> 
> The confusing error message makes users thinks that nonexistent
> file is existed but in wrong type.
> 
> This patch let check_arg_type return -errno if realpath failed.
> And print strerror if check_arg_type failed and the returned code
> is negative. Like:
> 
> $ btrfs inspect-internal dump-tree nothingness
> ERROR: invalid argument: nothingness: No such file or directory
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Applied, thanks.
