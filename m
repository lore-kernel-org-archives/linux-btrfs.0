Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58120 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261AbaDNM0G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 08:26:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WZfxa-0006S3-1N
	for linux-btrfs@vger.kernel.org; Mon, 14 Apr 2014 14:26:02 +0200
Received: from p5b005a90.dip0.t-ipconnect.de ([91.0.90.144])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 14:26:02 +0200
Received: from holger.hoffstaette by p5b005a90.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Apr 2014 14:26:02 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Subvolumes and isolation
Date: Mon, 14 Apr 2014 12:25:44 +0000 (UTC)
Message-ID: <pan.2014.04.14.12.25.44@googlemail.com>
References: <pan.2014.04.14.10.38.45@googlemail.com>
	<pan$83f14$2d652951$d4438311$791da6ce@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 14 Apr 2014 11:50:19 +0000, Duncan wrote:

> Holger Hoffstätte posted on Mon, 14 Apr 2014 10:38:45 +0000 as excerpted:
> 
>> So I'm happily using subvolumes and snapshots and was wondering about
>> subvolume low-level isolation. Assuming metadata=single, would a corrupt
>> metadata block in one subvolume's directory tree affect any other
>> subvolumes on the same physical partition, or would the fallout from
>> this bad block be contained?
> 
> This isn't an authoritative answer, but AFAIK, chunks are /not/ subvolume-
> dedicated.  In fact, on the wiki, the sysadmin's guide page defines a 
> snapshot as simply a subvolume that shares its data and metadata with 
> some other subvolume, using btrfs' COW capabilities.  Obviously that 
> would be rather difficult if subvolumes get dedicated data and metadata 
> chunks, so...

Sure - I guess I should have stated that differently: I fully expect a
damaged subvolume to potentially have some effect on its snapshots,
and the same for data blocks (since they are single as well).

The situation is simple: I have the usual big backup drive attached to
my server with subvolumes for each individual machine, and snapshots that
are garbage-collected after a configurable amount of time since all machines
are wildly different in terms of size, change rate and backup retention.
Therefore subvolumes seemed the best compromise in terms of isolation &
easy restore while avoding the hassle of separate filesystems, partitions
etc.

Obviously this setup is not particularly resilient to catastrophic events
like complete drive death, but that's OK in my case.

Holger

