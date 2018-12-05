Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0F3C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 13:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2A292084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 13:57:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2A292084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=angband.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbeLEN5S (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 08:57:18 -0500
Received: from tartarus.angband.pl ([54.37.238.230]:33172 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbeLEN5S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Dec 2018 08:57:18 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1gUXfv-0002rm-9D; Wed, 05 Dec 2018 14:57:15 +0100
Date:   Wed, 5 Dec 2018 14:57:15 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/10] btrfs: Support for DAX devices
Message-ID: <20181205135715.glozremrekz2kesx@angband.pl>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181205122835.19290-1-rgoldwyn@suse.de>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 05, 2018 at 06:28:25AM -0600, Goldwyn Rodrigues wrote:
> This is a support for DAX in btrfs.

Yay!

> I understand there have been previous attempts at it.  However, I wanted
> to make sure copy-on-write (COW) works on dax as well.

btrfs' usual use of CoW and DAX are thoroughly in conflict.

The very point of DAX is to have writes not go through the kernel, you
mmap the file then do all writes right to the pmem, flushing when needed
(without hitting the kernel) and having the processor+memory persist what
you wrote.

CoW via page faults are fine -- pmem is closer to memory than disk, and this
means the kernel will ask the filesystem for an extent to place the new page
in, copy the contents and let the process play with it.  But real btrfs CoW
would mean we'd need to page fault on ᴇᴠᴇʀʏ ꜱɪɴɢʟᴇ ᴡʀɪᴛᴇ.

Delaying CoW until the next commit doesn't help -- you'd need to store the
dirty page in DRAM then write it, which goes against the whole concept of
DAX.

Only way I see would be to CoW once then pretend the page is nodatacow until
the next commit, when we checksum it, add to the metadata trees, and mark
for CoWing on the next write.  Lots of complexity, and you still need to
copy the whole thing every commit (so no gain).

Ie, we're in nodatacow land.  CoW for metadata is fine.

> Before I present this to the FS folks I wanted to run this through the
> btrfs. Even though I wish, I cannot get it correct the first time
> around :/.. Here are some questions for which I need suggestions:
> 
> Questions:
> 1. I have been unable to do checksumming for DAX devices. While
> checksumming can be done for reads and writes, it is a problem when mmap
> is involved because btrfs kernel module does not get back control after
> an mmap() writes. Any ideas are appreciated, or we would have to set
> nodatasum when dax is enabled.

Per the above, it sounds like nodatacow (ie, "cow once") would be needed.

> 2. Currently, a user can continue writing on "old" extents of an mmaped file
> after a snapshot has been created. How can we enforce writes to be directed
> to new extents after snapshots have been created? Do we keep a list of
> all mmap()s, and re-mmap them after a snapshot?

Same as for any other memory that's shared: when a new instance of sharing
is added (a snapshot/reflink in our case), you deny writes, causing a page
fault on the next attempt.  "pmem" is named "ᴘersistent ᴍᴇᴍory" for a
reason...

> Tested by creating a pmem device in RAM with "memmap=2G!4G" kernel
> command line parameter.

Might be more useful to use a bigger piece of the "disk" than 2G, it's not
in the danger area though.

Also note that it's utterly pointless to use any RAID modes; multi-dev
single is fine, DUP counts as RAID here.
* RAID0 is already done better in hardware (interleave)
* RAID1 would require hardware support, replication isn't easy
* RAID5/6 

What would make sense, is disabling dax for any files that are not marked as
nodatacow.  This way, unrelated files can still use checksums or
compression, while only files meant as a pmempool or otherwise by a
pmem-aware program would have dax writes (you can still give read-only pages
that CoW to DRAM).  This way we can have write dax for only a subset of
files, and full set of btrfs features for the rest.  Write dax is dangerous
for programs that have no specific support: the vast majority of
database-like programs rely on page-level atomicity while pmem gives you
cacheline/word atomicity only; torn writes mean data loss.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ Ivan was a worldly man: born in St. Petersburg, raised in
⢿⡄⠘⠷⠚⠋⠀ Petrograd, lived most of his life in Leningrad, then returned
⠈⠳⣄⠀⠀⠀⠀ to the city of his birth to die.
