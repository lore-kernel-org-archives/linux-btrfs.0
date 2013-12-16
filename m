Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab3LPOem (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 09:34:42 -0500
Date: Mon, 16 Dec 2013 15:34:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix use of uninitialized err variable
Message-ID: <20131216143440.GE6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1386963574-14467-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1386963574-14467-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 13, 2013 at 07:39:34PM +0000, Filipe David Borba Manana wrote:
> >From the compiler:
> 
> fs/btrfs/file.c: In function ‘prepare_pages.isra.18’:
> fs/btrfs/file.c:1265:6: warning: ‘err’ may be used uninitialized in this function [-Wuninitialized]

My gcc 4.8.1 does not see this warning, nor do I while inspecting the
souces in current next-master.
