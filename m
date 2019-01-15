Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PLING_QUERY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AF4C43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 11:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E01F20656
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 11:47:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nig-ac-jp.20150623.gappssmtp.com header.i=@nig-ac-jp.20150623.gappssmtp.com header.b="jwhRwtlN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfAOLrP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 06:47:15 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44504 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfAOLrO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 06:47:14 -0500
Received: by mail-pg1-f196.google.com with SMTP id t13so1144467pgr.11
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 03:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nig-ac-jp.20150623.gappssmtp.com; s=20150623;
        h=date:message-id:to:cc:subject:from:mime-version
         :content-transfer-encoding;
        bh=px1E9hCA0Ub2g2gYGJlnTM7NKM7EYZpvM90EjyqEagU=;
        b=jwhRwtlNW66sUX9sWIfMmLsthPTG6tAdnZ+o1XzGpSLrvs9zwHaOGYWVpXmF7G+tPa
         UFc6te2HZ3XNCO2+OBcmUEr1T7QYhCTPxq/XNBjuR0ZYf6Jdm3BlLukkE1ZwEQ+f2M3P
         +JqUkc2W5E7bW38N+MlEE7yox9kK5A8FhU+JPAusBeLxaMoTSehZl5A5LpaOwjLQL69y
         moGurLItlFFtn2YQwarLlrzDTJ/xZgbhqvIpl8n7s8sPhRD2BXA0USwGIQYKW/6DVp4E
         N7DnXwekXPJbhz3dJSBj84IDphh4cKGSdpgYZoHwdzbaK9UQ4vsgrbEBqH7hukkc4pz1
         WhRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:to:cc:subject:from:mime-version
         :content-transfer-encoding;
        bh=px1E9hCA0Ub2g2gYGJlnTM7NKM7EYZpvM90EjyqEagU=;
        b=PIxfUHcydpZZ6nI2zsTV1aZDszLKvrEDFCb202YrS1glVRWgl0noPOayFNIn/rcgKp
         w6mpeq9IUNBvGKxpcx+S2YwtePe5Tc8Dks6sSR+hPyzFFoclvD/7Y2aWmpq722xoefHo
         eQUKFsf6JIaqFqL+x24P4+YwkL/qaX+F8LmW3WzBQyBiSsNQFFVC3Hr5JKFtbQZsrKvu
         k2Q3mVjszOeGi9jTXsv7KBk104892CL7wFPhNXXLjhMZKEhruOzb0Ks7SQrT6toUe7Cn
         aUEkNqSVG+YyiLtgQUuakI1OaSuZeus5St+H+DP6HrdhynBEgNO0FMRBcqfiipatgUCi
         2liw==
X-Gm-Message-State: AJcUukfXeet2pUUkxSYGhaXhunrcFshaz7AT3MIZuxc95r5CuAvRZwQ9
        x3irQtEVeIyZ2ubpskelOeZjDx9ByM8=
X-Google-Smtp-Source: ALg8bN7l+NPE8qB7hEp6W1V34reqkkyUMJAKTe9eomxA4BQEQkDX2Zl4V9ZBY3SmdZ6chO5nj+cETw==
X-Received: by 2002:a62:7c47:: with SMTP id x68mr3594632pfc.209.1547552833046;
        Tue, 15 Jan 2019 03:47:13 -0800 (PST)
Received: from localhost (Plcd1.lab.nig.ac.jp. [133.39.89.231])
        by smtp.gmail.com with ESMTPSA id m67sm4264576pfm.73.2019.01.15.03.47.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 03:47:12 -0800 (PST)
Date:   Tue, 15 Jan 2019 20:47:07 +0900 (JST)
Message-Id: <20190115.204707.136083983019108814.hhiraki@nig.ac.jp>
To:     linux-btrfs@vger.kernel.org
Cc:     hhiraki@nig.ac.jp
Subject: How to repair "btrfs_chunk_readonly: BUG_ON `!ce` triggered, value
 1"?
From:   HIRAKI Hideaki <hhiraki@nig.ac.jp>
X-Mailer: Mew version 6.6 on Emacs 26 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello,

I have two questions and a bug report.

Once upon a time I converted an ext3 partition to BTRFS to mount on
/var/lib/docker and was happy with it. Recently an error occured:

 kernel: BTRFS info (device sdc1): leaf 2013170442240 total ptrs 171 free space 6365
 kernel: BTRFS error (device sdc1): eb 2013170442240 invalid extent inline ref type 182
 kernel: BTRFS: Transaction aborted (error -22)
 kernel: BTRFS: error (device sdc1) in btrfs_run_delayed_refs:3089: errno=-22 unknown
 kernel: BTRFS info (device sdc1): forced readonly
 kernel: BTRFS error (device sdc1): pending csums is 77824

Now I know this was caused by the kernel upgrade from 4.12.5 to 4.14.83 which
introduced an additional check of alignments rather than by a recent trivial
file system corruption. But I was hasty and commited such follies as hard
resets on busy kernel, btrfs rescue chunk-recover -y, btrfs check --repair,
etc. As you may expect, the partition is not mountable any more:

# mount -o compress=lzo,noatime /dev/sdc1 /mnt/temp
mount: /mnt/temp: wrong fs type, bad option, bad superblock on /dev/sdc1, missing codepage or helper program, or other error.

 kernel: BTRFS info (device sdc1): use lzo compression
 kernel: BTRFS info (device sdc1): disk space caching is enabled
 kernel: BTRFS info (device sdc1): has skinny extents
 kernel: BTRFS info (device sdc1): bdev /dev/sdc1 errs: wr 1396, rd 0, flush 0, corrupt 0, gen 0
 kernel: BTRFS error (device sdc1): logical 3955568533504 len 1073741824 found bg but no related chunk
 kernel: BTRFS error (device sdc1): failed to read block groups: -2
 kernel: BTRFS error (device sdc1): open_ctree failed

Even btrfs check aborts:

# btrfs check --repair /dev/sdc1
enabling repair mode
Opening filesystem to check...
volumes.c:1729: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1
btrfs(+0x2e246)[0x562a5547c246]
btrfs(+0x30cac)[0x562a5547ecac]
btrfs(btrfs_read_block_groups+0x27d)[0x562a55471f8d]
btrfs(btrfs_setup_all_roots+0x35f)[0x562a5546bc9f]
btrfs(+0x1e0cb)[0x562a5546c0cb]
btrfs(open_ctree_fs_info+0x8c)[0x562a5546c2cc]
btrfs(cmd_check+0x4db)[0x562a554b670b]
btrfs(main+0x7a)[0x562a55461e2a]
/lib64/libc.so.6(__libc_start_main+0xee)[0x7f83e3598bde]
btrfs(_start+0x2a)[0x562a55461f3a]
Aborted

How to repair this file system?


The second question is about btrfs-restore. It doesn't restore subvolumes
even when the destination path is in a BTRFS file system. "btrfs restore -l"
is to list subvolumes but the output lacks the path (relative to the top
level subvolume) information. With the information, the destination of
btrfs-restore with the subvolumes could be prepared and hopefully
"dockerd" would work properly with the restored file tree, though the files
would be duplicated significantly.

How can the subvolumes' paths be obtained from an unmountable file system?


By the way, some constants in the source code had to be increased to run
btrfs-restore for me.

--- cmds-restore.c~   2018-11-03 19:06:34.000000000 +0900
+++ cmds-restore.c    2019-01-09 00:34:17.000000000 +0900
@@ -289,7 +289,7 @@ static int copy_one_inline(struct btrfs_
 {
        struct extent_buffer *leaf = path->nodes[0];
        struct btrfs_file_extent_item *fi;
-       char buf[4096];
+       char buf[65536];
        char *outbuf;
        u64 ram_size;
        ssize_t done;
@@ -729,7 +729,7 @@ static int copy_file(struct btrfs_root *
        }
 
        while (1) {
-               if (loops >= 0 && loops++ >= 1024) {
+               if (loops >= 0 && loops++ >= 102400) {
                        enum loop_response resp;
 
                        resp = ask_to_continue(file);
@@ -1007,7 +1007,7 @@ static int search_dir(struct btrfs_root
        }
 
        while (leaf) {
-               if (loops++ >= 1024) {
+               if (loops++ >= 102400) {
                        printf("We have looped trying to restore files in %s "
                               "too many times to be making progress, "
                               "stopping\n", in_dir);

The first one is to avoid the abortion with "*** stack smashing detected ***".
So, not only the increase but also a size checking code (at least) is
necessary to fix this bug. I hope the other two constants (if necessary) will
be tunable from the command line option.


For your information:

# uname -a
Linux plcd1 4.14.83-gentoo #1 SMP Wed Dec 19 00:20:46 JST 2018 x86_64 Intel(R) Core(TM) i7-3970X CPU @ 3.50GHz GenuineIntel GNU/Linux

# btrfs --version
btrfs-progs v4.19 

# btrfs fi show
Label: none  uuid: 5e3d788d-5b81-4e3e-8776-5a131d008cbc
        Total devices 1 FS bytes used 1.41TiB
        devid    1 size 1.82TiB used 1.43TiB path /dev/sdc1


Regards,

Hideaki
