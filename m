Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f174.google.com ([74.125.82.174]:43640 "EHLO
        mail-ot0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933622AbdLSDdR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 22:33:17 -0500
Received: by mail-ot0-f174.google.com with SMTP id b56so1066557otd.10
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Dec 2017 19:33:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSv4kCwOFHjbEdyuCbwBKdso4hLPJiejf7VsM5DwuyP6g@mail.gmail.com>
References: <CAJCQCtScin-9AomqOwiSTwj=5rCeJW12jv8rv8taxwUq+AX5Lw@mail.gmail.com>
 <b580f4c4-3eb0-9203-75b5-c918f15d12cf@cn.fujitsu.com> <CAJCQCtRuaWb2_EHiiKzk7iWhMoLno6F-O+J42hqsgYif5AEVew@mail.gmail.com>
 <a076c7ff-87e3-b18c-c046-ff4912e277c4@cn.fujitsu.com> <CAJCQCtSv4kCwOFHjbEdyuCbwBKdso4hLPJiejf7VsM5DwuyP6g@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 18 Dec 2017 20:33:13 -0700
Message-ID: <CAJCQCtTOyT3LpPYV3j8KMAr9D0HD5JQ_59kFj_xp7ohkdYvQNQ@mail.gmail.com>
Subject: Re: btrfs check lowmem crash, backref.c:466: __add_missing_keys:
 Assertion `ref->root_id` failed
To: Chris Murphy <lists@colorremedies.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 18, 2017 at 8:26 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Mon, Dec 18, 2017 at 7:19 PM, Su Yue <suy.fnst@cn.fujitsu.com> wrote:

>>>
>>
>> Did you apply all patches on this branch?
>
> Yes, I think so:


 1032  git remote add qu https://github.com/adam900710/btrfs-progs
 1033  git fetch qu
 1034  git checkout -b qulowmemfix qu/lowmem_fix


And then rebuilt. Also checkedout kdave devel branch and rebuilt, same results.



-- 
Chris Murphy
