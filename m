Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41211 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550Ab2J3LFC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 07:05:02 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so90687pad.19
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2012 04:05:02 -0700 (PDT)
Message-ID: <508FB45B.9040101@gmail.com>
Date: Tue, 30 Oct 2012 19:04:59 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Why btrfs inline small file by default?
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I am testing my btrfs root partition with "max_inline=0", and 64k leaf size for weeks and it seems that it is fine.


AFAIK btrfs inline small files into metadata by default, I am curious why?

If there is only a few small files, then there will be neither effect nor benefit at all
If there is a lot of small files, then the size of metadata will be undesirable due to deduplication

there are also some email threads related to problem of metadata inline (i don't know whether they are fixed in recent kernel):
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16295.html
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg05265.html

How about turning off inline so that btrfs works better "out of the box"?

ching



