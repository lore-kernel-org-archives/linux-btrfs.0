Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:44020 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755272AbcJXRik (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 13:38:40 -0400
Subject: Re: [PATCH] btrfs: imporve delayed refs iterations
To: dsterba@suse.cz, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <20161021090507.28425-1-wangxg.fnst@cn.fujitsu.com>
 <20161024164639.GE22935@twin.jikos.cz>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <580E471D.2010402@applied-asynchrony.com>
Date: Mon, 24 Oct 2016 19:38:37 +0200
MIME-Version: 1.0
In-Reply-To: <20161024164639.GE22935@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/24/16 18:46, David Sterba wrote:
> On Fri, Oct 21, 2016 at 05:05:07PM +0800, Wang Xiaoguang wrote:
>> This issue was found when I tried to delete a heavily reflinked file,
>> when deleting such files, other transaction operation will not have a
>> chance to make progress, for example, start_transaction() will blocked
>> in wait_current_trans(root) for long time, sometimes it even triggers
>> soft lockups, and the time taken to delete such heavily reflinked file
>> is also very large, often hundreds of seconds. Using perf top, it reports
>> that:
> 
>> [...] With this patch, it just took about 10~15 seconds to
>> delte the same file.
> 
> Great improvement! Patch looks good on a quick skim so I'll add it to
> next, but proper review is still required.

If it helps, I've been running it for ~2 days now with no negative side
effects, mostly rsync creating & deleting files with various levels of
reflinking (via snapshots). No problems at all.
Also tried to manually create & delete a large file with heavy CoW and
hundreds of reflinked copies - no problem either and pretty fast.

So..

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

cheers,
Holger

