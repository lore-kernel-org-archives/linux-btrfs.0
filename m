Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wendy.routify.me ([192.3.10.38]:42555 "EHLO wendy.routify.me"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbbIQWt2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 18:49:28 -0400
Date: Thu, 17 Sep 2015 18:41:54 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS as image store for KVM?
Message-ID: <20150917224154.GA23636@wheatley.student.rit.edu>
References: <55F88ECC.1040604@menke.ac>
 <pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net>
 <55FAFEB8.6030404@menke.ac>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55FAFEB8.6030404@menke.ac>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 17, 2015 at 07:56:08PM +0200, Gert Menke wrote:
> MD+LVM is very close to what I want, but md has no way to cope with silent
> data corruption. So if I'd want to use a guest filesystem that has no
> checksums either, I'm out of luck.
> I'm honestly a bit confused here - isn't checksumming one of the most
> obvious things to want in a software RAID setup? Is it a feature that might
> appear in the future? Maybe I should talk to the md guys...

MD is emulating hardware RAID. In hardware RAID, you are doing
work at the block level. Block-level RAID has no understanding of the
filesystem(s) running on top of it. Therefore it would have to checksum
groups of blocks, and store those checksums on the physical disks
somewhere, perhaps by keeping some portion of the drive for itself. But
then this is not very efficient, since it is maintaining checksums for
data that may be useless (blocks the FS is not currently using). So then
you might make the RAID filesystem aware...and you now have BTRFS RAID.

Simply put, the block level is probably not an appropriate place for
checksumming to occur. BTRFS can make checksumming work much more
effectively and efficiently by doing it at the filesystem level.

--Sean
