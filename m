Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab3DPN2h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 09:28:37 -0400
Date: Tue, 16 Apr 2013 15:28:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Vincent <vincent.stehle@laposte.net>
Cc: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix reada debug code compilation
Message-ID: <20130416132834.GM18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366100125-13043-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366100125-13043-1-git-send-email-vincent.stehle@laposte.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 16, 2013 at 10:15:25AM +0200, Vincent wrote:
> This fixes the following errors:
> 
>   fs/btrfs/reada.c: In function ‘btrfs_reada_wait’:
>   fs/btrfs/reada.c:958:42: error: invalid operands to binary < (have ‘atomic_t’ and ‘int’)
>   fs/btrfs/reada.c:961:41: error: invalid operands to binary < (have ‘atomic_t’ and ‘int’)
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Chris Mason <chris.mason@fusionio.com>
> Cc: linux-btrfs@vger.kernel.org

Reviewed-by: David Sterba <dsterba@suse.cz>
