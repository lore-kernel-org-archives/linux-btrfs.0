Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab3H3O7I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 10:59:08 -0400
Date: Fri, 30 Aug 2013 16:59:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4] Btrfs: optimize key searches in btrfs_search_slot
Message-ID: <20130830145903.GL23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1377780253-17826-1-git-send-email-fdmanana@gmail.com>
 <1377804111-15247-1-git-send-email-fdmanana@gmail.com>
 <20130830141435.GK23113@twin.jikos.cz>
 <CAL3q7H4s4OrCkgws8Q4qZXezk-_WGGucc3C84Ud3Xy5d0zFgKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4s4OrCkgws8Q4qZXezk-_WGGucc3C84Ud3Xy5d0zFgKQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 30, 2013 at 03:47:21PM +0100, Filipe David Manana wrote:
> Sure.
> They're actually better now :)

Thanks. The numbers changed in both samples, but the relative difference
is still 2x improvement in this particular test.

david
