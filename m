Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37239 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbbFZOqV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jun 2015 10:46:21 -0400
Date: Fri, 26 Jun 2015 16:46:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: alias btrfs device delete to btrfs
 device remove
Message-ID: <20150626144620.GY726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1435161735.git.osandov@fb.com>
 <4987361b608f2ff84d7c525afe859e5675fdfe85.1435161735.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4987361b608f2ff84d7c525afe859e5675fdfe85.1435161735.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 24, 2015 at 09:09:17AM -0700, Omar Sandoval wrote:
> There's an awkward asymmetry between btrfs device add and btrfs device
> delete. Resolve this by aliasing delete to remove.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Applied, thanks.
