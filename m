Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:34096 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754709AbdCYGsa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 Mar 2017 02:48:30 -0400
Received: by mail-qt0-f178.google.com with SMTP id n21so6903444qta.1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Mar 2017 23:48:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a43bf7e1-36fe-cb49-d0ba-697ddaf1a14e@suse.com>
References: <CABxMtgcGod=FvgHagua07bzPjc7cy_+v0hkbTvwH_7GggOh9Ow@mail.gmail.com>
 <a43bf7e1-36fe-cb49-d0ba-697ddaf1a14e@suse.com>
From: Denis Kirjanov <dkirjanov@cloudlinux.com>
Date: Sat, 25 Mar 2017 09:48:28 +0300
Message-ID: <CABxMtgdx_aC53bL0XAZaTCX=8P6=J_+Z5jyUSS1GyES_5zw_qA@mail.gmail.com>
Subject: Re: __link_block_group uses GFP_KERNEL
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        chris.mason@fusionio.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/25/17, Jeff Mahoney <jeffm@suse.com> wrote:
> On 3/24/17 5:02 AM, Denis Kirjanov wrote:
>> Hi guys,
>>
>> Looks like that current code does GFP_KERNEL allocation inside
>> __link_block_group.
>> the function invokes kobject_add and internally creates sysfs files
>> with the GFP_KERNEL flag set.
>
> Yep, that's a bug.
>
>> But since do_chunk_alloc executes insides the btrfs transaction it's
>> not allowed to sleep.
>
> It's allowed to sleep but isn't allowed to do reclaim that involves file
> system writeback.  Michal Hocko's allocation context idea would fix
> this, but it's not there yet, so we'll need to defer the kobject_add
> until we can use GFP_KERNEL.

Ok, I see. Can you point out to the initial patchset?

Thanks!

>
> -Jeff
>
> --
> Jeff Mahoney
> SUSE Labs
>
>
