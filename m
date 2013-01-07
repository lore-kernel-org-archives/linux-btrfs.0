Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35301 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab3AGLKm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 06:10:42 -0500
Date: Mon, 7 Jan 2013 12:10:37 +0100
From: David Sterba <dave@jikos.cz>
To: Tom Gundersen <teg@jklm.no>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] oops in linux-3.8-rc2
Message-ID: <20130107111037.GB12992@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAG-2HqV_pHerHwVVCPhnbUbKwVrA9yyd8GOWdcgNtiv92F5BEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG-2HqV_pHerHwVVCPhnbUbKwVrA9yyd8GOWdcgNtiv92F5BEA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, Jan 07, 2013 at 01:51:21AM +0100, Tom Gundersen wrote:
> I ran into a bug today with 3.8-rc2 [0], following an "make
> modules_install && make install" of the kernel.
> 
> I have been using the same kernel without problems for some days, the
> only change immediately before the oops was that I switched from plain
> partitions to using multi-device and subvolumes.
> 
> [0]: <https://plus.google.com/114015603831160344127/posts/fzEYnF64NkZ>

BUG at mm/page-writeback.c:2164

2160 int clear_page_dirty_for_io(struct page *page)
2161 {
2162         struct address_space *mapping = page_mapping(page);
2163
2164         BUG_ON(!PageLocked(page));

btrfs on the stack is only __btrfs_buffered_write +
btrfs_file_aio_write, ie. just a buffered write, originating from
pwrite64.

The bug_on condition is clear, the question is why the page is not
locked.


david
