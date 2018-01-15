Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40756 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751710AbeAOM3F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 07:29:05 -0500
Date: Mon, 15 Jan 2018 13:29:03 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: invalid files names, btrfs check can't repair it
Message-ID: <20180115122903.poamgjmns4ytlkf2@breakpoint.cc>
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
 <1471d17b-3b53-b2c3-4a84-cb6df98c375e@gmx.com>
 <20180113204114.g4jup552d5g5o5pa@breakpoint.cc>
 <b0cc58c1-af7b-e4f7-2393-4d47a66bba59@gmx.com>
 <20180114163854.rghjpsx2ikwmqo7m@breakpoint.cc>
 <f242b71e-6539-3f60-314f-2a85efa5f26f@gmx.com>
 <20180115015952.GA523@fnst.localdomain>
 <920c8582-a871-c10f-5222-16be9f14de52@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <920c8582-a871-c10f-5222-16be9f14de52@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-15 12:23:05 [+0800], Qu Wenruo wrote:
> Right, I'll fix it soon.
> 
> And BTW what makes the the output different from the original one?
> 
> Sebastaian, did you do extra write or other operation to the fs after
> previous btrfs check?

Well the filesystem is in use but there should be no writtes to it since
initial `check' output. The `check' invalidates the space cache that is
rebuilt, not sure if this has any effect. Those two magic files are in a
subfolder of ccache and ccache shouldn't look into it at all.

> Thanks,
> Qu

Sebastian
