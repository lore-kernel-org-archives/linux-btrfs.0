Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:54010 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbbAST3b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 14:29:31 -0500
Received: by mail-lb0-f176.google.com with SMTP id z12so9235548lbi.7
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Jan 2015 11:29:30 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 19 Jan 2015 20:29:30 +0100
Message-ID: <CAJO99T=O8ts=GXXi33BR4BPkDgFu6WXWEqFFcUBBTBoNQdNhgg@mail.gmail.com>
Subject: btrfs send multiple subvolumes
From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like this should be supported, but I get an error:

btrfs send -e snapshots/ro@20150118 snapshots/ro@20150119 > foo.btrfssend
At subvol snapshots/ro@20150118
At subvol snapshots/ro@20150119
ERROR: parent determination failed for 0

Linux 3.18.0-rc5 #1 SMP x86_64
Btrfs v3.18.1

-- 
Bj(/)rnar
