Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:44641 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3IUBQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 21:16:31 -0400
Received: by mail-pb0-f42.google.com with SMTP id un15so1030084pbc.1
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 18:16:31 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 4/4] Btrfs-progs: add super-recover to recover bad supers
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20130918163127.GF6810@twin.jikos.cz>
Date: Sat, 21 Sep 2013 09:16:25 +0800
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-Id: <0223DF74-26DE-44A2-8D5B-1B7DC1879940@gmail.com>
References: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1379492856-30639-5-git-send-email-wangsl.fnst@cn.fujitsu.com> <20130918151304.GD6810@twin.jikos.cz> <936776EC-7D7D-458F-960E-E1CB56F9B4BA@gmail.com> <20130918163127.GF6810@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello David,

> On Wed, Sep 18, 2013 at 11:31:16PM +0800, Wang Shilong wrote:
>>>> static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>>>> 					     u64 sb_bytenr,
>>>> 					     u64 root_tree_bytenr, int writes,
>>>> -					     int partial, int restore)
>>>> +					     int partial, int restore,
>>>> +					     int run_ioctl)
>>> 
>>> Yet another parameter to __open_ctree_fd, this really needs a cleanup.
>>> (Later is fine.)
>> 
>> I have considered about this, __open_ctree_fd() is a *static* helper, if i don't
>> add another parameter to it. I have to move out of __open_ctree_fd()  into
>> open_ctree_with_broken_super() which also seems  not good!
> 
> The idea is that all open_ctree* variants will take one parameter that
> accumulates what's currently passed via writes/partial/restore/run_ioctl:
> 
> #define OPEN_CTREE_PARTIAL 	(1 << 0ULL)
> #define OPEN_CTREE_WRITES	(1 << 1ULL)
> etc ...
> 
> static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
> 					     u64 sb_bytenr,
> 					     u64 root_tree_bytenr,
> 					     unsigned open_flags)
> 
> and the callers updated accordingly. The calls then look like
> 
> - open_ctree_fs_info_restore(target, 0, 0, 0, 1);
> + open_ctree_fs_info_restore(target, 0, 0, OPEN_CTREE_PARTIAL);

Good idea, i think this should be another patch. 

Thanks,
Wang

