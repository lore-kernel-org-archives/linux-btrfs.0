Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:64071 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbaLBFys (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 00:54:48 -0500
Received: by mail-vc0-f175.google.com with SMTP id hy10so5460771vcb.34
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 21:54:48 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 2 Dec 2014 06:54:47 +0100
Message-ID: <CAE8gLhnq_HjcB=Teis751eXD1FKEVTgfbY-2yDCB77-7oz5Yaw@mail.gmail.com>
Subject: BTRFS equivalent for tune2fs?
From: MegaBrutal <megabrutal@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I know there is a btrfstune, but it doesn't provide all the
functionality I'm thinking of.

For ext2/3/4 file systems I can get a bunch of useful data with
"tune2fs -l". How can I retrieve the same type of information about a
BTRFS file system? (E.g., last mount time, last checked time, blocks
reserved for superuser*, etc.)

* Anyway, does BTRFS even have an option to reserve X% for the superuser?
