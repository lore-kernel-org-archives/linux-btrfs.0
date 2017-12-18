Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:60120 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757685AbdLRDDV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Dec 2017 22:03:21 -0500
Subject: Re: btrfs check lowmem crash, backref.c:466: __add_missing_keys:
 Assertion `ref->root_id` failed
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtScin-9AomqOwiSTwj=5rCeJW12jv8rv8taxwUq+AX5Lw@mail.gmail.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <b580f4c4-3eb0-9203-75b5-c918f15d12cf@cn.fujitsu.com>
Date: Mon, 18 Dec 2017 11:07:22 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtScin-9AomqOwiSTwj=5rCeJW12jv8rv8taxwUq+AX5Lw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 12/18/2017 10:50 AM, Chris Murphy wrote:
> This is v4.14.
> 
> I've filed a bug which contains the build steps, versions. It's
> crashing on all volumes I try it on so far.
> 
> 

It was fixed by Qu's patch
   btrfs-progs: backref: Allow backref walk to handle direct parent ref
which is available on his github
https://github.com/adam900710/btrfs-progs/tree/lowmem_fix

Thanks,
Su


