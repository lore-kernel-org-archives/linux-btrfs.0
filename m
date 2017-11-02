Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:35208 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932724AbdKBPKh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 11:10:37 -0400
Subject: Re: Multiple btrfs-cleaner threads per volume
To: Martin Raiber <martin@urbackup.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <0102015f7d418aa6-af3c2ae7-27b0-47d0-a4bb-173f55304bb9-000000@eu-west-1.amazonses.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <75dfd17b-3f3a-dc22-e069-d68faa33eb8e@mendix.com>
Date: Thu, 2 Nov 2017 16:10:35 +0100
MIME-Version: 1.0
In-Reply-To: <0102015f7d418aa6-af3c2ae7-27b0-47d0-a4bb-173f55304bb9-000000@eu-west-1.amazonses.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

On 11/02/2017 04:02 PM, Martin Raiber wrote:
> 
> snapshot cleanup is a little slow in my case (50TB volume). Would it
> help to have multiple btrfs-cleaner threads? The block layer underneath
> would have higher throughput with more simultaneous read/write requests.

Just curious:
* How many subvolumes/snapshots are you removing, and what's the
complexity level (like, how many other subvolumes/snapshots reference
the same data extents?)
* Do you see a lot of cpu usage, or mainly a lot of disk I/O? If it's
disk IO, is it mainly random read IO, or is it a lot of write traffic?
* What mount options are you running with (from /proc/mounts)?

-- 
Hans van Kranenburg
