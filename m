Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56293 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2H0MWb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Aug 2012 08:22:31 -0400
Received: by obbuo13 with SMTP id uo13so7886287obb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2012 05:22:31 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Aug 2012 15:22:31 +0300
Message-ID: <CAHf9xva22-RnX-M4_=DpqpYuO-Z4w05c0NU2xpverFMj-XOF5g@mail.gmail.com>
Subject: Question about commit: Btrfs: fix btrfs send for inline items and
 compression, a9fa6848e4aae8d777f7af5e9f2d5b11331252dd
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,
I am looking at your fix in find_extent_clone(), and the code now
looks like this:

if (compressed == BTRFS_COMPRESS_NONE)
	extent_item_pos = logical - found_key.objectid;
else
	extent_item_pos = 0;

extent_item_pos = logical - found_key.objectid;

So the "compressed" flag that you added has no effect, or am I missing
something?

Also, in send_write_or_clone(), the following code rounds up to the
next page size:
	if (type == BTRFS_FILE_EXTENT_INLINE) {
		len = btrfs_file_extent_inline_len(path->nodes[0], ei);
		/*
		 * it is possible the inline item won't cover the whole page,
		 * but there may be items after this page.  Make
		 * sure to send the whole thing
		 */
		len = PAGE_CACHE_ALIGN(len);

Why it is ok to attempt to read-and-send more data than
btrfs_file_extent_inline_len() indicates? I assume this code is
intended to handle "hole between the end of the inline item and the
start of the full extent", in which case it will read-and-send zeros
up to the start of the next extent. But why it is bad just to use the
original "len"?

Thanks,
Alex.
