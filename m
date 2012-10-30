Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38397 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537Ab2J3Lra (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 07:47:30 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so127902pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2012 04:47:30 -0700 (PDT)
Message-ID: <508FBE50.6070300@gmail.com>
Date: Tue, 30 Oct 2012 19:47:28 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs defrag problem
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I try to defrag my btrfs root partition (run by root privilege)

find / -type f -o -type d -print0 | xargs --null --no-run-if-empty btrfs filesystem defragment -t $((32*1024*1024))


1. This kind of error messages is prompted:

    failed to open /bin/bash
    open:: Text file busy
    total 1 failures
    failed to open /lib64/ld-2.15.so
    open:: Text file busy
    total 1 failures
    failed to open /sbin/agetty
    open:: Text file busy
    failed to open /sbin/btrfs
    open:: Text file busy
    failed to open /sbin/dhclient
    open:: Text file busy
    failed to open /sbin/init
    open:: Text file busy
    failed to open /sbin/udevd

    It seems that locked files cannot be defragged, is it expected behaviour?

2. Btrfs Wiki mentions that defrag directory will defrag metadata, is symlink/hardlink considered as metadata?

    P.S. inline data is already disabled by "max_inline=0"

3. Is any possible to online defrag a btrfs partition without hindered by mount point/polyinstantied directories?


Thank you.

ching


