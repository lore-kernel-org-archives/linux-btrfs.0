Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60169 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752800AbdJLMcc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 08:32:32 -0400
Date: Thu, 12 Oct 2017 14:30:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Sergei Trofimovich <slyfox@gentoo.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] configure.ac: allow '--with-convert=' to accept
 comma-separated values
Message-ID: <20171012123046.GE3521@suse.cz>
Reply-To: dsterba@suse.cz
References: <20171012120854.28748-1-slyfox@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171012120854.28748-1-slyfox@gentoo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 12, 2017 at 01:08:54PM +0100, Sergei Trofimovich wrote:
> Before the change configure refused to accept it's defaults explicitly:
>     $ ./configure --enable-convert --with-convert=ext2,reiserfs
>     ...
>     configure: error: unknown tokens for --with-convert: ,
> 
> After the change both converters are enabled:
>     $ ./configure --enable-convert --with-convert=ext2,reiserfs
>     ...
>             btrfs-convert:      yes (ext2,reiserfs)
> 
> Cc: linux-btrfs@vger.kernel.org
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>

Applied, thanks.
