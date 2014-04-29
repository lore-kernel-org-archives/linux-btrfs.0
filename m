Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36110 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404AbaD2RdZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 13:33:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WfBuF-0002Z0-QC
	for linux-btrfs@vger.kernel.org; Tue, 29 Apr 2014 19:33:23 +0200
Received: from p5b0040d8.dip0.t-ipconnect.de ([91.0.64.216])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 19:33:23 +0200
Received: from holger.hoffstaette by p5b0040d8.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 19:33:23 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH 00/14] Enhanced df - followup
Date: Tue, 29 Apr 2014 17:33:09 +0000 (UTC)
Message-ID: <pan.2014.04.29.17.33.09@googlemail.com>
References: <cover.1398786620.git.dsterba@suse.cz>
	<pan$274e8$4b1540e1$e4bc4fe0$2126c4cf@cox.net>
	<20140429171749.GI12281@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 29 Apr 2014 10:17:49 -0700, Marc MERLIN wrote:

> On Tue, Apr 29, 2014 at 05:10:31PM +0000, Duncan wrote:
>> David Sterba posted on Tue, 29 Apr 2014 17:56:47 +0200 as excerpted:
>> 
>> > Changes:
>> > * btrfs filesystem disk_usage - renamed to usage
>> 
>> Hopefully this isn't rehashing an old discussion, but...
>> 
>> Simpler is good, and getting rid of the _ is good, but...
> (...) 
>> Given that confusion, I'd suggest either simply making it du, or making 
>> it "device_usage" but with "du" a documented alias printing exactly the 
>> same output, thus giving folks an easy way to avoid the _.
> 
> It's also fine to just use disk-usage instead of disk_usage.

I think the point was to have the same term for both filesystem and
device categories, which IMHO makes a lot of sense and is less
to remember. Categorical polymorphism: it's a good thing. :)

-h

