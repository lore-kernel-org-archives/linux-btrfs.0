Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbbF3QSc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 12:18:32 -0400
Date: Tue, 30 Jun 2015 18:18:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add autodefrag inode flag
Message-ID: <20150630161830.GI726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <49b5df0f2a140a18386d794447aae87e165e6559.1434679740.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49b5df0f2a140a18386d794447aae87e165e6559.1434679740.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 18, 2015 at 07:10:47PM -0700, Omar Sandoval wrote:
> In some cases, we may not want to enable automatic defragmentation for
> the whole filesystem with the "autodefrag" mount option but we still
> want to defragment specific files or directories. Add an inode flag
> which allows us to do specify that.

While I think all sorts of inode flags can be useful, the autodefrag is
a good example, please note that you're touching a public interface
header

>  include/uapi/linux/fs.h |  1 +

so this should be discussed at fsdevel.
