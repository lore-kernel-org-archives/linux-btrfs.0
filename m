From: Fabian Zeindl <fabian.zeindl@gmail.com>
Subject: Re: Why does Btrfs allow raid1 with mismatched drives? Also: How to look behind the curtain
Date: Thu, 5 Jan 2012 10:43:45 +0100
Message-ID: <E08D606D-C261-4049-A7C5-6F67E0785E60@gmail.com>
References: <4D48BA4B-AB66-46A2-8E79-050B798C9A3E@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D48BA4B-AB66-46A2-8E79-050B798C9A3E@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Jan 5, 2012, at 10:21 , Fabian Zeindl wrote:
> it creates the fs, apparently with the size of the larger disk, no matter in which order i supply the disk-arguments.
> How can this be correct?

Edit: wrong observation here. The fs is created with the sum of the sizes of the two disks, though btrfs fi df shows RAID1 for metadata, system and data.

Fabian Zeindl

