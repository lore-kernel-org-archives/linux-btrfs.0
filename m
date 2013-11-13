Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757536Ab3KMQPC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 11:15:02 -0500
Date: Wed, 13 Nov 2013 17:15:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] Add support for object properties
Message-ID: <20131113161500.GC18494@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384263706-25549-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 12, 2013 at 01:41:41PM +0000, Filipe David Borba Manana wrote:
> This is a revised version of the original proposal/work from Alexander Block
> to introduce a generic framework to set properties on btrfs filesystem objects
> (inodes, subvolumes, filesystems, devices).

Thank you very much for working on that. I've added patches 2-5 to the
unstable part of integration branch. More comments later.

david
