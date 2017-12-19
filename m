Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:41842 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935438AbdLSBfB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 20:35:01 -0500
Received: by mail-ot0-f181.google.com with SMTP id q39so8615828otb.8
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Dec 2017 17:35:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b580f4c4-3eb0-9203-75b5-c918f15d12cf@cn.fujitsu.com>
References: <CAJCQCtScin-9AomqOwiSTwj=5rCeJW12jv8rv8taxwUq+AX5Lw@mail.gmail.com>
 <b580f4c4-3eb0-9203-75b5-c918f15d12cf@cn.fujitsu.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 18 Dec 2017 18:34:59 -0700
Message-ID: <CAJCQCtRuaWb2_EHiiKzk7iWhMoLno6F-O+J42hqsgYif5AEVew@mail.gmail.com>
Subject: Re: btrfs check lowmem crash, backref.c:466: __add_missing_keys:
 Assertion `ref->root_id` failed
To: Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 17, 2017 at 8:07 PM, Su Yue <suy.fnst@cn.fujitsu.com> wrote:
> Hi,
>
> On 12/18/2017 10:50 AM, Chris Murphy wrote:
>>
>> This is v4.14.
>>
>> I've filed a bug which contains the build steps, versions. It's
>> crashing on all volumes I try it on so far.
>>
>>
>
> It was fixed by Qu's patch
>   btrfs-progs: backref: Allow backref walk to handle direct parent ref
> which is available on his github
> https://github.com/adam900710/btrfs-progs/tree/lowmem_fix
>
 OK that fixed the crashing problem on all tested volumes. One volume
so far has a bunch of these:

ERROR: data extent[1218774720512 167936] backref lost

With the same numbers for each line. Is that fixed in kdave devel
branch? Or pending?

-- 
Chris Murphy
