From: BJ Quinn <bj@placs.net>
Subject: Re: Cloning a Btrfs partition
Date: Thu, 08 Dec 2011 10:07:24 -0600 (CST)
Message-ID: <61f156db-4242-47c4-9efb-a19154675947@mail.placs.net>
References: <4EE0DC86.9080005@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Freddie Cash <fjwcash@gmail.com>, linux-btrfs@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE0DC86.9080005@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

>No, btrfs send is exactly what you need. Using dd is slow because it 
>copies unused blocks, and requires the source fs be unmounted and the 
>destination be an empty partition. rsync is slow because it can't take 
>advantage of the btrfs tree to quickly locate the files (or parts of 
>them) that have changed. A btrfs send would solve all of these issues. 

Well, that depends.  Using dd is slow if you have a large percentage of the drive unused.  In my case, half or more of the drive is in use, and dd is about as efficient as is theoretically possible on the part of the drive that is in use.  You're right that it requires the drive to be unmounted and the destination to be an empty partition, but what I want to use dd for is to catch an empty drive up to being current and afterwards I'll use my rsync script to keep it up to date with the latest snapshots.  Maybe btrfs send will be more efficient, but in my experience with zfs send, dd was 10x faster unless your drive was nearly empty.

At any rate, was someone saying that some work had already started on something like btrfs send?

Or, alternatively, given that dd would be sufficient for my needs, is there any way to change the UUID of a btrfs partition after I've cloned it?

-BJ
