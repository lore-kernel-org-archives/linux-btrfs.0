Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFAD2C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 13:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F25820651
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 13:54:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nig-ac-jp.20150623.gappssmtp.com header.i=@nig-ac-jp.20150623.gappssmtp.com header.b="LHXF3TuS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbfAONyx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 08:54:53 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35847 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730089AbfAONyw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 08:54:52 -0500
Received: by mail-pf1-f196.google.com with SMTP id b85so1359405pfc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 05:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nig-ac-jp.20150623.gappssmtp.com; s=20150623;
        h=date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O9S/f+TS97Y/qk/RMoQhkvNtvPpJmHEFUfWZ0y9dWBA=;
        b=LHXF3TuSi+asvPFKBce/zma20bzjt0uyaw1MzQKSdtdgL9McM4rfezNOYc5KuvP3nX
         5QdN6QI1ohGMDPoEBtrqfLuKJPDirtisB+VAoNagJ/D2oqaNsoTg3u4jz+A8IqNtkgoM
         Nk7a4Q9MxQV1GNFniXJCmh9Tx2sTKkL4wEvwKC0XOsPDndJZxNG9p3vXyYPXvxf9fyzI
         0G5iem/gY7UXo/jztXZzIdtQtABC46QJMCrGnyVoJZhQ61hOWO/5hNR1p3hhnjEhGsw/
         OTe/gVmi1Xx4pFBNFic6y/hfcEywkNFDeL+8ugCJ2+pmOMqMisUkIWvf/SEOq3GiKQkk
         ZW0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:to:cc:subject:from:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O9S/f+TS97Y/qk/RMoQhkvNtvPpJmHEFUfWZ0y9dWBA=;
        b=LH3rnqCoc/gQSrBGn451lDrMUSDjnnjzgiA3NUq2d2VR46PqXypQrBrLeAFAtaDlPK
         uuNCf1qGVfkA537bbvscEzY2n+nsY2okYTcdSa+Bapj0X9fc4zxJEJ2xUb5bYZ4fXoMb
         mHE26GrfUGu6TwH/CqodULqtMMKD2Ep38E7sGls2zEN7wG1Rc3+w/9IG7+REtIsLR/SZ
         bcEhjI7TtI5zR8JMCQOEDpUD2b+PP6hO0CXBfKBpbe02TktSoaPD2IXbgiB1qZoOS7ip
         YdRxgYOONC+2MMPuUvJ93RqvgXXtf3q1rODTQDxHvhBgw2WVC3Nsp98xByPyB4TeUL8v
         Nlwg==
X-Gm-Message-State: AJcUukdAL04druESOF8TGzL/4YZ2G42KvRUR3BGcPvBwirpd0el1e6Eq
        RQDMV+5tqUPcvrdE9MSOpTu5bg==
X-Google-Smtp-Source: ALg8bN7qZ2SozfOC6tZuyGPBdWXbwgeVcF3xvhaSLng3mkZuGKLbaAfvy+KtVAoNPIwcS6V6bu8VSw==
X-Received: by 2002:aa7:8802:: with SMTP id c2mr4171933pfo.20.1547560489838;
        Tue, 15 Jan 2019 05:54:49 -0800 (PST)
Received: from localhost (Plcd1.lab.nig.ac.jp. [133.39.89.231])
        by smtp.gmail.com with ESMTPSA id y191sm5805134pfg.56.2019.01.15.05.54.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 05:54:49 -0800 (PST)
Date:   Tue, 15 Jan 2019 22:53:17 +0900 (JST)
Message-Id: <20190115.225317.1036041048727530368.hhiraki@nig.ac.jp>
To:     quwenruo.btrfs@gmx.com
Cc:     linux-btrfs@vger.kernel.org, hhiraki@nig.ac.jp
Subject: Re: How to repair "btrfs_chunk_readonly: BUG_ON `!ce` triggered,
 value 1"?,Re: How to repair "btrfs_chunk_readonly: BUG_ON `!ce` triggered,
 value 1"?
From:   HIRAKI Hideaki <hhiraki@nig.ac.jp>
In-Reply-To: <6520ff6f-c406-b0c2-a640-55d33883b5b8@gmx.com>
References: <20190115.204707.136083983019108814.hhiraki@nig.ac.jp>
        <20190115.204707.136083983019108814.hhiraki@nig.ac.jp>
        <6520ff6f-c406-b0c2-a640-55d33883b5b8@gmx.com>
X-Mailer: Mew version 6.6 on Emacs 26 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Tue_Jan_15_22_53_17_2019_703)--"
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

----Next_Part(Tue_Jan_15_22_53_17_2019_703)--
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit

Dear Qu,

At Tue, 15 Jan 2019 20:55:38 +0800, Qu Wenruo wrote:
> On 2019/1/15 下午7:47, HIRAKI Hideaki wrote:
>> Hello,
>> 
>> I have two questions and a bug report.
>> 
>> Once upon a time I converted an ext3 partition to BTRFS to mount on
>> /var/lib/docker and was happy with it. Recently an error occured:
>> 
>>  kernel: BTRFS info (device sdc1): leaf 2013170442240 total ptrs 171 free space 6365
>>  kernel: BTRFS error (device sdc1): eb 2013170442240 invalid extent inline ref type 182
>>  kernel: BTRFS: Transaction aborted (error -22)
>>  kernel: BTRFS: error (device sdc1) in btrfs_run_delayed_refs:3089: errno=-22 unknown
>>  kernel: BTRFS info (device sdc1): forced readonly
>>  kernel: BTRFS error (device sdc1): pending csums is 77824
>> 
>> Now I know this was caused by the kernel upgrade from 4.12.5 to 4.14.83 which
>> introduced an additional check of alignments rather than by a recent trivial
>> file system corruption.
> 
> Nope, the alignment check is mostly done by tree-checker, but it's not
> the case.
> 
> It's a really valid extent type checker, introduced by commit
> 167ce953ca55 ("Btrfs: add a helper to retrive extent inline ref type"),
> which get merged into v4.14.
> 
> I'm not pretty sure why but this looks like either some corruption in
> extent tree code, or just too old btrfs-convert.
>

I'm sorry too much was ommitted in the message. Grepping "kernel: BTRFS" was
not enough. Full log is attached.

>> But I was hasty and commited such follies as hard
>> resets on busy kernel, btrfs rescue chunk-recover -y,
> 
> Chunk-recovery is normally useless.
> 
>> btrfs check --repair,
> 
> And this could cause more problem unless you're really knowing the
> problem can be fixed or your data isn't that important.
> 
>> etc. As you may expect, the partition is not mountable any more:
>> 
>> # mount -o compress=lzo,noatime /dev/sdc1 /mnt/temp
>> mount: /mnt/temp: wrong fs type, bad option, bad superblock on /dev/sdc1, missing codepage or helper program, or other error.
>> 
>>  kernel: BTRFS info (device sdc1): use lzo compression
>>  kernel: BTRFS info (device sdc1): disk space caching is enabled
>>  kernel: BTRFS info (device sdc1): has skinny extents
>>  kernel: BTRFS info (device sdc1): bdev /dev/sdc1 errs: wr 1396, rd 0, flush 0, corrupt 0, gen 0
>>  kernel: BTRFS error (device sdc1): logical 3955568533504 len 1073741824 found bg but no related chunk
> 
> Some bad recovery move caused more problem, one block group doesn't has
> corresponding chunk.
> I don't know exactly what the cause is.
> 
>>  kernel: BTRFS error (device sdc1): failed to read block groups: -2
>>  kernel: BTRFS error (device sdc1): open_ctree failed
>> 
>> Even btrfs check aborts:
>> 
>> # btrfs check --repair /dev/sdc1
>> enabling repair mode
>> Opening filesystem to check...
>> volumes.c:1729: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1
>> btrfs(+0x2e246)[0x562a5547c246]
>> btrfs(+0x30cac)[0x562a5547ecac]
> 
> This could be worked around.
> 
> diff --git a/volumes.c b/volumes.c
> index 30090ce5f8e8..05deeed710fb 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -1725,9 +1725,7 @@ int btrfs_chunk_readonly(struct btrfs_fs_info
> *fs_info, u64 chunk_offset)
>          * corresponding chunk, we will rebuild it later
>          */
>         ce = search_cache_extent(&map_tree->cache_tree, chunk_offset);
> -       if (!fs_info->is_chunk_recover)
> -               BUG_ON(!ce);
> -       else
> +       if (!ce)
>                 return 0;
> 
>         map = container_of(ce, struct map_lookup, ce);
> 
> 
> 
>> btrfs(btrfs_read_block_groups+0x27d)[0x562a55471f8d]
>> btrfs(btrfs_setup_all_roots+0x35f)[0x562a5546bc9f]
>> btrfs(+0x1e0cb)[0x562a5546c0cb]
>> btrfs(open_ctree_fs_info+0x8c)[0x562a5546c2cc]
>> btrfs(cmd_check+0x4db)[0x562a554b670b]
>> btrfs(main+0x7a)[0x562a55461e2a]
>> /lib64/libc.so.6(__libc_start_main+0xee)[0x7f83e3598bde]
>> btrfs(_start+0x2a)[0x562a55461f3a]
>> Aborted
>> 
>> How to repair this file system?
> 
> Use above diff to allow btrfs check to continue.
> But no --repair, and paste the output.
>

Thank you for the suggestion. That hit another BUG_ON.

# ./btrfs check /dev/sdc1
Opening filesystem to check...
volumes.c:1382: btrfs_rmap_block: BUG_ON `!ce` triggered, value 1
./btrfs(+0x3d001)[0x55c9b23ea001]
./btrfs(+0x3d09f)[0x55c9b23ea09f]
./btrfs(btrfs_rmap_block+0x89)[0x55c9b23ee13d]
./btrfs(exclude_super_stripes+0xd4)[0x55c9b23d9ec3]
./btrfs(btrfs_read_block_groups+0x2b3)[0x55c9b23d7bf0]
./btrfs(btrfs_setup_all_roots+0x402)[0x55c9b23cc49d]
./btrfs(+0x1fe6f)[0x55c9b23cce6f]
./btrfs(open_ctree_fs_info+0x177)[0x55c9b23cd06b]
./btrfs(cmd_check+0x725)[0x55c9b2447784]
./btrfs(main+0x127)[0x55c9b23c08e9]
/lib64/libc.so.6(__libc_start_main+0xee)[0x7f0552d46bde]
./btrfs(_start+0x2a)[0x55c9b23c016a]
Aborted


> Unfortunately, I don't believe the chance of a proper recovery is high.
> 
>> 
>> 
>> The second question is about btrfs-restore. It doesn't restore subvolumes
>> even when the destination path is in a BTRFS file system.
> 
> I had a plan to support snapshot/subvolume creation for btrfs-restore if
> destination is btrfs, or supports reflink.
> 
> But that feature will be too late for your use case anyway.
> 
>> "btrfs restore -l"
>> is to list subvolumes but the output lacks the path (relative to the top
>> level subvolume) information.
> 
> You could try my experimental patch:
> https://patchwork.kernel.org/patch/10738583/
> 
> It provides kernel equivalent of btrfs-restore, using 'ro,skip_bg' mount
> option.
> 
> If everything goes OK, then you should be able to get 'btrfs subv list'
> working.
>

I'll try this later.

Thanks again,

Hideaki


> Thanks,
> Qu
> 
>> With the information, the destination of
>> btrfs-restore with the subvolumes could be prepared and hopefully
>> "dockerd" would work properly with the restored file tree, though the files
>> would be duplicated significantly.
> 
> 
>> 
>> How can the subvolumes' paths be obtained from an unmountable file system?
>> 
>> 
>> By the way, some constants in the source code had to be increased to run
>> btrfs-restore for me.
>> 
>> --- cmds-restore.c~   2018-11-03 19:06:34.000000000 +0900
>> +++ cmds-restore.c    2019-01-09 00:34:17.000000000 +0900
>> @@ -289,7 +289,7 @@ static int copy_one_inline(struct btrfs_
>>  {
>>         struct extent_buffer *leaf = path->nodes[0];
>>         struct btrfs_file_extent_item *fi;
>> -       char buf[4096];
>> +       char buf[65536];
>>         char *outbuf;
>>         u64 ram_size;
>>         ssize_t done;
>> @@ -729,7 +729,7 @@ static int copy_file(struct btrfs_root *
>>         }
>>  
>>         while (1) {
>> -               if (loops >= 0 && loops++ >= 1024) {
>> +               if (loops >= 0 && loops++ >= 102400) {
>>                         enum loop_response resp;
>>  
>>                         resp = ask_to_continue(file);
>> @@ -1007,7 +1007,7 @@ static int search_dir(struct btrfs_root
>>         }
>>  
>>         while (leaf) {
>> -               if (loops++ >= 1024) {
>> +               if (loops++ >= 102400) {
>>                         printf("We have looped trying to restore files in %s "
>>                                "too many times to be making progress, "
>>                                "stopping\n", in_dir);
>> 
>> The first one is to avoid the abortion with "*** stack smashing detected ***".
>> So, not only the increase but also a size checking code (at least) is
>> necessary to fix this bug. I hope the other two constants (if necessary) will
>> be tunable from the command line option.
>> 
>> 
>> For your information:
>> 
>> # uname -a
>> Linux plcd1 4.14.83-gentoo #1 SMP Wed Dec 19 00:20:46 JST 2018 x86_64 Intel(R) Core(TM) i7-3970X CPU @ 3.50GHz GenuineIntel GNU/Linux
>> 
>> # btrfs --version
>> btrfs-progs v4.19 
>> 
>> # btrfs fi show
>> Label: none  uuid: 5e3d788d-5b81-4e3e-8776-5a131d008cbc
>>         Total devices 1 FS bytes used 1.41TiB
>>         devid    1 size 1.82TiB used 1.43TiB path /dev/sdc1
>> 
>> 
>> Regards,
>> 
>> Hideaki
>> 

----Next_Part(Tue_Jan_15_22_53_17_2019_703)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="btrfs.log"

kernel: BTRFS info (device sdc1): leaf 2013170442240 total ptrs 171 free space 6365
kernel: \x09item 0 key (2013167067136 169 0) itemoff 16250 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2020178714624
kernel: \x09\x09\x09(parent 2020178714624 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 1 key (2013167083520 169 0) itemoff 16217 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015173484544
kernel: \x09\x09\x09(parent 2015173484544 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 2 key (2013167099904 169 0) itemoff 16184 itemsize 33
kernel: \x09\x09extent refs 1 gen 64548 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 3 key (2013167116288 169 0) itemoff 16151 itemsize 33
kernel: \x09\x09extent refs 1 gen 64548 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 4 key (2013167149056 169 0) itemoff 16118 itemsize 33
kernel: \x09\x09extent refs 1 gen 64548 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 5 key (2013167181824 169 0) itemoff 16085 itemsize 33
kernel: \x09\x09extent refs 1 gen 64548 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 6 key (2013167198208 169 0) itemoff 16052 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2023501193216
kernel: \x09\x09\x09(parent 2023501193216 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 7 key (2013167214592 169 0) itemoff 16019 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015231467520
kernel: \x09\x09\x09(parent 2015231467520 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 8 key (2013167230976 169 0) itemoff 15986 itemsize 33
kernel: \x09\x09extent refs 1 gen 64548 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 9 key (2013167247360 169 0) itemoff 15953 itemsize 33
kernel: \x09\x09extent refs 1 gen 64548 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 10 key (2013167263744 169 0) itemoff 15920 itemsize 33
kernel: \x09\x09extent refs 1 gen 59623 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 11 key (2013167280128 169 1) itemoff 15887 itemsize 33
kernel: \x09\x09extent refs 1 gen 65563 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 12 key (2013167296512 169 0) itemoff 15854 itemsize 33
kernel: \x09\x09extent refs 1 gen 65563 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 13 key (2013167312896 169 0) itemoff 15821 itemsize 33
kernel: \x09\x09extent refs 1 gen 65563 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 14 key (2013167329280 169 0) itemoff 15788 itemsize 33
kernel: \x09\x09extent refs 1 gen 65563 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 15 key (2013167345664 169 0) itemoff 15755 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018378883072
kernel: \x09\x09\x09(parent 2018378883072 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 16 key (2013167362048 169 0) itemoff 15722 itemsize 33
kernel: \x09\x09extent refs 1 gen 53159 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018422022144
kernel: \x09\x09\x09(parent 2018422022144 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 17 key (2013167378432 169 0) itemoff 15689 itemsize 33
kernel: \x09\x09extent refs 1 gen 65563 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 18 key (2013167394816 169 0) itemoff 15656 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018423005184
kernel: \x09\x09\x09(parent 2018423005184 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 19 key (2013167411200 169 0) itemoff 15623 itemsize 33
kernel: \x09\x09extent refs 1 gen 333163 flags 2
kernel: \x09\x09ref#0: shared block backref parent 2013385154560
kernel: \x09\x09\x09(parent 2013385154560 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 20 key (2013167427584 169 0) itemoff 15590 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013484670976
kernel: \x09\x09\x09(parent 2013484670976 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 21 key (2013167443968 169 0) itemoff 15557 itemsize 33
kernel: \x09\x09extent refs 1 gen 43736 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2021848965120
kernel: \x09\x09\x09(parent 2021848965120 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 22 key (2013167460352 169 0) itemoff 15524 itemsize 33
kernel: \x09\x09extent refs 1 gen 455402 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 23 key (2013167476736 169 0) itemoff 15491 itemsize 33
kernel: \x09\x09extent refs 1 gen 65563 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 24 key (2013167493120 169 0) itemoff 15458 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2021955805184
kernel: \x09\x09\x09(parent 2021955805184 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 25 key (2013167509504 169 0) itemoff 15425 itemsize 33
kernel: \x09\x09extent refs 1 gen 455402 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 26 key (2013167525888 169 0) itemoff 15392 itemsize 33
kernel: \x09\x09extent refs 1 gen 87866 flags 2
kernel: \x09\x09ref#0: tree block backref root 257
kernel: \x09item 27 key (2013167542272 169 0) itemoff 15359 itemsize 33
kernel: \x09\x09extent refs 1 gen 60119 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2014884061184
kernel: \x09\x09\x09(parent 2014884061184 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 28 key (2013167558656 169 0) itemoff 15326 itemsize 33
kernel: \x09\x09extent refs 1 gen 87866 flags 2
kernel: \x09\x09ref#0: tree block backref root 257
kernel: \x09item 29 key (2013167575040 169 0) itemoff 15293 itemsize 33
kernel: \x09\x09extent refs 1 gen 65563 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 30 key (2013167591424 169 0) itemoff 15260 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018242011136
kernel: \x09\x09\x09(parent 2018242011136 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 31 key (2013167624192 169 0) itemoff 15227 itemsize 33
kernel: \x09\x09extent refs 1 gen 43712 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013999144960
kernel: \x09\x09\x09(parent 2013999144960 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 32 key (2013167673344 169 0) itemoff 15194 itemsize 33
kernel: \x09\x09extent refs 1 gen 65563 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 33 key (2013167689728 169 0) itemoff 15161 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2017581981696
kernel: \x09\x09\x09(parent 2017581981696 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 34 key (2013167706112 169 0) itemoff 15128 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2020335722496
kernel: \x09\x09\x09(parent 2020335722496 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 35 key (2013167722496 169 0) itemoff 15095 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015173484544
kernel: \x09\x09\x09(parent 2015173484544 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 36 key (2013167771648 169 0) itemoff 15062 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015212544000
kernel: \x09\x09\x09(parent 2015212544000 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 37 key (2013167788032 169 0) itemoff 15029 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013442629632
kernel: \x09\x09\x09(parent 2013442629632 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 38 key (2013167804416 169 0) itemoff 14996 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015133179904
kernel: \x09\x09\x09(parent 2015133179904 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 39 key (2013167820800 169 0) itemoff 14963 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013442629632
kernel: \x09\x09\x09(parent 2013442629632 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 40 key (2013167853568 169 0) itemoff 14930 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015133179904
kernel: \x09\x09\x09(parent 2015133179904 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 41 key (2013167869952 169 0) itemoff 14897 itemsize 33
kernel: \x09\x09extent refs 1 gen 65563 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 42 key (2013167902720 169 0) itemoff 14864 itemsize 33
kernel: \x09\x09extent refs 1 gen 64881 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 43 key (2013167919104 169 0) itemoff 14831 itemsize 33
kernel: \x09\x09extent refs 1 gen 43712 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2014002388992
kernel: \x09\x09\x09(parent 2014002388992 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 44 key (2013167935488 169 0) itemoff 14798 itemsize 33
kernel: \x09\x09extent refs 1 gen 60119 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2014884061184
kernel: \x09\x09\x09(parent 2014884061184 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 45 key (2013167968256 169 0) itemoff 14765 itemsize 33
kernel: \x09\x09extent refs 1 gen 59623 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 46 key (2013167984640 169 0) itemoff 14732 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018378883072
kernel: \x09\x09\x09(parent 2018378883072 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 47 key (2013168001024 169 0) itemoff 14699 itemsize 33
kernel: \x09\x09extent refs 1 gen 65563 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 48 key (2013168017408 169 0) itemoff 14666 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015133179904
kernel: \x09\x09\x09(parent 2015133179904 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 49 key (2013168033792 169 0) itemoff 14633 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013442629632
kernel: \x09\x09\x09(parent 2013442629632 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 50 key (2013168050176 169 0) itemoff 14600 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015133179904
kernel: \x09\x09\x09(parent 2015133179904 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 51 key (2013168066560 169 0) itemoff 14567 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013442629632
kernel: \x09\x09\x09(parent 2013442629632 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 52 key (2013168082944 169 0) itemoff 14534 itemsize 33
kernel: \x09\x09extent refs 1 gen 65874 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 53 key (2013168115712 169 0) itemoff 14501 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013508624384
kernel: \x09\x09\x09(parent 2013508624384 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 54 key (2013168132096 169 0) itemoff 14468 itemsize 33
kernel: \x09\x09extent refs 1 gen 65563 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 55 key (2013168148480 169 0) itemoff 14435 itemsize 33
kernel: \x09\x09extent refs 1 gen 65563 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 56 key (2013168181248 169 0) itemoff 14402 itemsize 33
kernel: \x09\x09extent refs 1 gen 455403 flags 2
kernel: \x09\x09ref#0: tree block backref root 257
kernel: \x09item 57 key (2013168197632 169 0) itemoff 14369 itemsize 33
kernel: \x09\x09extent refs 1 gen 43736 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2020335722496
kernel: \x09\x09\x09(parent 2020335722496 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 58 key (2013168246784 169 0) itemoff 14336 itemsize 33
kernel: \x09\x09extent refs 1 gen 455391 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 59 key (2013168263168 169 0) itemoff 14303 itemsize 33
kernel: \x09\x09extent refs 1 gen 46145 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015173091328
kernel: \x09\x09\x09(parent 2015173091328 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 60 key (2013168279552 169 0) itemoff 14270 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013508624384
kernel: \x09\x09\x09(parent 2013508624384 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 61 key (2013168328704 169 1) itemoff 14237 itemsize 33
kernel: \x09\x09extent refs 1 gen 455354 flags 258
kernel: \x09\x09ref#0: tree block backref root 4742
kernel: \x09item 62 key (2013168361472 169 0) itemoff 14204 itemsize 33
kernel: \x09\x09extent refs 1 gen 43712 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013999669248
kernel: \x09\x09\x09(parent 2013999669248 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 63 key (2013168377856 169 0) itemoff 14171 itemsize 33
kernel: \x09\x09extent refs 1 gen 455389 flags 2
kernel: \x09\x09ref#0: tree block backref root 4
kernel: \x09item 64 key (2013168394240 169 0) itemoff 14138 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 65 key (2013168410624 169 0) itemoff 14105 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 66 key (2013168427008 169 0) itemoff 14072 itemsize 33
kernel: \x09\x09extent refs 1 gen 58021 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 67 key (2013168476160 169 0) itemoff 14039 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015177564160
kernel: \x09\x09\x09(parent 2015177564160 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 68 key (2013168492544 169 0) itemoff 14006 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 69 key (2013168508928 169 0) itemoff 13973 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015177564160
kernel: \x09\x09\x09(parent 2015177564160 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 70 key (2013168525312 169 0) itemoff 13940 itemsize 33
kernel: \x09\x09extent refs 1 gen 43712 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2014004027392
kernel: \x09\x09\x09(parent 2014004027392 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 71 key (2013168541696 169 0) itemoff 13907 itemsize 33
kernel: \x09\x09extent refs 1 gen 43736 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2022603350016
kernel: \x09\x09\x09(parent 2022603350016 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 72 key (2013168558080 169 0) itemoff 13874 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2021954232320
kernel: \x09\x09\x09(parent 2021954232320 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 73 key (2013168574464 169 0) itemoff 13841 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018379210752
kernel: \x09\x09\x09(parent 2018379210752 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 74 key (2013168590848 169 0) itemoff 13808 itemsize 33
kernel: \x09\x09extent refs 1 gen 455389 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 75 key (2013168607232 169 0) itemoff 13775 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013701677056
kernel: \x09\x09\x09(parent 2013701677056 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 76 key (2013168623616 169 0) itemoff 13742 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018378883072
kernel: \x09\x09\x09(parent 2018378883072 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 77 key (2013168640000 169 0) itemoff 13709 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2017887117312
kernel: \x09\x09\x09(parent 2017887117312 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 78 key (2013168656384 169 0) itemoff 13676 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013442629632
kernel: \x09\x09\x09(parent 2013442629632 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 79 key (2013168672768 169 0) itemoff 13643 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015133179904
kernel: \x09\x09\x09(parent 2015133179904 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 80 key (2013168689152 169 0) itemoff 13610 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018243878912
kernel: \x09\x09\x09(parent 2018243878912 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 81 key (2013168721920 169 0) itemoff 13577 itemsize 33
kernel: \x09\x09extent refs 1 gen 455389 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 82 key (2013168738304 169 0) itemoff 13544 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2023700455424
kernel: \x09\x09\x09(parent 2023700455424 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 83 key (2013168754688 169 0) itemoff 13511 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013508624384
kernel: \x09\x09\x09(parent 2013508624384 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 84 key (2013168771072 169 0) itemoff 13478 itemsize 33
kernel: \x09\x09extent refs 1 gen 43736 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2022603350016
kernel: \x09\x09\x09(parent 2022603350016 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 85 key (2013168787456 169 0) itemoff 13445 itemsize 33
kernel: \x09\x09extent refs 1 gen 71742 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 86 key (2013168803840 169 0) itemoff 13412 itemsize 33
kernel: \x09\x09extent refs 1 gen 455389 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 87 key (2013168820224 169 0) itemoff 13379 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 88 key (2013168836608 169 1) itemoff 13346 itemsize 33
kernel: \x09\x09extent refs 1 gen 455403 flags 2
kernel: \x09\x09ref#0: tree block backref root 257
kernel: \x09item 89 key (2013168852992 169 0) itemoff 13313 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 90 key (2013168869376 169 0) itemoff 13280 itemsize 33
kernel: \x09\x09extent refs 1 gen 455389 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 91 key (2013168885760 169 0) itemoff 13247 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2020418461696
kernel: \x09\x09\x09(parent 2020418461696 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 92 key (2013168902144 169 0) itemoff 13214 itemsize 33
kernel: \x09\x09extent refs 1 gen 455403 flags 2
kernel: \x09\x09ref#0: tree block backref root 257
kernel: \x09item 93 key (2013168918528 169 0) itemoff 13181 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018307989504
kernel: \x09\x09\x09(parent 2018307989504 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 94 key (2013168934912 169 0) itemoff 13148 itemsize 33
kernel: \x09\x09extent refs 1 gen 455403 flags 2
kernel: \x09\x09ref#0: tree block backref root 257
kernel: \x09item 95 key (2013168951296 169 0) itemoff 13115 itemsize 33
kernel: \x09\x09extent refs 1 gen 71742 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 96 key (2013168967680 169 0) itemoff 13082 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013508624384
kernel: \x09\x09\x09(parent 2013508624384 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 97 key (2013168984064 169 0) itemoff 13049 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 98 key (2013169000448 169 0) itemoff 13016 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 99 key (2013169016832 169 0) itemoff 12983 itemsize 33
kernel: \x09\x09extent refs 1 gen 43712 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2014004240384
kernel: \x09\x09\x09(parent 2014004240384 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 100 key (2013169033216 169 0) itemoff 12950 itemsize 33
kernel: \x09\x09extent refs 1 gen 60119 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2014884061184
kernel: \x09\x09\x09(parent 2014884061184 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 101 key (2013169049600 169 0) itemoff 12917 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018247172096
kernel: \x09\x09\x09(parent 2018247172096 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 102 key (2013169065984 169 0) itemoff 12884 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 103 key (2013169082368 169 0) itemoff 12851 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 104 key (2013169115136 169 0) itemoff 12818 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 105 key (2013169180672 169 0) itemoff 12785 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018378883072
kernel: \x09\x09\x09(parent 2018378883072 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 106 key (2013169197056 169 0) itemoff 12752 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2020335689728
kernel: \x09\x09\x09(parent 2020335689728 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 107 key (2013169213440 169 0) itemoff 12719 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 108 key (2013169229824 169 0) itemoff 12686 itemsize 33
kernel: \x09\x09extent refs 1 gen 64888 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 109 key (2013169246208 169 0) itemoff 12653 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2023501193216
kernel: \x09\x09\x09(parent 2023501193216 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 110 key (2013169262592 169 0) itemoff 12620 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015231664128
kernel: \x09\x09\x09(parent 2015231664128 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 111 key (2013169278976 169 0) itemoff 12587 itemsize 33
kernel: \x09\x09extent refs 1 gen 64888 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 112 key (2013169295360 169 0) itemoff 12554 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2023700455424
kernel: \x09\x09\x09(parent 2023700455424 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 113 key (2013169311744 169 0) itemoff 12521 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2017372217344
kernel: \x09\x09\x09(parent 2017372217344 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 114 key (2013169328128 169 0) itemoff 12488 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2023501193216
kernel: \x09\x09\x09(parent 2023501193216 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 115 key (2013169344512 169 0) itemoff 12455 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015231467520
kernel: \x09\x09\x09(parent 2015231467520 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 116 key (2013169360896 169 0) itemoff 12422 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013483720704
kernel: \x09\x09\x09(parent 2013483720704 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 117 key (2013169377280 169 0) itemoff 12389 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 118 key (2013169393664 169 0) itemoff 12356 itemsize 33
kernel: \x09\x09extent refs 1 gen 64888 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 119 key (2013169410048 169 0) itemoff 12323 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 120 key (2013169426432 169 0) itemoff 12290 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 121 key (2013169442816 169 0) itemoff 12257 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2017581981696
kernel: \x09\x09\x09(parent 2017581981696 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 122 key (2013169459200 169 0) itemoff 12224 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2020335722496
kernel: \x09\x09\x09(parent 2020335722496 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 123 key (2013169475584 169 0) itemoff 12191 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 124 key (2013169491968 169 0) itemoff 12158 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015173484544
kernel: \x09\x09\x09(parent 2015173484544 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 125 key (2013169508352 169 0) itemoff 12125 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2021633548288
kernel: \x09\x09\x09(parent 2021633548288 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 126 key (2013169524736 169 0) itemoff 12092 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 127 key (2013169541120 169 0) itemoff 12059 itemsize 33
kernel: \x09\x09extent refs 1 gen 64888 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 128 key (2013169557504 169 0) itemoff 12026 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2013511163904
kernel: \x09\x09\x09(parent 2013511163904 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 129 key (2013169573888 169 0) itemoff 11993 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 130 key (2013169606656 169 0) itemoff 11960 itemsize 33
kernel: \x09\x09extent refs 1 gen 64888 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 131 key (2013169623040 169 0) itemoff 11927 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 132 key (2013169639424 169 0) itemoff 11894 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 133 key (2013169672192 169 0) itemoff 11861 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2021633679360
kernel: \x09\x09\x09(parent 2021633679360 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 134 key (2013169688576 169 0) itemoff 11828 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2021835939840
kernel: \x09\x09\x09(parent 2021835939840 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 135 key (2013169704960 169 0) itemoff 11795 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018379210752
kernel: \x09\x09\x09(parent 2018379210752 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 136 key (2013169737728 169 0) itemoff 11762 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2021835939840
kernel: \x09\x09\x09(parent 2021835939840 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 137 key (2013169754112 169 0) itemoff 11729 itemsize 33
kernel: \x09\x09extent refs 1 gen 455389 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 138 key (2013169770496 169 0) itemoff 11696 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2022490284032
kernel: \x09\x09\x09(parent 2022490284032 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 139 key (2013169786880 169 0) itemoff 11663 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2020335722496
kernel: \x09\x09\x09(parent 2020335722496 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 140 key (2013169803264 169 0) itemoff 11630 itemsize 33
kernel: \x09\x09extent refs 1 gen 455389 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 141 key (2013169819648 169 0) itemoff 11597 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2020335722496
kernel: \x09\x09\x09(parent 2020335722496 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 142 key (2013169852416 169 0) itemoff 11564 itemsize 33
kernel: \x09\x09extent refs 1 gen 455403 flags 2
kernel: \x09\x09ref#0: tree block backref root 257
kernel: \x09item 143 key (2013169868800 169 0) itemoff 11531 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2021835939840
kernel: \x09\x09\x09(parent 2021835939840 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 144 key (2013169885184 169 0) itemoff 11498 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018379210752
kernel: \x09\x09\x09(parent 2018379210752 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 145 key (2013169934336 169 0) itemoff 11465 itemsize 33
kernel: \x09\x09extent refs 1 gen 64889 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2014895153152
kernel: \x09\x09\x09(parent 2014895153152 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 146 key (2013169950720 169 0) itemoff 11432 itemsize 33
kernel: \x09\x09extent refs 1 gen 54095 flags 2
kernel: \x09\x09ref#0: tree block backref root 7
kernel: \x09item 147 key (2013169967104 169 0) itemoff 11399 itemsize 33
kernel: \x09\x09extent refs 1 gen 64885 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 148 key (2013169983488 169 0) itemoff 11366 itemsize 33
kernel: \x09\x09extent refs 1 gen 64885 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 149 key (2013169999872 169 0) itemoff 11333 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2021835939840
kernel: \x09\x09\x09(parent 2021835939840 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 150 key (2013170016256 169 0) itemoff 11300 itemsize 33
kernel: \x09\x09extent refs 1 gen 64885 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 151 key (2013170032640 169 0) itemoff 11267 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2021835939840
kernel: \x09\x09\x09(parent 2021835939840 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 152 key (2013170049024 169 0) itemoff 11234 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 153 key (2013170081792 169 0) itemoff 11201 itemsize 33
kernel: \x09\x09extent refs 1 gen 58021 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2022502195200
kernel: \x09\x09\x09(parent 2022502195200 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 154 key (2013170098176 169 0) itemoff 11168 itemsize 33
kernel: \x09\x09extent refs 1 gen 58021 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2022502195200
kernel: \x09\x09\x09(parent 2022502195200 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 155 key (2013170114560 169 0) itemoff 11135 itemsize 33
kernel: \x09\x09extent refs 1 gen 58021 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2022502195200
kernel: \x09\x09\x09(parent 2022502195200 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 156 key (2013170130944 169 0) itemoff 11102 itemsize 33
kernel: \x09\x09extent refs 1 gen 58021 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2022502195200
kernel: \x09\x09\x09(parent 2022502195200 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 157 key (2013170147328 169 0) itemoff 11069 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015221325824
kernel: \x09\x09\x09(parent 2015221325824 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 158 key (2013170163712 169 0) itemoff 11036 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018191876096
kernel: \x09\x09\x09(parent 2018191876096 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 159 key (2013170180096 169 0) itemoff 11003 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015159410688
kernel: \x09\x09\x09(parent 2015159410688 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 160 key (2013170196480 169 0) itemoff 10970 itemsize 33
kernel: \x09\x09extent refs 1 gen 58021 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2022502195200
kernel: \x09\x09\x09(parent 2022502195200 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 161 key (2013170212864 169 0) itemoff 10937 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015173484544
kernel: \x09\x09\x09(parent 2015173484544 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 162 key (2013170229248 169 0) itemoff 10904 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2015212544000
kernel: \x09\x09\x09(parent 2015212544000 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 163 key (2013170245632 169 0) itemoff 10871 itemsize 33
kernel: \x09\x09extent refs 1 gen 58021 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2022502195200
kernel: \x09\x09\x09(parent 2022502195200 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 164 key (2013170262016 169 0) itemoff 10838 itemsize 33
kernel: \x09\x09extent refs 1 gen 58021 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2022502195200
kernel: \x09\x09\x09(parent 2022502195200 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 165 key (2013170278400 169 0) itemoff 10805 itemsize 33
kernel: \x09\x09extent refs 1 gen 58021 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2022502195200
kernel: \x09\x09\x09(parent 2022502195200 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 166 key (2013170294784 169 0) itemoff 10772 itemsize 33
kernel: \x09\x09extent refs 1 gen 58021 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2022502195200
kernel: \x09\x09\x09(parent 2022502195200 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 167 key (2013170311168 169 0) itemoff 10739 itemsize 33
kernel: \x09\x09extent refs 1 gen 58021 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2022502195200
kernel: \x09\x09\x09(parent 2022502195200 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 168 key (2013170327552 169 0) itemoff 10706 itemsize 33
kernel: \x09\x09extent refs 1 gen 65015 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2018379210752
kernel: \x09\x09\x09(parent 2018379210752 is NOT ALIGNED to nodesize 16384)
kernel: \x09item 169 key (2013170343936 169 0) itemoff 10673 itemsize 33
kernel: \x09\x09extent refs 1 gen 65164 flags 2
kernel: \x09\x09ref#0: tree block backref root 2
kernel: \x09item 170 key (2013170360320 169 0) itemoff 10640 itemsize 33
kernel: \x09\x09extent refs 1 gen 43688 flags 258
kernel: \x09\x09ref#0: shared block backref parent 2022671196160
kernel: \x09\x09\x09(parent 2022671196160 is NOT ALIGNED to nodesize 16384)
kernel: BTRFS error (device sdc1): eb 2013170442240 invalid extent inline ref type 182
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 0 PID: 1444 at fs/btrfs/extent-tree.c:1204 btrfs_get_extent_inline_ref_type+0x76/0xf0 [btrfs]
kernel: Modules linked in: xt_nat veth uinput nfsv3 rpcsec_gss_krb5 nfsv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype xt_conntrack nf_nat nf_conntrack br_netfilter bridge stp llc ipt_REJECT nf_reject_ipv4 xt_multiport iptable_filter ip_tables rfcomm bnep autofs4 nfsd auth_rpcgss nfs_acl ipv6 crc_ccitt nvidia_drm(POE) nvidia_modeset(POE) nvidia(POE) x86_pkg_temp_thermal coretemp kvm_intel kvm drm_kms_helper btusb snd_hda_codec_hdmi drm syscopyarea sysfillrect btrtl btbcm btintel bluetooth sysimgblt fb_sys_fops ecdh_generic rfkill snd_hda_codec_realtek snd_hda_codec_generic e1000e irqbypass snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep iTCO_wdt snd_pcm snd_timer snd soundcore iTCO_vendor_support crc32c_intel
kernel:  wmi_bmof ghash_clmulni_intel mxm_wmi wmi cryptd pcspkr lpc_ich mfd_core ata_generic pata_acpi pcc_cpufreq xts cbc sha256_generic ixgb ixgbe tulip cxgb3 cxgb mdio cxgb4 vxge bonding vxlan ip6_udp_tunnel udp_tunnel macvlan vmxnet3 tg3 sky2 r8169 pcnet32 mii igb ptp pps_core dca i2c_algo_bit i2c_core e1000 bnx2 atl1c msdos fat configfs cramfs squashfs fuse xfs nfs lockd grace sunrpc fscache jfs reiserfs btrfs zstd_decompress zstd_compress xxhash ext4 jbd2 ext2 mbcache linear raid10 raid1 raid0 dm_zero dm_verity reed_solomon dm_thin_pool dm_switch dm_snapshot dm_raid raid456 async_raid6_recov async_memcpy async_pq raid6_pq dm_mirror dm_region_hash dm_log_writes dm_log_userspace dm_log dm_integrity async_xor async_tx xor dm_flakey dm_era dm_delay dm_crypt dm_cache_smq dm_cache dm_persistent_data
kernel:  libcrc32c dm_bufio dm_bio_prison dm_mod dax firewire_core crc_itu_t sl811_hcd xhci_pci xhci_hcd usb_storage mpt3sas raid_class aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm aacraid sx8 hpsa 3w_9xxx 3w_xxxx 3w_sas mptsas scsi_transport_sas mptfc scsi_transport_fc mptspi mptscsih mptbase imm parport sym53c8xx initio arcmsr aic7xxx aic79xx scsi_transport_spi sr_mod cdrom sg sd_mod pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_via pata_jmicron pata_marvell pata_sis pata_netcell pata_pdc202xx_old pata_atiixp pata_amd pata_ali pata_it8213 pata_pcmcia pata_serverworks pata_oldpiix pata_artop pata_it821x pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x
kernel:  pata_sil680 pata_pdc2027x nvme nvme_core virtio_net virtio_crypto crypto_engine virtio_mmio virtio_pci virtio_balloon virtio_rng virtio_console virtio_blk virtio_scsi virtio_ring virtio
kernel: CPU: 0 PID: 1444 Comm: kworker/u24:3 Tainted: P           OE   4.14.83-gentoo #1
kernel: Hardware name: System manufacturer System Product Name/P9X79 PRO, BIOS 3305 12/25/2012
kernel: Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
kernel: task: ffff97cd612ccbc0 task.stack: ffffa2d5c2908000
kernel: RIP: 0010:btrfs_get_extent_inline_ref_type+0x76/0xf0 [btrfs]
kernel: RSP: 0018:ffffa2d5c290baf8 EFLAGS: 00010282
kernel: RAX: 000000000000004e RBX: 00000000000000b6 RCX: 0000000000000006
kernel: RDX: 0000000000000007 RSI: 0000000000000046 RDI: ffff97cdaf215550
kernel: RBP: ffff97cda2c6fc08 R08: 0000000000000001 R09: 0000000000000669
kernel: R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000001
kernel: R13: 0000000000003d84 R14: 0000000000003d84 R15: 0000000000003d8d
kernel: FS:  0000000000000000(0000) GS:ffff97cdaf200000(0000) knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 000000c42072a000 CR3: 00000001b020a002 CR4: 00000000000606f0
kernel: Call Trace:
kernel:  lookup_inline_extent_backref+0x31a/0x5e0 [btrfs]
kernel:  ? set_extent_bit+0x19/0x20 [btrfs]
kernel:  insert_inline_extent_backref+0x44/0xc0 [btrfs]
kernel:  __btrfs_inc_extent_ref.isra.22+0x6b/0x230 [btrfs]
kernel:  __btrfs_run_delayed_refs+0x6dd/0x1230 [btrfs]
kernel:  ? __switch_to_asm+0x40/0x70
kernel:  btrfs_run_delayed_refs+0x7e/0x260 [btrfs]
kernel:  delayed_ref_async_start+0x8d/0xa0 [btrfs]
kernel:  btrfs_scrubparity_helper+0x72/0x2d0 [btrfs]
kernel:  process_one_work+0x1ca/0x3c0
kernel:  worker_thread+0x47/0x3f0
kernel:  kthread+0xfc/0x130
kernel:  ? process_one_work+0x3c0/0x3c0
kernel:  ? kthread_create_on_node+0x40/0x40
kernel:  ret_from_fork+0x3a/0x50
kernel: Code: 00 00 00 74 33 81 fb b2 00 00 00 74 2b 48 89 ef e8 d0 e1 00 00 48 8b 7d 18 48 8b 55 00 89 d9 48 c7 c6 a8 27 d2 c0 e8 ca de fe ff <0f> 0b 31 db 89 d8 5b 5d 41 5c 41 5d c3 41 83 fc 01 74 35 41 83 
kernel: ---[ end trace fc99e0a359d12e2e ]---
kernel: BTRFS: Transaction aborted (error -22)
kernel: ------------[ cut here ]------------
kernel: WARNING: CPU: 0 PID: 1444 at fs/btrfs/extent-tree.c:3089 btrfs_run_delayed_refs+0x24c/0x260 [btrfs]
kernel: Modules linked in: xt_nat veth uinput nfsv3 rpcsec_gss_krb5 nfsv4 ipt_MASQUERADE nf_nat_masquerade_ipv4 nf_conntrack_netlink nfnetlink iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype xt_conntrack nf_nat nf_conntrack br_netfilter bridge stp llc ipt_REJECT nf_reject_ipv4 xt_multiport iptable_filter ip_tables rfcomm bnep autofs4 nfsd auth_rpcgss nfs_acl ipv6 crc_ccitt nvidia_drm(POE) nvidia_modeset(POE) nvidia(POE) x86_pkg_temp_thermal coretemp kvm_intel kvm drm_kms_helper btusb snd_hda_codec_hdmi drm syscopyarea sysfillrect btrtl btbcm btintel bluetooth sysimgblt fb_sys_fops ecdh_generic rfkill snd_hda_codec_realtek snd_hda_codec_generic e1000e irqbypass snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep iTCO_wdt snd_pcm snd_timer snd soundcore iTCO_vendor_support crc32c_intel
kernel:  wmi_bmof ghash_clmulni_intel mxm_wmi wmi cryptd pcspkr lpc_ich mfd_core ata_generic pata_acpi pcc_cpufreq xts cbc sha256_generic ixgb ixgbe tulip cxgb3 cxgb mdio cxgb4 vxge bonding vxlan ip6_udp_tunnel udp_tunnel macvlan vmxnet3 tg3 sky2 r8169 pcnet32 mii igb ptp pps_core dca i2c_algo_bit i2c_core e1000 bnx2 atl1c msdos fat configfs cramfs squashfs fuse xfs nfs lockd grace sunrpc fscache jfs reiserfs btrfs zstd_decompress zstd_compress xxhash ext4 jbd2 ext2 mbcache linear raid10 raid1 raid0 dm_zero dm_verity reed_solomon dm_thin_pool dm_switch dm_snapshot dm_raid raid456 async_raid6_recov async_memcpy async_pq raid6_pq dm_mirror dm_region_hash dm_log_writes dm_log_userspace dm_log dm_integrity async_xor async_tx xor dm_flakey dm_era dm_delay dm_crypt dm_cache_smq dm_cache dm_persistent_data
kernel:  libcrc32c dm_bufio dm_bio_prison dm_mod dax firewire_core crc_itu_t sl811_hcd xhci_pci xhci_hcd usb_storage mpt3sas raid_class aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm aacraid sx8 hpsa 3w_9xxx 3w_xxxx 3w_sas mptsas scsi_transport_sas mptfc scsi_transport_fc mptspi mptscsih mptbase imm parport sym53c8xx initio arcmsr aic7xxx aic79xx scsi_transport_spi sr_mod cdrom sg sd_mod pdc_adma sata_inic162x sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise pata_via pata_jmicron pata_marvell pata_sis pata_netcell pata_pdc202xx_old pata_atiixp pata_amd pata_ali pata_it8213 pata_pcmcia pata_serverworks pata_oldpiix pata_artop pata_it821x pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x
kernel:  pata_sil680 pata_pdc2027x nvme nvme_core virtio_net virtio_crypto crypto_engine virtio_mmio virtio_pci virtio_balloon virtio_rng virtio_console virtio_blk virtio_scsi virtio_ring virtio
kernel: CPU: 0 PID: 1444 Comm: kworker/u24:3 Tainted: P        W  OE   4.14.83-gentoo #1
kernel: Hardware name: System manufacturer System Product Name/P9X79 PRO, BIOS 3305 12/25/2012
kernel: Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
kernel: task: ffff97cd612ccbc0 task.stack: ffffa2d5c2908000
kernel: RIP: 0010:btrfs_run_delayed_refs+0x24c/0x260 [btrfs]
kernel: RSP: 0018:ffffa2d5c290bdb8 EFLAGS: 00010296
kernel: RAX: 0000000000000026 RBX: ffff97cbf45b0e88 RCX: ffffffffac24dca8
kernel: RDX: 0000000000000001 RSI: 0000000000000046 RDI: ffffffffac8243ac
kernel: RBP: ffff97cda07b0000 R08: 0000000000000001 R09: 0000000000000690
kernel: R10: 0000000000000002 R11: 0000000000000000 R12: 00000000000003fe
kernel: R13: ffff97cd76dea800 R14: 00000000000003fe R15: ffff97ccf9fc33c0
kernel: FS:  0000000000000000(0000) GS:ffff97cdaf200000(0000) knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 000000c42072a000 CR3: 00000001b020a002 CR4: 00000000000606f0
kernel: Call Trace:
kernel:  delayed_ref_async_start+0x8d/0xa0 [btrfs]
kernel:  btrfs_scrubparity_helper+0x72/0x2d0 [btrfs]
kernel:  process_one_work+0x1ca/0x3c0
kernel:  worker_thread+0x47/0x3f0
kernel:  kthread+0xfc/0x130
kernel:  ? process_one_work+0x3c0/0x3c0
kernel:  ? kthread_create_on_node+0x40/0x40
kernel:  ret_from_fork+0x3a/0x50
kernel: Code: c7 c6 40 b8 d1 c0 48 89 df 44 89 04 24 e8 d9 36 09 00 44 8b 04 24 eb 8d 44 89 c6 48 c7 c7 d8 27 d2 c0 44 89 04 24 e8 3f ce 62 ea <0f> 0b 44 8b 04 24 eb c4 66 90 66 2e 0f 1f 84 00 00 00 00 00 e8 
kernel: ---[ end trace fc99e0a359d12e2f ]---
kernel: BTRFS: error (device sdc1) in btrfs_run_delayed_refs:3089: errno=-22 unknown
kernel: BTRFS info (device sdc1): forced readonly
kernel: BTRFS error (device sdc1): pending csums is 77824

----Next_Part(Tue_Jan_15_22_53_17_2019_703)----
