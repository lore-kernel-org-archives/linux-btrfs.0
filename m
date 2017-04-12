Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54344 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752372AbdDLXFk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Apr 2017 19:05:40 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cyRKO-0000ge-CY
        for linux-btrfs@vger.kernel.org; Thu, 13 Apr 2017 01:05:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v2] btrfs-progs: send-dump: always print a space after
 path
Date: Wed, 12 Apr 2017 23:05:25 +0000 (UTC)
Message-ID: <pan$4dffc$4cc24d99$2c0f0eb0$3d6bddb5@cox.net>
References: <20170411163340.GJ2455@edanaher.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Evan Danaher posted on Tue, 11 Apr 2017 12:33:40 -0400 as excerpted:

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
> ---

I'm not a dev so won't attempt to comment on the patch itself, but it's 
worth noting that according to kernel patch submission guidelines (which 
btrfs-progs use as well) on V2+ patch postings, there should be a short, 
often one-line per version, summary of what changed between versions.  
This helps both reviewers and would-be patch-using admins such as myself 
understand how a patch is evolving, as well as for reviewers preventing 
unnecessary work when re-reviewing a new version of a patch previously 
reviewed in an earlier version.

On patch series this summary is generally found in the 0/N post, while on 
individual patches without a 0/N, it's normally found below the first --- 
delimiter, so as to avoid including the patch history in the final merged 
version comment.

See pretty much any other multi-version posted patch for examples.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

