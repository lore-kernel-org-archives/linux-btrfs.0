From: Chris Mason <chris.mason@oracle.com>
Subject: Re: More performance results
Date: Mon, 02 Feb 2009 11:00:23 -0500
Message-ID: <1233590423.18113.25.camel@think.oraclecorp.com>
References: <49871813.8090309@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49871813.8090309@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-02-02 at 09:58 -0600, Steven Pratt wrote:
> Finally cleared out a backlog of results to upload.  Main performance 
> page is updated with all the links.  (http://btrfs.boxacle.net/)  Most 
> recent results are on 2.6.29-rc2. As usual see analysis directory of 
> results for oprofile, including call graphs.
> 
> Single disk results are not too bad.  Raid still falls apart on any 
> write heavy workload.

Thanks Steve, was the mainline btrfs used for this?  I'm working on the
write heavy problems this week.

-chris


