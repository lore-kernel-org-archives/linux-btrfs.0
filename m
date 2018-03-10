Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39969 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752079AbeCJMEc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Mar 2018 07:04:32 -0500
Subject: Re: Ongoing Btrfs stability issues
To: Alex Adriaanse <alex@oseberg.io>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
 <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
 <595ED26B-1FCD-4693-8E11-8F4CB267D1C7@oseberg.io>
 <0ca621b4-6307-1acf-65b7-4584dd678d80@suse.com>
 <20180302172951.GC30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <DBEFB1DF-D6A7-48D9-AF90-88759597A777@oseberg.io>
 <fc88341d-e440-3007-4b54-e21f74182036@suse.com>
 <D15AA258-5C89-433A-94E3-6C16A0DA4297@oseberg.io>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5a12a7b7-6cf3-82f8-d5fa-2915fc3d6680@suse.com>
Date: Sat, 10 Mar 2018 14:04:30 +0200
MIME-Version: 1.0
In-Reply-To: <D15AA258-5C89-433A-94E3-6C16A0DA4297@oseberg.io>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  9.03.2018 21:05, Alex Adriaanse wrote:
> Am I correct to understand that nodatacow doesn't really avoid CoW when you're using snapshots? In a filesystem that's snapshotted 

Yes, so nodatacow won't interfere with how snapshots operate. For more
information on that topic check the following mailing list thread:
https://www.spinics.net/lists/linux-btrfs/msg62715.html

every 15 minutes, is there a difference between normal CoW and nodatacow
when (in the case of Postgres) you update a small portion of a 1GB file
many times per minute? Do you anticipate us seeing a benefit in
stability and performance if we set nodatacow for the
So regarding this, you can check :
https://btrfs.wiki.kernel.org/index.php/Gotchas#Fragmentation

Essentially every bit of small, random postgres update in the db file
will cause a CoW operation + checksum IO which cause, and I quote, "
thrashing on HDDs and excessive multi-second spikes of CPU load on
systems with an SSD or large amount a RAM."

So for OLTP workloads you definitely want nodatacow enabled, bear in
mind this also disables crc checksumming, but your db engine should
already have such functionality implemented in it.

entire FS while retaining snapshots? Does nodatacow increase the chance
of corruption in a database like Postgres, i.e. are writes still
properly ordered/sync'ed when flushed to disk?

Well most modern DB already implement some sort of a WAL, so the
reliability responsibility is shifted on the db engine.
