Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:45881 "EHLO
        emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936834AbdKPVLS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 16:11:18 -0500
Date: Thu, 16 Nov 2017 23:05:34 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Zdenek Kabelac <zkabelac@redhat.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
Message-ID: <20171116210534.GK20756@reaktio.net>
References: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
 <7ed134fc-1616-a1ab-6701-a917af0522da@suse.com>
 <5357fd4a-51b1-ebfb-27de-4d022d9749c0@gmx.com>
 <4df8d248-5def-9d29-89eb-7d9b977f089e@suse.com>
 <354402cd-587d-72d8-aaa1-87a1b5c9f03c@gmx.com>
 <6e0f8a37-c3f8-61f0-d51d-01b72c3c65b7@redhat.com>
 <189cda7b-e3ee-4379-c7f2-57efd759b78a@gmx.com>
 <9b81b628-d10b-b62e-74f7-86c8ba2f939b@redhat.com>
 <3ba90cc2-30bb-2867-94fa-895def5f2826@gmx.com>
 <391774c5-81f8-cdda-3dbe-4d3d1c2fa3d7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <391774c5-81f8-cdda-3dbe-4d3d1c2fa3d7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 16, 2017 at 11:47:45AM -0500, Austin S. Hemmelgarn wrote:
> >
> >At least btrfs can take the advantage of the simplicity of separate layers.
> >
> >And other filesystem can get a little higher chance to recover its
> >metadata if built on dm-raid.
> Again, just put dm-integrity below dm-raid.  The other filesystems primarily
> have metadata checksums to catch data corruption, not repair it, and I
> severely doubt that you will manage to convince developers to add support in
> their filesystem (especially XFS) because:
> 1. It's a layering violation (yes, I know BTRFS is too, but that's a bit
> less of an issue because it's a completely self-contained layering
> violation, while this isn't).
> 2. There's no precedent in hardware (I challenge you to find a block device
> that lets you respond to a read completing with 'Hey, this data is bogus,
> give me the real data!').
>

Isn't this what T10 DIF/DIX (Data Integrity Fields / Data Integrity Extenstions) allows.. using checksums all the way from userspace applications to the disks in the storage backend, with checksum verification at all points in between? 

Does require compatible hardware/firmware/kernel/drivers/apps though.. so not really a generic solution.


-- Pasi

> 3. You can get the same net effect with a higher guarantee of security using
> dm-integrity.
> >
> >Thanks,
> >Qu
> >
> >>
> >>You are also possibly missing feature of dm-interity - it's not just
> >>giving you 'checksum' - it also makes you sure - device has proper
> >>content - you can't just 'replace block' even with proper checksum for a
> >>block somewhere in the middle of you device... and when joined with
> >>crypto - it makes it way more secure...
> >>
> >>Regards
> >>
> >>Zdenek
> >
> 
