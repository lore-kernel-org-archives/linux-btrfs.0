From: Kai Ren <gleemanrk@gmail.com>
Subject: Re:  =?ISO-8859-1?Q?=20=08Understanding?= metadata efficiency of btrfs
Date: Mon, 5 Mar 2012 21:32:23 -0500
Message-ID: <AB9001C8-7385-458B-8714-381C3D3A96F4@gmail.com>
References: <F728B049-9007-4FA6-B75B-0249A472E40C@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <F728B049-9007-4FA6-B75B-0249A472E40C@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Forgot to mention:

Each file is zero byte.

And the available of memory is limited to 512 MB.

Best,

Kai

On Mar 5, 2012, at 9:16 PM, Kai Ren wrote:

> I've run a little wired benchmark on comparing Btrfs v0.19 and XFS:
> 
> There are 2000 directories and each directory contains 1000 files.
> The workload randomly stat a file or chmod a file for 2000000 times.
> And the number of stat and chmod are 50% and 50%.
> 
> I monitor the number of disk read requests
> 
>             #Disk Write Requests,  #Disk Read Requests,  #Disk Write Sectors,  #Disk Read Sectors
> Btrfs       2403520      1571183    29249216  13512248
> XFS         625493        396080    10302718   4932800
> 
> I found the number of write quests of Btrfs is significant larger than XFS.
> I am not quite familiar with how btrfs commits the metadata change into the disks.
> From the website, it is said that btrfs uses COW B-tree which never overwrite previous disk pages.
> I assume that Btrfs also keep an in-memory buffer to keep the metadata changes.
> But it is unclear to me that how often Btrfs will commit these changes and what is the behind mechanism.
> 
> Could anyone please comment on the experiment results and give a brief explanation of Btrfs's metadata committing mechanism?
> 
> Sincerely,
> 
> Kai Ren

