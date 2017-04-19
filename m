Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44888 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965500AbdDSRd2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 13:33:28 -0400
Date: Wed, 19 Apr 2017 19:33:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Evan Danaher <github@edanaher.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: send-dump: always print a space after
 path
Message-ID: <20170419173319.GH22319@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170411163340.GJ2455@edanaher.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170411163340.GJ2455@edanaher.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 11, 2017 at 12:33:40PM -0400, Evan Danaher wrote:
> I was shocked to discover that 'btrfs receive --dump' doesn't print a
> space after long filenames, so it runs together into the metadata; for
> example:
> 
> truncate        ./20-00-03/this-name-is-32-characters-longsize=0
> 
> This is a trivial patch to add a single space unconditionally, so the
> result is the following:
> 
> truncate        ./20-00-03/this-name-is-32-characters-long size=0
> 
> I suppose this is technically a breaking change, but it seems unlikely
> to me that anyone would depend on the existing behavior given how
> unfriendly it is.
> 
> Signed-off-by: Evan Danaher <github@edanaher.net>

Applied, thanks.
