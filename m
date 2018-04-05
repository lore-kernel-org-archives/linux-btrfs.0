Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2nam03on0113.outbound.protection.outlook.com ([104.47.42.113]:27552
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751255AbeDERVL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Apr 2018 13:21:11 -0400
From: Sasha Levin <Alexander.Levin@microsoft.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>, Liu Bo <bo.liu@linux.alibaba.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix NULL pointer dereference in log_dir_items
Date: Thu, 5 Apr 2018 17:21:09 +0000
Message-ID: <20180405172108.GP7561@sasha-vm>
References: <1522691988-127156-1-git-send-email-bo.liu@linux.alibaba.com>
 <DM5PR2101MB1032B5A71C5024A50654000AFBBB0@DM5PR2101MB1032.namprd21.prod.outlook.com>
 <20180405171114.GL2635@twin.jikos.cz>
In-Reply-To: <20180405171114.GL2635@twin.jikos.cz>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 05, 2018 at 07:11:14PM +0200, David Sterba wrote:
>On Thu, Apr 05, 2018 at 04:42:34PM +0000, Sasha Levin wrote:
>> Hi.
>>
>> [This is an automated email]
>>
>> This commit has been processed by the -stable helper bot and determined
>> to be a high probability candidate for -stable trees. (score: 9.9156)
>>
>> The bot has tested the following trees: v4.15.15, v4.14.32, v4.9.92, v4.4.126,
>>
>> v4.15.15: Build OK!
>> v4.14.32: Build OK!
>> v4.9.92: Build OK!
>> v4.4.126: Build OK!
>>
>> Please let us know if you'd like to have this patch included in a stable tree.
>
>Yes, in this case we expect that the Fixes: tag will let the patch flow
>to stable after it gets applied to master.
>
>The automated stable candidate patch scanning would be helpful in cases
>where the Fixes tag is not identified or we forget to add it. I don't
>mind helping to train the bot, so I'll try respond to the messages.

Just to clarify, having just the "Fixes:" tag is not necessarily an
indicator that a patch should go into -stable.

For example, if I fix up documentation and add a Fixes: tag to point to
the commit that added the original documentation, it's not -stable
material since we don't take documentation patches. Or, if the patch
that the new commit fixes didn't make it into any releases, it's not
stable material either.