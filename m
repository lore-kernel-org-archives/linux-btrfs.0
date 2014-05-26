Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbaEZPko (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 11:40:44 -0400
Date: Mon, 26 May 2014 17:48:34 +0200
From: David Disseldorp <ddiss@suse.de>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] xfstests: add test for btrfs ioctl clone
 operation
Message-ID: <20140526174834.18fd03df@f163.suse.de>
In-Reply-To: <1400950255-24346-1-git-send-email-fdmanana@gmail.com>
References: <1400817931-32326-2-git-send-email-fdmanana@gmail.com>
	<1400950255-24346-1-git-send-email-fdmanana@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 24 May 2014 17:50:55 +0100, Filipe David Borba Manana wrote:

> This is a test to verify that the btrfs ioctl clone operation is
> able to clone extents of a file to different positions of the file,
> that is, the source and target files are the same. Existing tests
> only cover the case where the source and target files are different.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
> 
> V2: Made the test exercise a more complex code path in the btrfs ioctl clone
>     code. Now we have extents with different sizes and make the cloner process
>     partial extents and split existing extents with smaller ones.
> 
> V3: Add tests to verify that after writing to a cloned extent, the original
>     extent isn't modified, that defragmenting a file with cloned extents
>     doesn't change the file contents and that all the tests have the same
>     exact semantics (as observed by an application/user) regardless of the
>     following options (and any combination): cow/nodatacow/compression.

Looks good.

Reviewed-by: David Disseldorp <ddiss@suse.de>
