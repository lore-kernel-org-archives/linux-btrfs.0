Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:42637 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbaJNWZl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 18:25:41 -0400
Message-ID: <543DA2E3.3070503@pobox.com>
Date: Tue, 14 Oct 2014 15:25:39 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Wishlist Item :: One Subvol in Multiple Places
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got no idea if this is possible given the current storage layout, 
but it would be Really Nice™ if there were a way to have a single 
subvolume exist in more than one place in hirearchy. I know this can be 
faked via mount tricks (bind or use of subvol=), but having it be a real 
thing would be preferable.

For example, if I have two or more distributions on a computer or want 
to switch between 32bit and 64bit environments frequently, but I want to 
use the same /home (which is its own subvolume anyway) it would be nice 
if the native layout could be permuted such that /__System_32/home and 
/__System_64/home were the actual same subvolume.

The mechanism, were it possible, would be something like "btrfs 
subvolume link /existing/path /new/path" (or "bind" instead of "link")

I've got no idea if the directory structure would allow for this, but if 
it would it would simplify several things (for me anyway) if the file 
system layout represented the runtime layout.
