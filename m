Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab3CLRai (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:30:38 -0400
Date: Tue, 12 Mar 2013 18:30:35 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4 V2] btrfs-progs: rework get_fs_info to remove side
 effects
Message-ID: <20130312173035.GP7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1363043581-15812-1-git-send-email-sandeen@redhat.com>
 <1363043581-15812-5-git-send-email-sandeen@redhat.com>
 <513EAC64.7020706@redhat.com>
 <20130312164027.GN7229@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130312164027.GN7229@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 12, 2013 at 05:40:27PM +0100, David Sterba wrote:
> I don't know yet if this happens without this changes, will check next.

Happens as well, not a bug in your patches.

david
