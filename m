Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:50835 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbeIFLQ6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2018 07:16:58 -0400
Received: by mail-it0-f65.google.com with SMTP id j81-v6so13358797ite.0
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Sep 2018 23:43:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180831140259.dwvyvskb3xg2ubku@destiny>
References: <20180830174225.2200-1-josef@toxicpanda.com> <20180830174225.2200-23-josef@toxicpanda.com>
 <a433a3b0-dbe1-da97-2d30-1e3ab85e9ec0@suse.com> <20180831140259.dwvyvskb3xg2ubku@destiny>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Wed, 5 Sep 2018 23:43:01 -0700
Message-ID: <CANQeFDCB6eKr2g1MvPq2JzEkLgbczTR3x8uDkiek70ii3eZYhw@mail.gmail.com>
Subject: Re: [PATCH 22/35] btrfs: make sure we create all new bgs
To: Josef Bacik <josef@toxicpanda.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2018 at 7:03 AM, Josef Bacik <josef@toxicpanda.com> wrote:
> On Fri, Aug 31, 2018 at 10:31:49AM +0300, Nikolay Borisov wrote:
>>
>>
>> On 30.08.2018 20:42, Josef Bacik wrote:
>> > We can actually allocate new chunks while we're creating our bg's, so
>> > instead of doing list_for_each_safe, just do while (!list_empty()) so we
>> > make sure to catch any new bg's that get added to the list.
>>
>> HOw can this occur, please elaborate and put an example callstack in the
>> commit log.
>>
>
> Eh?  We're modifying the extent tree and chunk tree, which can cause bg's to be
> allocated, it's just common sense.
>

This explains a bit.

  => btrfs_make_block_group
  => __btrfs_alloc_chunk
  => do_chunk_alloc
  => find_free_extent
  => btrfs_reserve_extent
  => btrfs_alloc_tree_block
  => __btrfs_cow_block
  => btrfs_cow_block
  => btrfs_search_slot
  => btrfs_update_device
  => btrfs_finish_chunk_alloc
  => btrfs_create_pending_block_groups
 ...


Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>

thanks,
liubo
