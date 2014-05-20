Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:46305 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaETKPt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 06:15:49 -0400
Received: by mail-qg0-f52.google.com with SMTP id a108so327281qge.25
        for <linux-btrfs@vger.kernel.org>; Tue, 20 May 2014 03:15:49 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 20 May 2014 18:15:49 +0800
Message-ID: <CAF1ZMEfRCrnNU9HNUZwm2V154Z1f639m6ctFMKVbi3dRQw2cVQ@mail.gmail.com>
Subject: btrfs-progs: add arg_strtou64 break library btrfs
From: "Dennis Lan (dlan)" <dennis.yxun@gmail.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

progs # cat btrfs_mini_tst.c
 /*
  * gcc -o btrfs_mini_tst btrfs_mini_tst.c -lbtrfs
  */

  char btrfs_read_and_process_send_stream ();
 int
 main ()
 {
 return btrfs_read_and_process_send_stream ();
 }

progs # gcc -o btrfs_mini_tst btrfs_mini_tst.c -lbtrfs
/usr/lib/gcc/x86_64-pc-linux-gnu/4.8.2/../../../../lib64/libbtrfs.so:
undefined reference to `arg_strtou64'
collect2: error: ld returned 1 exit status


but if I also add file utils.c into libbtrfs, more undefined error occurs.
