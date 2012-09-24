Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:59901 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612Ab2IXMn3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 08:43:29 -0400
Date: Mon, 24 Sep 2012 14:42:12 +0200
From: David Sterba <dave@jikos.cz>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: chris.mason@fusionio.com, yongjun_wei@trendmicro.com.cn,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix return value check in btrfs_ioctl_send()
Message-ID: <20120924124212.GC14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAPgLHd-ikKq2V2aZ-u1AJAdaxma19DEifui+q+FxmX0pAh_mLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPgLHd-ikKq2V2aZ-u1AJAdaxma19DEifui+q+FxmX0pAh_mLA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 21, 2012 at 12:42:02PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function btrfs_read_fs_root_no_name() returns
> ERR_PTR() and never returns NULL pointer. The NULL test in the return
> value check should be replaced with IS_ERR(), and remove useless
> NULL test.

Good catch.  Also please update the other remaining case in
disk-io.c:open_ctree()

2587         fs_info->fs_root = btrfs_read_fs_root_no_name(fs_info, &location);
2588         if (!fs_info->fs_root)
2589                 goto fail_qgroup;
2590         if (IS_ERR(fs_info->fs_root)) {
2591                 err = PTR_ERR(fs_info->fs_root);
2592                 goto fail_qgroup;
2593         }


> dpatch engine is used to auto generated this patch.
> (https://github.com/weiyj/dpatch)

I've played with it, looks nice, although it's full of hardcoded paths.
I'd like to run it directly from the git repo. Can you please fix that?
No patch from me, because I hadcoded my paths :)

It would be great if we can run a set of .cocci scripts that would
verify code invariants (limited to cocci capabilities, but eg. the
IS_ERR is a good example) and add new ones eventually over time.


david
