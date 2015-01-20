Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51373 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbbATRNt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Jan 2015 12:13:49 -0500
Date: Tue, 20 Jan 2015 12:13:48 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Philipp <philipp.andreas@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Snapshot cannot be deleted
Message-ID: <20150120171348.GA24217@thunk.org>
References: <CAKVY-+9cjRKfXFVVEamtNVLaWE1+jc44M4kyrJOOk915v2fxtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKVY-+9cjRKfXFVVEamtNVLaWE1+jc44M4kyrJOOk915v2fxtA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

+linux-btrfs,-linux-ext4

On Tue, Jan 20, 2015 at 01:28:04PM +0100, Andreas Philipp wrote:
> 
> Due to the known (and fixed) bug in kernel 3.17.0 one of my btrfs
> volume suffers from unreadable and - even worse - uneraseable
> snapshots. Whenever such a snapshot is accessed there is "parent
> transid verify failed" in dmesg.
> Is there any way to delete these snapshots?

You sent this to the wrong mailing list, so I'm reforwarding this to
the linux-btrfs list.

Cheers,

						- Ted
