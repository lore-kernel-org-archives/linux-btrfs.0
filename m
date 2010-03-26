From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs subvol find-modified
Date: Fri, 26 Mar 2010 15:36:42 -0400
Message-ID: <20100326193642.GC13680@think>
References: <20100326111807.24dcc2f0@simplux>
 <20100326132219.GF16453@think>
 <20100326195147.146db06e@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100326195147.146db06e@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 26, 2010 at 07:51:47PM +0100, Dipl.-Ing. Michael Niederle wrote:
> I have added a command
> 
> btrfs subvolume find-modified <path> <last_gen>
> 	List the recently modified files and directories in a filesystem.
> 
> It's similar to find-new with the following differences:

Ok, I'd suggest two changes.  Add an optional timestamp field to filter
files that have changed since a given timestamp.

Also make it take -e that prints the extents.

-chris
