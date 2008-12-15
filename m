From: Chris Mason <chris.mason@oracle.com>
Subject: Re: PROBLEM: oops when running fsstress against compressed btrfs
 filesystem
Date: Mon, 15 Dec 2008 13:43:06 -0500
Message-ID: <1229366586.16295.2.camel@think.oraclecorp.com>
References: <493860B8.4040309@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Eric Whitney <eric.whitney@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <493860B8.4040309@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-12-04 at 17:59 -0500, Eric Whitney wrote:
> Chris:
> 
> I'm consistently getting oopses when running fsstress against both 
> single and multiple device compressed btrfs filesystems using kernels 
> built from the current btrfs-unstable.
> 
> In this report, I'm describing an incident with a single device 
> filesystem.  Once the oops occurs, all I/O appears to stop though iowait 
> is still reported, and fsstress does not make apparent forward progress. 
>   The system otherwise remains responsive.
> 
> The system is a dual socket, quad core Intel machine with an attached 
> hardware RAID controller.  The latter supplies a six disk RAID0 volume 
> used for the filesystem.
> 
> Particulars follow - please let me know if you'd like more information, etc.

Ok, this was a bug dealing with writing files that had been truncated
with dirty pages in them.

It should be fixed in the latest git trees.

-chris


