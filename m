Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44401 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755543AbdCGPec (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 10:34:32 -0500
Date: Tue, 7 Mar 2017 16:13:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, clm@fb.com
Subject: Re: [PATCH 0/9 PULL REQUEST] Qgroup fixes for 4.11
Message-ID: <20170307151331.GT4662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 27, 2017 at 03:10:30PM +0800, Qu Wenruo wrote:
> Pull request can be fetched from my github:
> https://github.com/adam900710/linux.git qgroup_fixes_for_4.11 
> 
> The base is 6288d6eabc7505f42dda34a2c2962f91914be3a4.
> Author: Liu Bo <bo.li.liu@oracle.com>
> Date:   Tue Feb 21 12:12:58 2017 -0800
> 
>     Btrfs: use the correct type when creating cow dio extent
> 
> These patches are already in mail list for almost 3 months.
> For example the tracepoint patch is last updated at 2016/12/09.
> 
> With this patchset btrfs can pass all xfstest qgroup tests now.
> 
> This pull request should be good for 4.11 as they are all bug fixes and
> has been delayed for several times.
> 
> I don't know if these patchset will be delayed again if someone wants to
> cleanup something else, and cause rebase conflicts to delay such fixes.

I have rebased the branch on top of the cleanups and added it as
separate branch to for-next. For the next dev cycle I'll delay merging the
intrusive cleanups until the end.

> But I must say, that's very frustrating to see bug fixes just get dropped
> again and again just due to new cleanups and lack of reviewers.

That's life of a kernel developer.
