Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41257 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2FDMjR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 08:39:17 -0400
Received: by yenm10 with SMTP id m10so2932857yen.19
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2012 05:39:16 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 4 Jun 2012 15:39:16 +0300
Message-ID: <CAHf9xvYX+3sjJL3anEQD0TJLbBiSsF4Pu1aBwVjeTofNmxFMpw@mail.gmail.com>
Subject: inquiry on btrfs send/receive
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>, ablock84@googlemail.com,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan, Alex,

I have seen some discussions about btrfs send/receive functionality
being developed by you. I have also been interested in this. I spent
some time coding a prototype doing something like Alex described in
http://www.spinics.net/lists/linux-btrfs/msg16175.html, i.e., walking
over FS tree and pulling those items that have transid/generation
larger than a particular value. I realized though, that there are many
issues with that approach, and also probably there are many issues I
am not aware of. Some of the issues I realized:

# How does one track changes in generic INODE_ITEM properties, like
"mode" or "uid/gid"? Whenever such property gets changed, INODE_ITEM
gets stamped with a new transid, but do we need to compare it with the
previous version on the receive side to realize what has changed?
# File size - is it required, again, to compare vs previous size, to
realize file truncation? (file grow perhaps can be realized via new
EXTENT_DATAs)
# What should be done if INODE_ITEM::flags change (e.g., inode gets
nodatacow/nodatasum flags set). What should be done at receive side?
# How does one track deletion of INODE_ITEMs? Or, deletion and
re-creation of a INODE_ITEM with the same inode number? (I saw that
inode_cache mount option allows to re-use inode numbers, so I think it
can happen.) Does this mean that on receive side, it is required to
compare contents of each directory vs previous version?
# What should be done with INODE_ITEMs like block/char device, FIFO or a socket?
# XATTR_ITEMs: although they have a transid stamp, again, need to
track deletion/re-creation of them. Again by comparing?
# INODE_REFs: these seem most tough to me, because they don't have
transid stamps. How such scenario can be handled: an INODE_ITEM had
two INODE_REFs with names N1 and N2. But now on the send side, both
those INODE_REFs were deleted and INODE_REFs N3 and N4 were created.
Does that mean we need to always compare all INODE_REFs for each
INODE_ITEM, or we perhaps can use DIR_ITEMs/DIR_INDEXs of parent
INODE_ITEM to detect changes in INODE_REFs?

All in all, it looks like the approach of navigating the FS tree and
trying to *understand* specifically which modifications were
performed, is quite error-prone. And I am sure there are modifications
I am not aware about.

I was wondering, what state your work is in? Is it possible to look at
some code or prototype, to understand what approach have you taken, or
perhaps an overall description of the approach?

Jan, I saw that you provided some new code for backref resolving. Can
you give a hint of how is that related to the send/receive
functionality?

Thanks,
Alex.
