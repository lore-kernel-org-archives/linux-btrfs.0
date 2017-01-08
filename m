Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:35986
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754196AbdAHRFl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 8 Jan 2017 12:05:41 -0500
Received: from kiara-mail-exchange.vpn.wellbehavedsoftware.com (kiara-mail-exchange.vpn.wellbehavedsoftware.com [10.109.164.135])
        by mail-hub.vpn.wellbehavedsoftware.com (Postfix) with ESMTP id 3FD275B5730
        for <linux-btrfs@vger.kernel.org>; Sun,  8 Jan 2017 16:56:29 +0000 (UTC)
Received: from [10.109.134.101] (81.184.239.202.dyn.user.ono.com [81.184.239.202])
        by kiara-mail-exchange.vpn.wellbehavedsoftware.com (Postfix) with ESMTPSA id 720323C2A8
        for <linux-btrfs@vger.kernel.org>; Sun,  8 Jan 2017 16:57:08 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: James Pharaoh <james@pharaoh.uk>
Subject: Announcing btrfs-dedupe 1.1.0
Message-ID: <b81e1e04-394b-06a8-d4cb-acfe436a8423@pharaoh.uk>
Date: Sun, 8 Jan 2017 17:57:02 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I'm pleased to announce a new version of my btrfs-dedupe tool, written 
in rust, available here:

http://btrfs-dedupe.com/

Binary packages built on ubuntu (probably will work elsewhere, but 
haven't tried this), are available at:

https://dist.wellbehavedsoftware.com/btrfs-dedupe/

This version is considered ready for production use. It maintains a 
compressed database of the filesystem state, and it tracks file 
metadata, hashes file contents, and the extent-map contents, in order to 
work out what needs to be deduplicated.

This is a whole-file deduplication tool, similar to bedup, but since it 
is written in Rust, and designed to work with the dedupe ioctl, I think 
it's more suitable for production use.

As normal for open source, this comes without any warranty etc, but the 
only updates are performed via the defragment and deduplication ioctls, 
and so assuming they work correctly then this should not cause any 
corruption.

Please feel free to contact me with any questions/problems.
