Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21472 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S965517AbdAIBo3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Jan 2017 20:44:29 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id DE76646701DB
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Jan 2017 09:44:16 +0800 (CST)
Subject: Re: btrfs subvolume delete --commit-after doesn't wait for deletions
To: <linux-btrfs@vger.kernel.org>
References: <20170105014656.GA19542@untroubled.org>
 <495af306-19bc-6af1-4411-e2eefe143891@cn.fujitsu.com>
 <20170106224306.GA8756@untroubled.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <811cdb20-3123-ba7d-376e-69a1a17ddb7e@cn.fujitsu.com>
Date: Mon, 9 Jan 2017 09:44:15 +0800
MIME-Version: 1.0
In-Reply-To: <20170106224306.GA8756@untroubled.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

At 01/07/2017 06:43 AM, Bruce Guenter wrote:
> On Thu, Jan 05, 2017 at 10:03:17AM +0800, Qu Wenruo wrote:
>> To wait the deletion finish, please use "btrfs filesystem sync".
>
> That doesn't entirely work either. It does appear to wait for something,
> but disk space available continues to increase after it exits.
>

Other than subvolume deleting, is there any other large file deletion?

File deletion in btrfs works in the same way, so the increasing disk 
space may be related to delayed file deletion.

Thanks,
Qu


