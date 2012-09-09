Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63267 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2IIADr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Sep 2012 20:03:47 -0400
Received: by obbuo13 with SMTP id uo13so1199498obb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Sep 2012 17:03:46 -0700 (PDT)
Message-ID: <504BDCE0.8020407@gmail.com>
Date: Sun, 09 Sep 2012 08:03:44 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: enquiry about defrag
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

i am new on btrfs, i am testing KVM on btrfs (host: kernel x86-64 3.5.3), the performance is reasonable.

I have two question on defrag, can someone help me?

1. According to btrfs wiki, defragment a COW file will produce two unrelated files.

    Does it apply to the "autodefrag" mount option?

2. Is there any command for the fragmentation status of a file/dir ? e.g. fragment size, number of fragments.
