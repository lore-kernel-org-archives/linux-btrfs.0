Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41030 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaESBM3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 May 2014 21:12:29 -0400
Date: Sun, 18 May 2014 18:07:05 -0700
From: Marc MERLIN <marc@merlins.org>
To: Scott Middleton <scott@assuretek.com.au>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: send/receive and bedup
Message-ID: <20140519010705.GI10566@merlins.org>
References: <CAPm-YUXRNPhrq+xoJt-S3NvVgg+NOQHB7wj1fjf+XAKs+yUJOg@mail.gmail.com>
 <pan$43445$a1ed5a9d$d03f1b1$41238e2b@cox.net>
 <CAPm-YUWryMcGFop+miu+dnMBac6gf-mdJCx07XHPxdr66h3Big@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPm-YUWryMcGFop+miu+dnMBac6gf-mdJCx07XHPxdr66h3Big@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 14, 2014 at 11:36:03PM +0800, Scott Middleton wrote:
> I read so much about BtrFS that I mistaked Bedup with Duperemove.
> Duperemove is actually what I am testing.

I'm currently using programs that find files that are the same, and
hardlink them together:
http://marc.merlins.org/perso/linux/post_2012-05-01_Handy-tip-to-save-on-inodes-and-disk-space_-finddupes_-fdupes_-and-hardlink_py.html

hardlink.py actually seems to be the faster (memory and CPU) one event
though it's in python.
I can get others to run out of RAM on my 8GB server easily :(

Bedup should be better, but last I tried I couldn't get it to work.
It's been updated since then, I just haven't had the chance to try it
again since then.

Please post what you find out, or if you have a hardlink maker that's
better than the ones I found :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
