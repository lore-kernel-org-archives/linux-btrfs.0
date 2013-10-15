Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933657Ab3JOVsw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 17:48:52 -0400
Date: Tue, 15 Oct 2013 23:48:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: dsterba@suse.cz, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: regression, can't mount subvol if default subvol is changed
Message-ID: <20131015214849.GP5787@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4D0EBD9B-30A2-44CB-89E2-CD028BECF1C2@colorremedies.com>
 <20131015205019.GO5787@twin.jikos.cz>
 <64C31F98-8C69-458F-ADCB-14EE19770C1D@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <64C31F98-8C69-458F-ADCB-14EE19770C1D@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 15, 2013 at 02:58:22PM -0600, Chris Murphy wrote:
> Looks like this changed with the 3.2 kernel " Subvolumes mountable by
> full path", I thought that was in addition to relative rather than a
> total change in behavior. Good to know.

Yes, the pre-3.2 behaviour was limited to subvolumes in the toplevel
subvolume, nested subvols were mountable via subvolrootid, but that was
only a clumsy temporary workaround.

> Is the idea that subvolume set-default only affects mount -o defaults
> behavior and nothing else?

Yes.
