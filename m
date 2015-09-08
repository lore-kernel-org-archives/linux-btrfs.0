Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346AbbIHL5o (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Sep 2015 07:57:44 -0400
Date: Tue, 8 Sep 2015 13:56:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: makefile: drop u option from ar invocation
Message-ID: <20150908115656.GB8891@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1441407978-23061-1-git-send-email-arnd@arndnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441407978-23061-1-git-send-email-arnd@arndnet.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 05, 2015 at 01:06:18AM +0200, Arnd Hannemann wrote:
> In newer distros (ubuntu 15.10, fedora rawhide) the binutils
> ar uses the new D flag per default to build deterministic
> binaries.
> Without this patch the following warning is issued, when
> building btrfs-progs:
> 
>     [AR]     libbtrfs.a
> /usr/bin/ar: `u' modifier ignored since `D' is the default (see `U')
> 
> For libtrfs.a performance benefit of the u option can be neglected,
> so drop the u option and silence the warning.
> 
> In the future one might want to explicitly add the D option anyway.
> 
> Signed-off-by: Arnd Hannemann <arnd@arndnet.de>

Applied, thanks.
