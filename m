Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab3DXMVU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 08:21:20 -0400
Date: Wed, 24 Apr 2013 14:21:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2 (resend)] btrfs-progs: standardize tool source
 filenames
Message-ID: <20130424122118.GZ16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <517463E4.7040400@redhat.com>
 <5176F5B5.6010008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5176F5B5.6010008@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 23, 2013 at 03:57:25PM -0500, Eric Sandeen wrote:
> vger ate my giant rename-files patch; here's the makefile bit, and
> hopefully the rename-diffs at the end are something that git
> knows how to apply?  TBH I've never tried that before.

Yes it works, eg. the rename from btrsfck.c -> cmds-check.c has been
done that way.
