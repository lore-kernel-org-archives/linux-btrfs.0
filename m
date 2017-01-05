Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53612 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752352AbdAECDs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jan 2017 21:03:48 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 1B4DE43972DF
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Jan 2017 10:03:21 +0800 (CST)
Subject: Re: btrfs subvolume delete --commit-after doesn't wait for deletions
To: <linux-btrfs@vger.kernel.org>
References: <20170105014656.GA19542@untroubled.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <495af306-19bc-6af1-4411-e2eefe143891@cn.fujitsu.com>
Date: Thu, 5 Jan 2017 10:03:17 +0800
MIME-Version: 1.0
In-Reply-To: <20170105014656.GA19542@untroubled.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/05/2017 09:46 AM, Bruce Guenter wrote:
>
> In the man page for btrfs subvolume delete, the --commit-after option
> says it will "wait for transaction commit at the end of the operation".
> However, the available disk space continues to increase for several
> minutes after this command completes.  I am running linux kernel 4.4.35
> on Gentoo Linux with btrfs-progs-4.9.
>
> Am I misunderstanding how the --commit-after option is supposed to work?
> If so, is there any other good way to wait for btrfs subvolume delete to
> complete freeing space before continuing? Has this behavior changed in
> recent kernels (I tried 4.8.15 before posting this, but it had unrelated
> issues)?

Commit-after/each is only supposed to commit the transaction, in which 
we orphaned the subvolume, but not deleting it yet.

That's to say, after subvolume delete finished with --commit-after/each, 
and a powerloss happened, it ensures that we won't see the old subvolume 
in fs.

Without --comit-after/each, it's possible that a power loss can make the 
us rollback to previous status, which un-committed subvolumes are still 
here.

Anyway, subvolume delete only makes subvolume orphan. And real delete 
happens background. Just like what we delete files.

To wait the deletion finish, please use "btrfs filesystem sync".

Thanks,
Qu
>
> Thanks.
>


