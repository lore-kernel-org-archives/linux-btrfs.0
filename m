From: Paul P Komkoff Jr <i@stingr.net>
Subject: Re: BTRFS Performance page
Date: Wed, 22 Oct 2008 23:25:28 +0400
Message-ID: <20081022192528.GB19187@stingr.net>
References: <48FE5593.2080209@austin.ibm.com> <48FF4028.5080109@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-btrfs@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF4028.5080109@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Replying to Steven Pratt:
> Steven Pratt wrote:
> RAID data is now uploaded.  The config used is 136 15k rpm fiber disks  
> in 8 arrays all striped together with DM.  These results are not as  
> favorable to BTRFS, as there seem to be some major issues with random  
> write and mail server workloads.

Why don't use btrfs' own RAID capabilities instead?
Honestly, I will never ever use md as soon as I'll get btrfs working
:)

> http://btrfs.boxacle.net/repository/raid/Initial-compare/Initial-Compare-RAID0.html

-- 
Paul P 'Stingray' Komkoff Jr // http://stingr.net/key <- my pgp key
 This message represents the official view of the voices in my head
