Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33815 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaJOVH6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 17:07:58 -0400
Date: Wed, 15 Oct 2014 23:07:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs-progs: check, fix return value check of
 is_child_root()
Message-ID: <20141015210756.GV22943@suse.cz>
Reply-To: dsterba@suse.cz
References: <1413410320-22954-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413410320-22954-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 15, 2014 at 10:58:40PM +0100, Filipe Manana wrote:
> This affects only the 3.17 release candidates (3.16 and older releases
> don't have this issue).

Thank you, I'm adding this to the branch and tagging rc4.
