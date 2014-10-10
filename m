Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:39843 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751950AbaJJOhq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 10:37:46 -0400
Received: from cablepool1-225.stoweaccess.com ([199.188.178.225]:64041 helo=[192.168.2.7])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XcbKD-000ZPi-Rf
	for linux-btrfs@vger.kernel.org; Fri, 10 Oct 2014 08:37:45 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: What is the vision for btrfs fs repair?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5437BAB2.1040605@shiftmail.org>
Date: Fri, 10 Oct 2014 10:37:44 -0400
Message-Id: <93B9D2BD-1F0F-4C94-899F-16A3A2A0D57E@colorremedies.com>
References: <54358C77.2070808@redhat.com> <9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com> <5437BAB2.1040605@shiftmail.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 10, 2014, at 6:53 AM, Bob Marley <bobmarley@shiftmail.org> wrote:

> On 10/10/2014 03:58, Chris Murphy wrote:
>> 
>>> * mount -o recovery
>>> 	"Enable autorecovery attempts if a bad tree root is found at mount time."
>> I'm confused why it's not the default yet. Maybe it's continuing to evolve at a pace that suggests something could sneak in that makes things worse? It is almost an oxymoron in that I'm manually enabling an autorecovery
>> 
>> If true, maybe the closest indication we'd get of btrfs stablity is the default enabling of autorecovery.
> 
> No way!
> I wouldn't want a default like that.
> 
> If you think at distributed transactions: suppose a sync was issued on both sides of a distributed transaction, then power was lost on one side, than btrfs had corruption. When I remount it, definitely the worst thing that can happen is that it auto-rolls-back to a previous known-good state.

For a general purpose file system, losing 30 seconds (or less) of questionably committed data, likely corrupt, is a file system that won't mount without user intervention, which requires a secret decoder ring to get it to mount at all. And may require the use of specialized tools to retrieve that data in any case.

The fail safe behavior is to treat the known good tree root as the default tree root, and bypass the bad tree root if it cannot be repaired, so that the volume can be mounted with default mount options (i.e. the ones in fstab). Otherwise it's a filesystem that isn't well suited for general purpose use as rootfs let alone for boot.

Chris Murphy

