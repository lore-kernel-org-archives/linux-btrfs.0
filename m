Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:35934 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaGBQXD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 12:23:03 -0400
Received: by mail-qg0-f45.google.com with SMTP id a108so4848802qge.4
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Jul 2014 09:23:02 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 2 Jul 2014 12:23:01 -0400
Message-ID: <CAMXuLLrQoEB0sfY5P4ZCYn3a8Urk-RC3N_a2AoQrnKG-OeYNuQ@mail.gmail.com>
Subject: Question about debugfs on btrfs
From: Zhe Zhang <zhe.zhang.research@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm trying to use a functionality like "debugfs blocks" or
"dump_extents" on a btrfs partition. The current debugfs user space
program doesn't seem to support it (from e2fsprogs). I cannot find
debugfs in btrfs-progs either. Any advice on how to do it?

Thanks!
Zhe
