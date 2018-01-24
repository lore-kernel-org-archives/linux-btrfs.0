Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32155 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752118AbeAXGoj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Jan 2018 01:44:39 -0500
Date: Wed, 24 Jan 2018 14:44:32 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 00/67] btrfs-progs: add the stack prefix for the set/get
Message-ID: <20180124064432.GG532@fnst.localdomain>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
 <20180123142949.GJ15713@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20180123142949.GJ15713@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 23, 2018 at 03:29:50PM +0100, David Sterba wrote:
>On Thu, Jan 11, 2018 at 01:08:32PM +0800, Lu Fengqi wrote:
>> These set/get functions defined by BTRFS_SETGET_STACK_FUNCS macro is
>> missing the prefix stack. I can't add an extent buffer version set/get
>> function as the result of the function name conflict.
>
>Why do you need to add the extent buffer set/get helpers?

I just want to use the extent_buffer version set helper to set the
refs/flags of root_item. Of course, I can read_extent_buffer at first,
then use the stack version set helper, and write_extent_buffer at last.

>
>The function names will become quite long after adding the _stack
>string, so I'd rather be sure we really need it before changing the
>names everywhere.

Personally, I think we should follow the naming scheme to differentiate
between the stack version helper and the extent_buffer version helper
since we already have such a naming scheme.

>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

-- 
Thanks,
Lu


