Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36736 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753196AbeDIPqd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Apr 2018 11:46:33 -0400
MIME-Version: 1.0
In-Reply-To: <20180409132538.GM8557@twin.jikos.cz>
References: <20180403083945.13485-1-suy.fnst@cn.fujitsu.com> <20180409132538.GM8557@twin.jikos.cz>
From: Damenly Su <damenly.su@gmail.com>
Date: Mon, 9 Apr 2018 23:46:32 +0800
Message-ID: <CABnRu56L4K599tPQoBp6aK8BUARNJnohm6LDmpV603=sS7TupQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: let mkfs return nozero value on thin
 provision device
To: dsterba@suse.cz, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for the previous reply in HTML format which is not delivered to
the mail list.

I mean there is already xfstests generic/405 for the situation.
Thin provision devices need to call dmsetup to setup.
I wonder If calling dmsetup in progs tests is acceptable or not.
If it is, I will do it.

Thanks,
Su

On Mon, Apr 9, 2018 at 9:25 PM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Apr 03, 2018 at 04:39:45PM +0800, Su Yue wrote:
>> when mkfs.btrfs on a thin provision device which has very small
>> backing size and big virtual size, all code works well in
>> mkfs.btrfs until close_ctree() is called.
>> close_ctree() fails to sync device due to small backing size
>> while closing devices.
>> However, mkfs returns 0 in such situation which causes failure of
>> xfstests generic/405.
>>
>> So, let mkfs returns nonzero value if previous steps succeeded but
>> close_ctree() failed.
>> Then xfstests generic/405 passes now.
>>
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>
> Applied, thanks. Can you please write a test for that?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
