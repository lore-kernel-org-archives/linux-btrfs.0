Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:45731 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751282AbaAXQRW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 11:17:22 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Confirmation on how btrfs works with RAID and single.
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140124145205.GS6498@twin.jikos.cz>
Date: Fri, 24 Jan 2014 09:17:16 -0700
Cc: Calvin Walton <mailing-lists@kepstin.ca>,
        "G. Michael Carter" <mikey@carterfamily.ca>,
        linux-btrfs@vger.kernel.org
Message-Id: <F956453E-9FB3-4E4E-A128-048E2671AB21@colorremedies.com>
References: <CANjusZdjBTzreOTc3xvNeiu-LOBzbO2kLCOmjn=m19B-76m67w@mail.gmail.com> <1390236695.1869.3.camel@sasami.ottawa.blindsidenetworks.com> <20140124145205.GS6498@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 24, 2014, at 7:52 AM, David Sterba <dsterba@suse.cz> wrote:
> 
> The 'fill one device first" is addressed by
> "Btrfs: Add linear chunk allocation support"
> http://www.spinics.net/lists/linux-btrfs/msg29616.html


What about something like XFS's AGs? Instead of writing a single stream of files to just one disk until full, then going to the 2nd disk, then 3rd, etc. Why not write full files to all disks at the same time? That means file writes are always at single disk speed, but it means files can be written in parallel. For sequential writes it would be almost as fast as raid0 but without the ensuing data loss.


Chris Murphy

