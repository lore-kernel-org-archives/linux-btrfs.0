Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbaJ1Okb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 10:40:31 -0400
Date: Tue, 28 Oct 2014 15:40:30 +0100
From: David Sterba <dsterba@suse.cz>
To: neo <cknvme@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] [PATCH]Btrfs-prog: uniform error handling for utils.c
Message-ID: <20141028144030.GA27030@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1413147716-7478-1-git-send-email-cknvme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413147716-7478-1-git-send-email-cknvme@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

without any explanation I can only speculate what's the purpose of this
patch. I can see it hides the basic syscalls to wrappers and prints
messages in case of an error value.

Currently, the error codes are mostly handled and the error messages are
printed as needed, we don't want to see all of them or not exactly at
the time the error happens.

I don't see any reason why the indirection layer is needed, the bare
syscalls are usually enough. More complexity can be hidden to wrappers
like open_file_or_dir.

The code that's shared with kernel should stick to the kernel naming and
generic functions, for that there's kerncompat.h . The userspace code
shares the CodingStyle from kernel, but obviously has to use the
userspace API so not every function starts with btrfs_ prefix etc.

d.
