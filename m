Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab3AWQfx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 11:35:53 -0500
Date: Wed, 23 Jan 2013 17:35:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Nageswara R Sastry <nasastry@in.ibm.com>
Subject: Re: [PATCH 01/13] btrfs-progs: btrfs-image.c: Added NULL pointer
 check.
Message-ID: <20130123163550.GM28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
 <1358715858-4469-2-git-send-email-gene@czarc.net>
 <20130121155630.GI19967@twin.jikos.cz>
 <50FECD89.9050101@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50FECD89.9050101@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 22, 2013 at 12:34:01PM -0500, Gene Czarcinski wrote:
> I missed this better fix because I only started looking for outstanding
> patches starting in June/July 2012.

No problem, there are multuple patches for some longstanging bugs, or
several versions of patch series. This is something we need to be able
to deal with anyway.

david
