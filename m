Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:52086 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbbAGRnS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jan 2015 12:43:18 -0500
Received: from gardel-login.0pointer.net (gardel.0pointer.net [85.214.157.71])
	by gardel.0pointer.net (Postfix) with ESMTP id 712C6E80F5D
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Jan 2015 18:43:16 +0100 (CET)
Date: Wed, 7 Jan 2015 18:43:15 +0100
From: Lennart Poettering <lennart@poettering.net>
To: linux-btrfs@vger.kernel.org
Subject: price to pay for nocow file bit?
Message-ID: <20150107174315.GA21865@gardel-login>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Heya!

Currently, systemd-journald's disk access patterns (appending to the
end of files, then updating a few pointers in the front) result in
awfully fragmented journal files on btrfs, which has a pretty
negative effect on performance when accessing them.

Now, to improve things a bit, I yesterday made a change to journald,
to issue the btrfs defrag ioctl when a journal file is rotated,
i.e. when we know that no further writes will be ever done on the
file. 

However, I wonder now if I should go one step further even, and use
the equivalent of "chattr -C" (i.e. nocow) on all journal files. I am
wondering what price I would precisely have to pay for
that. Judging by this earlier thread:

        http://www.spinics.net/lists/linux-btrfs/msg33134.html

it's mostly about data integrity, which is something I can live with,
given the conservative write patterns of journald, and the fact that
we do our own checksumming and careful data validation. I mean, if
btrfs in this mode provides no worse data integrity semantics than
ext4 I am fully fine with losing this feature for these files.

Hence I am mostly interested in what else is lost if this flag is
turned on by default for all journal files journald creates: 

Does this have any effect on functionality? As I understood snapshots
still work fine for files marked like that, and so do
reflinks. Any drawback functionality-wise? Apparently file compression
support is lost if the bit is set? (which I can live with too, journal
files are internally compressed anyway)

What about performance? Do any operations get substantially slower by
setting this bit? For example, what happens if I take a snapshot of
files with this bit set and then modify the file, does this result in
a full (and hence slow) copy of the file on that occasion? 

I am trying to understand the pros and cons of turning this bit on,
before I can make this change. So far I see one big pro, but I wonder
if there's any major con I should think about?

Thanks,

Lennart
