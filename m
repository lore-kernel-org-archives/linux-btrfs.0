Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:56483 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751368AbdBINwP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Feb 2017 08:52:15 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.88)
        (envelope-from <kilobyte@angband.pl>)
        id 1cboie-0004b9-Jn
        for linux-btrfs@vger.kernel.org; Thu, 09 Feb 2017 14:25:04 +0100
Date: Thu, 9 Feb 2017 14:25:04 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: understanding disk space usage
Message-ID: <20170209132504.ukjehzba5w7k42ow@angband.pl>
References: <CALg=eG_C-Xkw+TTHpNq9y_euza81TPTd+YN10_V=9WSprN0BPw@mail.gmail.com>
 <7912da41-d58a-d57f-47cd-508bc709a761@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7912da41-d58a-d57f-47cd-508bc709a761@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 08, 2017 at 11:48:04AM +0800, Qu Wenruo wrote:
> Just don't believe the vanilla df output for btrfs.
> 
> For btrfs, unlike other fs like ext4/xfs, which allocates chunk dynamically
> and has different metadata/data profile, we can only get a clear view of the
> fs from both chunk level(allocated/unallocated) and extent
> level(total/used).

Actually, df lies on ext4 too.  sysvfs-derived filesystems have statically
allocated inodes, which means that if you try to store small files, at some
point you'll run out of space despite df claiming you have plenty left.


Meow!
-- 
Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
  ./configure --host=zx-spectrum --build=pdp11
