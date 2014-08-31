Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35635 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaHaHhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Aug 2014 03:37:42 -0400
Received: by mail-wg0-f51.google.com with SMTP id l18so3890110wgh.34
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Aug 2014 00:37:40 -0700 (PDT)
Received: from rembookair.fritz.box (hondenhok.xs4all.nl. [83.160.115.170])
        by mx.google.com with ESMTPSA id wr10sm12462024wjc.10.2014.08.31.00.37.39
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 31 Aug 2014 00:37:39 -0700 (PDT)
From: "Remco Hosman - Yerf IT.nl" <remco@yerf-it.nl>
Content-Type: text/plain; charset=utf-8
Subject: find_mount_root() issue
Message-Id: <62013C11-1628-42C1-929B-24E46858D38B@yerf-it.nl>
Date: Sun, 31 Aug 2014 09:37:38 +0200
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1973.6\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

issue:
on my system i have 2 entries for /, one with the type ‘rootfs’ and a 2nd one with the type ‘btrfs’. find_mount_root() uses the first one and reports a fail.

My change:
if (longest_matchlen < len) {
into:
if (longest_matchlen <= len) {

i have not tested this, but in my understanding it will use the last longest match instead of the first.

I have no idea if this rootfs entry is normal nor if its always there before the ‘proper’ one.

These are the 2 entries in my mount list:
rootfs / rootfs rw 0 0
/dev/sda2 / btrfs rw,noatime,ssd,noacl,space_cache 0 0


Hope this helps,
Remco