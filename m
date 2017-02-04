Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:36425 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbdBDXhW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Feb 2017 18:37:22 -0500
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 096E360016
        for <linux-btrfs@vger.kernel.org>; Sun,  5 Feb 2017 00:37:19 +0100 (CET)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: [RFC] python-btrfs: getting arch dependent ioctl handling right
Message-ID: <be2d182a-6b8e-158f-6653-611c1d1896d7@mendix.com>
Date: Sun, 5 Feb 2017 00:37:18 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

since I'd like to have my python btrfs library work correctly for users
with other systems than amd64, I have been looking at IOCTL number
generation a bit.

I just made something up in a branch, which follows the same way in
which the IOC defines in kernel source are done:

https://github.com/knorrie/python-btrfs/commits/ioctl

The only other hardware than amd64 I have is a raspberry pi, which
doesn't even seem to fall into the category having exceptions to the
defaults...

So, my question is:

1. am I still doing it wrong, or is this going into the right direction?

2. can you please test this branch if you have access to any of 'alpha',
'mips', 'powerpc', 'sparc', 'parisc' which runs a btrfs filesystem and
let me know if this makes it possible to use the library (e.g. run some
examples from the examples/ dir)

3. I also understand that there are difficulties for users who user 32
bit userland with a 64 bit kernel.
 - What is the exact technical reason for this?
 - What's the general opinion about this usecase? (needs to work, or,
"doctor, if I push here it hurts; well, don't push there"...)

Thanks,

-- 
Hans van Kranenburg
