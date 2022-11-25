Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D5CC4332F
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Nov 2022 09:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiKYJEH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Nov 2022 04:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKYJEG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2022 04:04:06 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5F41D330
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Nov 2022 01:04:03 -0800 (PST)
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MtfJX-1okxLz1Yx5-00v8bu; Fri, 25
 Nov 2022 10:04:01 +0100
Message-ID: <e1eac218-bc97-0f62-4be8-b81c37b76296@gmx.com>
Date:   Fri, 25 Nov 2022 17:03:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: Speed up mount time?
To:     Joakim <ahoj79@gmail.com>, wqu@suse.com
Cc:     linux-btrfs@vger.kernel.org
References: <376af265-a7c4-6897-b6fe-834d225b150f@suse.com>
 <20221125085538.280-1-ahoj79@gmail.com>
Content-Language: en-US
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20221125085538.280-1-ahoj79@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:Ut6iOvDSZcb7YQ6BtCahOxl90Vz7TCViNlI9UkRCFkV+oM66yfQ
 ql9iLVG2TZEciWBEpvD57kwOYtNJCRC6bHVtZMzjYtomTU3nSlhSXZLJeov/HohqhNLRqo1
 7Evxd4deEPdruDeZCvILCFjJvEBTftXRnsyUgo5v/XkhCKnLXtQSJvrFPkueLMWOgxgZN9l
 a6xY/ix5BP0514RQnP9sA==
UI-OutboundReport: notjunk:1;M01:P0:3mqWULgaa18=;FKSL7hosmcRG6Y/MliSsxHRdUsP
 WE86xnVXIlDftQ6PBLpI4y2Qc146EE+nCtmfqo+/MY2QD2d8Q8/G9+MnfblKfGnRkAy3zat2d
 xQ3c4GvWEl7ioU3Dm8W2rw0AyTkB62NL+bmkuNHdta/qDyx4ANe8mgnuswR2Rz1OKVmEQr+JG
 ALZDx03YLKGFkTx66jyBSRm2hlsYkLMVfF2Pi1/FLU1eL/tMCSFc8uUxrwpiisiwF+vG4loto
 WXG44UhFEhJE6W37digZk8hTi6turccHFeqFx+2nL8hXvbex2vRfqdGYxreh6TtwoEa9/Kyyf
 A8BxXdrL4+tTLwruEh1oLPCv26ofbU2bK7U18oa0+EclalS+ulGogIBjVZ6g1JTMxdRflKUXr
 05Qrlsk0FZmHxnNuMo43mHZISNWPO8Ifd3v9e2/ECKUsiv79595JsEwaEDyiJbYzctHSCckBH
 Y6daqAhA4r58FeE0FfLpKyzAjJPwGHupZydABQAylZvflfeXmZEsDaJwd+oidoFRFxzAAnKk3
 hlApiDOGluBilbqAzx7qszu0DJg1ByLs96LK7YdF583o25y04C2SQbtZxtSLO+WQ+yXzadGnr
 HSmgVj20GLlA49RhCeAvzfusCBYoRZJ9bBqmoM5B6oueIDkd6fzPzDzb8IJ+0WDx8MrpwUkJs
 KaYokvsTHkZJpe3Vj5Vtm4Hw7i4ULv62Glhcx2eAmIuiIeANKDgp8BtvW8HVqPggtbGQvbtxQ
 IsQbDCKQNVXRzbq3EoJIZy0pjhmgige10jgyqAchtXDKye3A7jmXM+WsJVUtEhsB9UvQAgrgZ
 cHkH0TzDpOf8o5FsH/8FMhMAylZMW0GfqgiC/PPacCFahyUNMzr45fS+exdkLCz7MBsWsErJW
 BQCqN9XDA1JyK+XoltVJMXMmvvr7SSZY+TXliayINyRS3GNWIy1AuRVl3EgQf6ma8HTSp3Y9a
 7LFuKPbsA5nacKU9U/sH3PlbygM=
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2022/11/25 16:55, Joakim wrote:
> That sounds great! Is there any rough ETA for when that might be released?
> Thanks! :)

As mentioned, if nothing wrong happened, v6.2 would be the target for 
the kernel.

For progs, it should already be implemented in btrfstune from the latest 
btrfs-progs.

But only one-way conversion is supported (aka, regular -> bg tree), no 
way to convert back yet.

If your distro doesn't ship newer kernel/progs, it may take much longer 
though.

Thanks,
Qu
