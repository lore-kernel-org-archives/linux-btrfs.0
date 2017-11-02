Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:35210 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932383AbdKBQ4d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 12:56:33 -0400
Subject: Re: Multiple btrfs-cleaner threads per volume
To: Martin Raiber <martin@urbackup.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <0102015f7d418aa6-af3c2ae7-27b0-47d0-a4bb-173f55304bb9-000000@eu-west-1.amazonses.com>
 <75dfd17b-3f3a-dc22-e069-d68faa33eb8e@mendix.com>
 <0102015f7d576dad-688908ab-87d9-4715-9626-fb37cfff32e8-000000@eu-west-1.amazonses.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <9f93fa6f-c5af-3513-3e15-e966bd128b34@mendix.com>
Date: Thu, 2 Nov 2017 17:56:30 +0100
MIME-Version: 1.0
In-Reply-To: <0102015f7d576dad-688908ab-87d9-4715-9626-fb37cfff32e8-000000@eu-west-1.amazonses.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/02/2017 04:26 PM, Martin Raiber wrote:
> On 02.11.2017 16:10 Hans van Kranenburg wrote:
>> On 11/02/2017 04:02 PM, Martin Raiber wrote:
>>> snapshot cleanup is a little slow in my case (50TB volume). Would it
>>> help to have multiple btrfs-cleaner threads? The block layer underneath
>>> would have higher throughput with more simultaneous read/write requests.
>> Just curious:
>> * How many subvolumes/snapshots are you removing, and what's the
>> complexity level (like, how many other subvolumes/snapshots reference
>> the same data extents?)
>> * Do you see a lot of cpu usage, or mainly a lot of disk I/O? If it's
>> disk IO, is it mainly random read IO, or is it a lot of write traffic?
>> * What mount options are you running with (from /proc/mounts)?

Can you paste the output from /proc/mounts for your filesystem? The
reason I'm asking is that the nossd/ssd/ssd_spread related mount options
can have a huge impact on subvolume removal performance for very large
filesystems, like your 50TB one.

> It is a single block device, so not a multi-device btrfs, so
> optimizations in that area wouldn't help. It is a UrBackup system with
> about 200 snapshots per client. 20009 snapshots total. UrBackup reflinks
> files between them, but btrfs-cleaner doesn't use much CPU (so it
> doesn't seem like the backref walking is the problem). btrfs-cleaner is
> probably limited mainly by random read/write IO.

Do you have some graphs, or iostat output? The question is what the
biggest part of the IO consists of. Is it on 100% random read IO and not
many writes, or is it 100% utilized because of many MiB/s of writes?

> The device has a cache,
> so parallel accesses would help, as some of them may hit the cache.
> Looking at the code it seems easy enough to do. Question is if there are
> any obvious reasons why this wouldn't work (like some lock etc.).

-- 
Hans van Kranenburg
