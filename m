Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:60018
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754307AbcJOOjp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Oct 2016 10:39:45 -0400
Received: from mail-backup-2.vpn.wellbehavedsoftware.com (unknown [10.109.148.5])
        by mail-hub.vpn.wellbehavedsoftware.com (Postfix) with ESMTP id 71D06A0370
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Oct 2016 14:31:42 +0000 (UTC)
Received: from [10.109.134.109] (81.184.239.202.dyn.user.ono.com [81.184.239.202])
        by mail-backup-2.vpn.wellbehavedsoftware.com (Postfix) with ESMTPSA id 000CF8EFB8
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Oct 2016 14:31:41 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: James Pharaoh <james@pharaoh.uk>
Subject: Rust library for BTRFS
Message-ID: <2636de69-cd94-1700-f589-9f0c981bbac2@pharaoh.uk>
Date: Sat, 15 Oct 2016 16:31:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have created a BTRFS library for Rust - very incomplete so far, but 
possibly of interest to someone.

https://gitlab.wellbehavedsoftware.com/well-behaved-software/rust-btrfs

I've basically reimplemented what I find in other tools because, as far 
as I can tell, there is no C library for BTRFS at this point.

The currently supported functions are:

- Deduplication
- File system info
- Space info

James
