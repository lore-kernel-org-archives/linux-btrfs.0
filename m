Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-03v.sys.comcast.net ([69.252.207.35]:56468 "EHLO
	resqmta-ch2-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932234AbaJVUIw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 16:08:52 -0400
Message-ID: <54480ED0.9070703@pobox.com>
Date: Wed, 22 Oct 2014 13:08:48 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: NOCOW and Swap Files?
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So the documentation is clear that you can't mount a swap file through 
BTRFS (unless you use a loop device).

Why isn't a NOCOW file that has been fully pre-allocated -- as with 
fallocate(1) -- not suitable for swapping?

I found one reference to an unimplemented feature necessary for swap, 
but wouldn't it be reasonable for that feature to exist for NOCOW files? 
(or does this relate to my previous questions about the COW operation 
that happens after a snapshot?)
