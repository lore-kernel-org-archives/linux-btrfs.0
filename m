Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:56291 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751669AbdBFW4J (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 17:56:09 -0500
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id DEF1E9B6E9
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Feb 2017 22:56:04 +0000 (GMT)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id BC8E25FBB3
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Feb 2017 22:56:04 +0000 (GMT)
From: Graham Cobb <g.btrfs@cobb.uk.net>
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
To: linux-btrfs@vger.kernel.org
References: <1485905578.6441.20.camel@gmail.com>
 <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
 <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
 <7ead5d42-9c00-b2df-3fbf-5b8f287760f6@cobb.uk.net>
 <pan$16525$cf7fe24b$7c044b9$74b32f27@cox.net>
 <5c503d69-aaed-680f-de30-75a7323bc753@cobb.uk.net>
 <pan$5f1de$80937cf$9c306858$cafb9e40@cox.net>
 <1b69d1a8-c08b-c9f3-c95b-1d7d71c7d642@cobb.uk.net>
 <20170205130817.57a67173@jupiter.sol.kaishome.de>
Message-ID: <89444bcf-4b37-9055-4fa2-3ba00859debe@cobb.uk.net>
Date: Mon, 6 Feb 2017 22:56:04 +0000
MIME-Version: 1.0
In-Reply-To: <20170205130817.57a67173@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/02/17 12:08, Kai Krakow wrote:
> Wrong. If you tend to not be in control of the permissions below a
> mountpoint, you prevent access to it by restricting permissions on a
> parent directory of the mountpoint. It's that easy and it always has
> been. That is standard practice. While your backup is running, you have
> no control of it - thus use this standard practice!

Sorry, you are missing the point. This isn't about backups, it is about
snapshots.

To the sysadmin who is not a developer and does not know how receive is
actually implemented, send/receive appears to work exactly like taking a
readonly snapshot, but between two different disks. That is the mental
model they have of the process.

Taking a snapshot does not require hiding the target: it either works or
it doesn't, and it cannot be interfered with. The sysadmin's natural
expectation is that send/receive works the same way.

You may say, from your position of knowledge about how it is
implemented, that is an unrealistic expectation but it is a natural and
common expectation. I very firmly believe that 80% of ordinary btrfs
sysadmins would be surprised by this behaviour.

But, in any case, we can all agree that this unexpected behaviour needs
to be documented.
