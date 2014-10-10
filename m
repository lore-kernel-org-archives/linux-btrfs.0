Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44059 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897AbaJJRxV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 13:53:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XceNT-0007pK-PV
	for linux-btrfs@vger.kernel.org; Fri, 10 Oct 2014 19:53:19 +0200
Received: from 55e9f25a.rev.dansknet.dk ([85.233.242.90])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 19:53:19 +0200
Received: from spam by 55e9f25a.rev.dansknet.dk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 19:53:19 +0200
To: linux-btrfs@vger.kernel.org
From: Bardur Arantsson <spam@scientician.net>
Subject: Re: What is the vision for btrfs fs repair?
Date: Fri, 10 Oct 2014 19:53:08 +0200
Message-ID: <m196e4$eqa$1@ger.gmane.org>
References: <54358C77.2070808@redhat.com> <9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com> <5437BAB2.1040605@shiftmail.org> <93B9D2BD-1F0F-4C94-899F-16A3A2A0D57E@colorremedies.com> <54381ADB.2030002@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <54381ADB.2030002@shiftmail.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-10-10 19:43, Bob Marley wrote:
> On 10/10/2014 16:37, Chris Murphy wrote:
>> The fail safe behavior is to treat the known good tree root as the
>> default tree root, and bypass the bad tree root if it cannot be
>> repaired, so that the volume can be mounted with default mount options
>> (i.e. the ones in fstab). Otherwise it's a filesystem that isn't well
>> suited for general purpose use as rootfs let alone for boot.
>>
> 
> A filesystem which is suited for "general purpose" use is a filesystem
> which honors fsync, and doesn't *ever* auto-roll-back without user
> intervention.
> 

A file system cannot do anything about the *DISKS* not honouring a sync
command. That's what the PP was talking about.



