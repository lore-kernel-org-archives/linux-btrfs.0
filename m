Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57683 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752217AbdLLUOj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 15:14:39 -0500
Date: Tue, 12 Dec 2017 21:12:37 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org, anand.jain@oracle.com
Subject: Re: [PATCH v3 0/4] btrfs: cleanup mount path
Message-ID: <20171212201237.GA3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4786f7cc-adc7-1b99-5abf-d068acee56c2@jp.fujitsu.com>
 <20171016151538.GV3521@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171016151538.GV3521@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 16, 2017 at 05:15:38PM +0200, David Sterba wrote:
> On Mon, Sep 25, 2017 at 04:26:30PM +0900, Misono, Tomohiro wrote:
> > Summary:
> > Cleanup mount path by avoiding calling btrfs_mount() twice.
> > No functional change. See below for longer explanation.
> > 
> > Changelog:
> > v3:
> >   Reorganized patches again into four and added comments to the source.
> >   Each patch can be applied and compiled while maintaining functionality.
> >   The first one is the preparation and the second one is the main part.
> >   The last two are small cleanups.
> 
> I'm conditionally adding this series to for-next for testing.

No problems while this patch has been in for-next, so I'm going to add
that to 4.16 queue. Please update the patchset according to my comments.
Also please review if there's anything relevant for th MS_* and SB_*
rename that happened in 4.15 (1751e8a6cb935). Thanks.
