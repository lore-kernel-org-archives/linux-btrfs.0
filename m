Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759560Ab3JOUuW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 16:50:22 -0400
Date: Tue, 15 Oct 2013 22:50:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: regression, can't mount subvol if default subvol is changed
Message-ID: <20131015205019.GO5787@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4D0EBD9B-30A2-44CB-89E2-CD028BECF1C2@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D0EBD9B-30A2-44CB-89E2-CD028BECF1C2@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 15, 2013 at 01:23:44PM -0600, Chris Murphy wrote:
> After changing the default subvolume, I can't mount a nested subvolume
> with a correct relative pathname to the default subvolume; it can only
> be mounted by absolute path or subvolid.

The path to subvol= is always taken as absolute, no matter if the path
starts with / or not.

david
