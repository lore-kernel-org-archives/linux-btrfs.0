Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:49285 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754144AbcK1H1d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 02:27:33 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id AD096AC00A7
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2016 16:27:24 +0900 (JST)
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [bug] btrfs-progs-v4.8.4: test of 'btrfs receive' in xfstests fails
To: David Sterba <dsterba@suse.cz>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <79c9366a-913f-375f-8fa6-729947b74901@jp.fujitsu.com>
Date: Mon, 28 Nov 2016 16:27:06 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David,

Many test of xfstests such as btrfs/007, btrfs/008 and btrfs/016 failed
with the following patch.

  fefbab75  btrfs-progs: send-stream: check number of read bytes from stream

This is because cmds-receive.c:do_receive() make a judgement of the end
of stream by returning 1 from send-stream.c:read_buf().
So, when applying this patch, 'btrfs receive' will always output the
following message at the end of stream.

  ERROR: short read from stream: expected 17 read 0

Thanks,
Tsutomu

