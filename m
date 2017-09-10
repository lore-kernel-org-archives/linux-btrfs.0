Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48607 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbdIJNOu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 09:14:50 -0400
Date: Sun, 10 Sep 2017 06:14:37 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Message-ID: <20170910131437.y2wxt65ps7go42av@merlins.org>
References: <20170903143142.7thdjvkmkdekrzc5@merlins.org>
 <1E7DEC47-01A8-4F50-B266-FA4949090687@fb.com>
 <20170903144237.svgnaclwmcfdfikt@merlins.org>
 <AD68E364-AF7F-49AA-8376-49E0C7C92998@fb.com>
 <20170903202036.b7j6fcknfiisrnsl@merlins.org>
 <D509EEE0-1430-40C2-8AD4-117729CFADDD@fb.com>
 <20170909183918.guot5vuphgabevxi@merlins.org>
 <63F04FB0-47AD-4732-ACD6-B493C51F9ED4@fb.com>
 <20170910023658.4y7u77tku3c6wj2t@merlins.org>
 <5E342E49-3C3A-4A77-A2CB-46508684AD8D@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5E342E49-3C3A-4A77-A2CB-46508684AD8D@fb.com>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 10, 2017 at 03:12:16AM +0000, Josef Bacik wrote:
> Ok mount -o clear_cache, umount and run fsck again just to make sure.  Then if it comes out clean mount with ref_verify again and wait for it to blow up again.  Thanks,
 
Ok, just did the 2nd fsck, came back clean after mount -o clear_cache

I'll re-trigger the exact same bug and repeat the whole cycle then.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
