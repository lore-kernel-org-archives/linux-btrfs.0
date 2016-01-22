Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619AbcAVOAw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jan 2016 09:00:52 -0500
Date: Fri, 22 Jan 2016 15:00:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix error number in send.c
Message-ID: <20160122140043.GS4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201601220013.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201601220013.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 22, 2016 at 09:13:25AM +0900, Tsutomu Itoh wrote:
> ENOTSUPP should not be returned to the user program.
>  (cf. include/linux/errno.h)
> Therefore, EOPNOTSUPP is used instead of ENOTSUPP.  

I'm not sure that EOPNOTSUPP is the right error code here. I'd rather
make it EINVAL, the bug we're talking about is a new type of inode
outside of the S_IFMT bits. "not supported" would mean we don't support
it but we could in theory.
