Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E383FC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:06:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0B872087E
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:06:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="a7OzLg2T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbfCYSGR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:06:17 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41417 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728912AbfCYSGR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:06:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id 188so1363287pfd.8
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 11:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rtoFKJqx8vv1Ao0sC0WTjGasTwTsWUq1ESP7UxeosHQ=;
        b=a7OzLg2T8HdXjQWKobIEwSEC9zWfvxORUidZ9qCN9uoYvCIGePKqAtpzUXDD2pSrId
         dFBX69ntynuemz06DxY8Nl+ubQwNMGviypIcFAfrM/OE8bkXCOmUCZuU86KLFsw0Vpin
         RUHtfmESfDwGw8sUBYaCQhGLOECPWRozJbcWMAbsvOUlDQZireBHbFu7HI1/I77F9xNk
         SJ191vMexEdqEIJVS6fTF/Mf74OWpB/t56EALX/MfYnVC5zO0EqnA2rGmgu9sTi2jLLq
         Rk0e1nLhmUwV+zmY65Na2kOub2HmNTOqSqvEO6ysEfrhjkbQyfLpRNh2Jvc5XVLfzZaE
         DK7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rtoFKJqx8vv1Ao0sC0WTjGasTwTsWUq1ESP7UxeosHQ=;
        b=Coz0wdWvh3CGlIp3nVOyXafo3IYPZsVX1O5Ng9SmD+tqemx1hTk90fYmiQeHRCm7Ie
         1LBF59DYRoRMGNZ/bRLczrMjhy7WELA9kzZcBz2onukSX5oyppadTHzv5MvUQH4ztsrn
         iqWJUqOU2dmkVEH9xleklLtKD4Sctm0JJ+hgajWtMH7iYIf1og9L4yiVIReeJCKIBd+P
         NZDw0aGuFypisT3Yy2Zue+m0dNCi0/ABuAhSSaJQibOwPlUCZIpaXptSZfvj8Z5+hphl
         oBf1ZIqCk1B8gHwj7yZ0osm0gQ12brhdLn7mD75d0HEaBHCPhKWwgqc4J9c1PU+f4g1y
         kgFg==
X-Gm-Message-State: APjAAAV9UYCFyhqV4oT4DllMvMX4Wh2ZguZBHwqeF/xfBs34fd4oEK34
        p01mz1XqaL9MdAl748bMDjhwK1aakG8=
X-Google-Smtp-Source: APXvYqy+2GU9UP5y6lrqDeRCqL6wW0Xrhkut8lEkkWIZ/muKnqWdq8wTxUEHcB8QkvS9k+wvtabKWg==
X-Received: by 2002:aa7:885a:: with SMTP id k26mr25174237pfo.70.1553537175812;
        Mon, 25 Mar 2019 11:06:15 -0700 (PDT)
Received: from vader ([2620:10d:c090:200::3:b619])
        by smtp.gmail.com with ESMTPSA id h126sm38850299pfc.135.2019.03.25.11.06.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 11:06:15 -0700 (PDT)
Date:   Mon, 25 Mar 2019 11:06:14 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     David Sterba <dsterba@suse.cz>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v1.1] btrfs-progs: Do metadata prealloc as long as we're
 not modifying extent tree
Message-ID: <20190325180614.GD5826@vader>
References: <20180914074944.19526-1-wqu@suse.com>
 <20190305135508.GA31119@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190305135508.GA31119@twin.jikos.cz>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 05, 2019 at 02:55:08PM +0100, David Sterba wrote:
> On Fri, Sep 14, 2018 at 03:49:44PM +0800, Qu Wenruo wrote:
> > In github issues, one user reports unexpected ENOSPC error if enabling
> > datasum.
> > After some investigation, it looks like that during ext2_saved/image
> > creation, we could create large file extent whose size can be 128M (max
> > data extent size).
> > 
> > In that case, its csum will be at least 128K. Under certain case we need
> > to allocate extra metadata chunks to fulfill such space requirement.
> > 
> > However we only do metadata prealloc if we're reserving extents for fs
> > trees.
> > (we use btrfs_root::ref_cows to determine whether we should do metadata
> > prealloc, and that member is only set for fs trees).
> > 
> > There is no explaination on why we only do metadata prealloc for file
> > trees, but at least from my investigation, it could be related to avoid
> > nested extent tree modication.
> > 
> > At least extent reservation for csum tree shouldn't be a problem with
> > metadata block group preallocation.
> > 
> > So change the metadata block group preallocation check from
> > "root->ref_cow" to "root->root_key.objectid !=
> > BTRFS_EXTENT_TREE_OBJECTID", and add some comment for it.
> 
> This looks a bit fragile to me but I don't have a better suggestion for
> a fix. Added to devel, thanks.

This seems to be causing infinite recursion in do_chunk_alloc() during mkfs:

$ truncate -s $((1024 * 1024 * 1024)) foo
$ gdb --args ./mkfs.btrfs foo
GNU gdb (GDB) 8.2.1
Copyright (C) 2018 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-pc-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./mkfs.btrfs...done.
(gdb) r
Starting program: /home/osandov/linux/btrfs-progs/mkfs.btrfs foo
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/usr/lib/libthread_db.so.1".
btrfs-progs v4.20.2
See http://btrfs.wiki.kernel.org for more information.


Program received signal SIGSEGV, Segmentation fault.
0x000055555557fe24 in memcpy (__len=17, __src=0x5555555e5ef5, __dest=0x7fffff7ff040) at /usr/include/bits/string_fortified.h:34
34        return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
(gdb) bt
#0  0x000055555557fe24 in memcpy (__len=17, __src=0x5555555e5ef5, __dest=0x7fffff7ff040) at /usr/include/bits/string_fortified.h:34
#1  read_extent_buffer (eb=eb@entry=0x5555555e5e10, dst=dst@entry=0x7fffff7ff040, start=start@entry=101, len=len@entry=17) at extent_io.c:975
#2  0x0000555555565d1e in btrfs_item_key (nr=0, disk_key=0x7fffff7ff040, eb=0x5555555e5e10) at ctree.h:1905
#3  __btrfs_cow_block (trans=trans@entry=0x5555555f2430, root=root@entry=0x5555555d3e40, buf=buf@entry=0x5555555e5e10, parent=parent@entry=0x0, parent_slot=parent_slot@entry=0, cow_ret=cow_ret@entry=0x7fffff7ff288, search_start=0, empty_size=0) at ctree.c:291
#4  0x0000555555566676 in btrfs_cow_block (trans=trans@entry=0x5555555f2430, root=root@entry=0x5555555d3e40, buf=0x5555555e5e10, parent=0x0, parent_slot=0, cow_ret=cow_ret@entry=0x7fffff7ff288) at ctree.c:388
#5  0x0000555555569319 in btrfs_search_slot (trans=<optimized out>, root=root@entry=0x5555555d3e40, key=key@entry=0x7fffff7ff440, p=p@entry=0x555555738ea0, ins_len=ins_len@entry=73, cow=cow@entry=1) at ctree.c:1158
#6  0x000055555556ab6f in btrfs_insert_empty_items (trans=trans@entry=0x5555555f2430, root=root@entry=0x5555555d3e40, path=path@entry=0x555555738ea0, cpu_key=cpu_key@entry=0x7fffff7ff440, data_size=data_size@entry=0x7fffff7ff43c, nr=nr@entry=1) at ctree.c:2612
#7  0x0000555555580ad7 in btrfs_insert_empty_item (data_size=<optimized out>, key=0x7fffff7ff440, path=0x555555738ea0, root=0x5555555d3e40, trans=0x5555555f2430) at ctree.h:2650
#8  btrfs_insert_dev_extent (trans=trans@entry=0x5555555f2430, device=device@entry=0x5555555d59e0, chunk_offset=chunk_offset@entry=5242880, num_bytes=num_bytes@entry=8388608, start=5242880) at volumes.c:574
#9  0x00005555555818c1 in btrfs_alloc_dev_extent (start=0x7fffff7ff568, num_bytes=8388608, chunk_offset=5242880, device=0x5555555d59e0, trans=0x5555555f2430) at volumes.c:610
#10 btrfs_alloc_chunk (trans=trans@entry=0x5555555f2430, info=info@entry=0x5555555d2970, start=start@entry=0x7fffff7ff698, num_bytes=num_bytes@entry=0x7fffff7ff6a0, type=4) at volumes.c:1143
#11 0x0000555555575ca4 in do_chunk_alloc (trans=trans@entry=0x5555555f2430, fs_info=fs_info@entry=0x5555555d2970, alloc_bytes=alloc_bytes@entry=16384, flags=flags@entry=4) at extent-tree.c:1876
#12 0x0000555555575f8d in btrfs_reserve_extent (trans=trans@entry=0x5555555f2430, root=root@entry=0x5555555d3e40, num_bytes=num_bytes@entry=16384, empty_size=empty_size@entry=0, hint_byte=hint_byte@entry=0, search_end=search_end@entry=18446744073709551615, ins=0x7fffff7ff8c0, is_data=false) at extent-tree.c:2516
#13 0x0000555555576914 in alloc_tree_block (ins=0x7fffff7ff8c0, search_end=18446744073709551615, hint_byte=0, empty_size=0, level=0, key=0x7fffff7ff960, flags=0, generation=<optimized out>, root_objectid=4, num_bytes=16384, root=0x5555555d3e40, trans=0x5555555f2430) at extent-tree.c:2641
#14 btrfs_alloc_free_block (trans=trans@entry=0x5555555f2430, root=root@entry=0x5555555d3e40, blocksize=16384, root_objectid=4, key=key@entry=0x7fffff7ff960, level=level@entry=0, hint=0, empty_size=0) at extent-tree.c:2694
#15 0x0000555555565d4a in __btrfs_cow_block (trans=trans@entry=0x5555555f2430, root=root@entry=0x5555555d3e40, buf=buf@entry=0x5555555e5e10, parent=parent@entry=0x0, parent_slot=parent_slot@entry=0, cow_ret=cow_ret@entry=0x7fffff7ffba8, search_start=0, empty_size=0) at ctree.c:295
#16 0x0000555555566676 in btrfs_cow_block (trans=trans@entry=0x5555555f2430, root=root@entry=0x5555555d3e40, buf=0x5555555e5e10, parent=0x0, parent_slot=0, cow_ret=cow_ret@entry=0x7fffff7ffba8) at ctree.c:388
#17 0x0000555555569319 in btrfs_search_slot (trans=<optimized out>, root=root@entry=0x5555555d3e40, key=key@entry=0x7fffff7ffd60, p=p@entry=0x555555738d30, ins_len=ins_len@entry=73, cow=cow@entry=1) at ctree.c:1158
#18 0x000055555556ab6f in btrfs_insert_empty_items (trans=trans@entry=0x5555555f2430, root=root@entry=0x5555555d3e40, path=path@entry=0x555555738d30, cpu_key=cpu_key@entry=0x7fffff7ffd60, data_size=data_size@entry=0x7fffff7ffd5c, nr=nr@entry=1) at ctree.c:2612
#19 0x0000555555580ad7 in btrfs_insert_empty_item (data_size=<optimized out>, key=0x7fffff7ffd60, path=0x555555738d30, root=0x5555555d3e40, trans=0x5555555f2430) at ctree.h:2650
#20 btrfs_insert_dev_extent (trans=trans@entry=0x5555555f2430, device=device@entry=0x5555555d59e0, chunk_offset=chunk_offset@entry=5242880, num_bytes=num_bytes@entry=8388608, start=5242880) at volumes.c:574
#21 0x00005555555818c1 in btrfs_alloc_dev_extent (start=0x7fffff7ffe88, num_bytes=8388608, chunk_offset=5242880, device=0x5555555d59e0, trans=0x5555555f2430) at volumes.c:610
#22 btrfs_alloc_chunk (trans=trans@entry=0x5555555f2430, info=info@entry=0x5555555d2970, start=start@entry=0x7fffff7fffb8, num_bytes=num_bytes@entry=0x7fffff7fffc0, type=4) at volumes.c:1143
#23 0x0000555555575ca4 in do_chunk_alloc (trans=trans@entry=0x5555555f2430, fs_info=fs_info@entry=0x5555555d2970, alloc_bytes=alloc_bytes@entry=16384, flags=flags@entry=4) at extent-tree.c:1876
#24 0x0000555555575f8d in btrfs_reserve_extent (trans=trans@entry=0x5555555f2430, root=root@entry=0x5555555d3e40, num_bytes=num_bytes@entry=16384, empty_size=empty_size@entry=0, hint_byte=hint_byte@entry=0, search_end=search_end@entry=18446744073709551615, ins=0x7fffff8001e0, is_data=false) at extent-tree.c:2516
#25 0x0000555555576914 in alloc_tree_block (ins=0x7fffff8001e0, search_end=18446744073709551615, hint_byte=0, empty_size=0, level=0, key=0x7fffff800280, flags=0, generation=<optimized out>, root_objectid=4, num_bytes=16384, root=0x5555555d3e40, trans=0x5555555f2430) at extent-tree.c:2641
#26 btrfs_alloc_free_block (trans=trans@entry=0x5555555f2430, root=root@entry=0x5555555d3e40, blocksize=16384, root_objectid=4, key=key@entry=0x7fffff800280, level=level@entry=0, hint=0, empty_size=0) at extent-tree.c:2694
#27 0x0000555555565d4a in __btrfs_cow_block (trans=trans@entry=0x5555555f2430, root=root@entry=0x5555555d3e40, buf=buf@entry=0x5555555e5e10, parent=parent@entry=0x0, parent_slot=parent_slot@entry=0, cow_ret=cow_ret@entry=0x7fffff8004c8, search_start=0, empty_size=0) at ctree.c:295
#28 0x0000555555566676 in btrfs_cow_block (trans=trans@entry=0x5555555f2430, root=root@entry=0x5555555d3e40, buf=0x5555555e5e10, parent=0x0, parent_slot=0, cow_ret=cow_ret@entry=0x7fffff8004c8) at ctree.c:388
#29 0x0000555555569319 in btrfs_search_slot (trans=<optimized out>, root=root@entry=0x5555555d3e40, key=key@entry=0x7fffff800680, p=p@entry=0x555555738bc0, ins_len=ins_len@entry=73, cow=cow@entry=1) at ctree.c:1158
#30 0x000055555556ab6f in btrfs_insert_empty_items (trans=trans@entry=0x5555555f2430, root=root@entry=0x5555555d3e40, path=path@entry=0x555555738bc0, cpu_key=cpu_key@entry=0x7fffff800680, data_size=data_size@entry=0x7fffff80067c, nr=nr@entry=1) at ctree.c:2612
#31 0x0000555555580ad7 in btrfs_insert_empty_item (data_size=<optimized out>, key=0x7fffff800680, path=0x555555738bc0, root=0x5555555d3e40, trans=0x5555555f2430) at ctree.h:2650
#32 btrfs_insert_dev_extent (trans=trans@entry=0x5555555f2430, device=device@entry=0x5555555d59e0, chunk_offset=chunk_offset@entry=5242880, num_bytes=num_bytes@entry=8388608, start=5242880) at volumes.c:574
#33 0x00005555555818c1 in btrfs_alloc_dev_extent (start=0x7fffff8007a8, num_bytes=8388608, chunk_offset=5242880, device=0x5555555d59e0, trans=0x5555555f2430) at volumes.c:610
#34 btrfs_alloc_chunk (trans=trans@entry=0x5555555f2430, info=info@entry=0x5555555d2970, start=start@entry=0x7fffff8008d8, num_bytes=num_bytes@entry=0x7fffff8008e0, type=4) at volumes.c:1143
#35 0x0000555555575ca4 in do_chunk_alloc (trans=trans@entry=0x5555555f2430, fs_info=fs_info@entry=0x5555555d2970, alloc_bytes=alloc_bytes@entry=16384, flags=flags@entry=4) at extent-tree.c:1876
