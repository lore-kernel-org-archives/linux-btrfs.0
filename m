Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:36491 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751135AbaAIG1t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 01:27:49 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: REQ: btrfs list <subvols only> option
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <loom.20140109T045506-475@post.gmane.org>
Date: Wed, 8 Jan 2014 23:27:46 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <2DD5D524-F505-4CF7-8639-8D1BD10495F0@colorremedies.com>
References: <loom.20140109T020430-693@post.gmane.org> <38A0596B-F366-453C-ABC2-D4FB25637403@colorremedies.com> <loom.20140109T045506-475@post.gmane.org>
To: Alex <alex@bpmit.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 8, 2014, at 9:06 PM, Alex <alex@bpmit.com> wrote:

> Chris Murphy <lists <at> colorremedies.com> writes:
> 
>> Specify the mount point for the Btrfs file system and it will list all
> subvols on that file system.
>> 
>> Chris Murphy--
> 
> Thank you Chris.
> 
> When I do that on my version of the 3.12 userland:
> # btrfs  sub list / -o
> returns nothing (with no error), which I wasn't quite expecting because
> there *are* other snapshots and subvols below '/'

Not if / is a mounted subvolume that itself contains no subvolumes. / is the OS root, it is not the file system subvol=5 root.


Chris Murphy

