Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4CFC677E4
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 15:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E450D21557
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 15:29:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E450D21557
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbeJHWl4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 18:41:56 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:33664 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbeJHWlz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2018 18:41:55 -0400
Received: from tux.wizards.de (p3EE2F45F.dip0.t-ipconnect.de [62.226.244.95])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 6BB7F4160642;
        Mon,  8 Oct 2018 17:29:38 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 0C9B3ED347C;
        Mon,  8 Oct 2018 17:29:38 +0200 (CEST)
Subject: Re: Curious problem: btrfs device stats & unpriviliged access
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <05c64256-71d3-81dc-3189-628e8cc0a5db@applied-asynchrony.com>
 <5eafba35-c79b-17f2-e296-aafddf06ebf1@mendix.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <7bcc7f99-a857-6ef1-d2df-a256424d2b29@applied-asynchrony.com>
Date:   Mon, 8 Oct 2018 17:29:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <5eafba35-c79b-17f2-e296-aafddf06ebf1@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 10/08/18 16:40, Hans van Kranenburg wrote:
>> Looking at the kernel side of things in fs/btrfs/ioctl.c I see both
>> BTRFS_IOC_TREE_SEARCH[_V2} unconditionally require CAP_SYS_ADMIN.
> 
> That's the tree search ioctl, for reading arbitrary metadata.
> 
> The device stats ioctl is IOC_GET_DEV_STATS...

Yeah..OK, that is clear and gave me the hint to ask: why is it
calling this in the first place? And as it turns out [1] is where
it seems to go wrong, as is_block_device() returns 0 (as it should),
fi_args.num_devices is never set (remains 0) and it proceeds to call
everything below, eventually calling the BTRFS_IOC_FS_INFO ioctl in
#1712. And that works fine:

1711 if (fi_args->num_devices != 1) {
(gdb) s
1712	ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
(gdb) s
1713	if (ret < 0) {
(gdb) p ret
$28 = 0
(gdb) p *fi_args
$30 = {
   max_id = 1,
   num_devices = 1,
   fsid = "z%:\371\315\033A\203\267.\200\255;FH\221",
   nodesize = 16384,
   sectorsize = 4096,
   clone_alignment = 4096,
   reserved32 = 0,
   reserved = {0 <repeats 122 times>}
}

It's only when it goes into search_chunk_tree_for_fs_info()
where things fail due to CAP_SYS_ADMIN.

And all this explains the actual bug: when I call btrfs device stats
not on the mountpoint (as I've been trying all this time) but rather
on the device, it works properly right away as regular user:

(gdb) set args device stats /dev/loop0
(gdb) r
Breakpoint 1, get_fs_info (path=path@entry=0x7fffffffe527 "/dev/loop0", fi_args=fi_args@entry=0x7fffffffd400,
     di_ret=di_ret@entry=0x7fffffffd3f0) at utils.c:1652
1652	{
(gdb) c
Continuing.
[/dev/loop0].write_io_errs    0
[/dev/loop0].read_io_errs     0
[/dev/loop0].flush_io_errs    0
[/dev/loop0].corruption_errs  0
[/dev/loop0].generation_errs  0
[Inferior 1 (process 2805) exited normally]

So this is simply a discrepancy in handling a device vs. the device(s)
for a mountpoint.

> I can do the device stats ioctl as normal user:
> 
> import btrfs
> fs = btrfs.FileSystem('/')
> btrfs.utils.pretty_print(fs.dev_stats(1))
> 
> <btrfs.ioctl.DevStats>
> devid: 1
> nr_items: 5
> flags: 0
> write_errs: 0
> read_errs: 0
> flush_errs: 0
> generation_errs: 0
> corruption_errs: 0

That works for me too, and that's actually the important part. \o/
Glad we talked about it. :}

-h

[1] https://github.com/kdave/btrfs-progs/blob/7faaca0d9f78f7162ae603231f693dd8e1af2a41/utils.c#L1666

