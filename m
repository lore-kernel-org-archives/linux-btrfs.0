Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:32886 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755644AbcJTJab (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Oct 2016 05:30:31 -0400
Received: by mail-lf0-f50.google.com with SMTP id x79so77976135lff.0
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Oct 2016 02:30:31 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 20 Oct 2016 12:29:49 +0300
Message-ID: <CAGqmi779inZ8CcXpJ_uX1XXTGS_JrhKNagbL8ms6vA9eVZBFWQ@mail.gmail.com>
Subject: Is it possible to speed up unlink()?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, i use btrfs for NFS VM replica storage and for NFS shared VM storage.
At now i have a small problem what VM image deletion took to long time
and NFS client show a timeout on deletion
(ESXi Storage migration as example).

Kernel: Linux nfs05 4.7.0-0.bpo.1-amd64 #1 SMP Debian 4.7.5-1~bpo8+2
(2016-10-01) x86_64 GNU/Linux
Mount options: noatime,compress-force=zlib,space_cache,commit=180
Feature enabled:
big_metadata:1
compress_lzo:1
extended_iref:1
mixed_backref:1
no_holes:1
skinny_metadata:1

AFAIK, unlink() return only when all references to all extents from
unlinked inode will be deleted
So with compression enabled files have a many many refs to each
compressed chunk.
So, it's possible to return unlink() early? or this a bad idea(and why)?

Thanks.
-- 
Have a nice day,
Timofey.
