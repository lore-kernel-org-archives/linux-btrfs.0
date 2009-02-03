From: debian developer <debiandev@gmail.com>
Subject: Re: More performance results
Date: Tue, 3 Feb 2009 19:02:42 +0530
Message-ID: <f24d23310902030532w6cad0b6v209951bb24fba388@mail.gmail.com>
References: <49871813.8090309@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49871813.8090309@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 2, 2009 at 9:28 PM, Steven Pratt <slpratt@austin.ibm.com> wrote:
>
> Finally cleared out a backlog of results to upload.  Main performance page is updated with all the links.  (http://btrfs.boxacle.net/)  Most recent results are on 2.6.29-rc2. As usual see analysis directory of results for oprofile, including call graphs.
>
> Single disk results are not too bad.  Raid still falls apart on any write heavy workload.

Would you please mind explaining how bad the results are and
how much more this needs to be improved for Btrfs to be perfomance
wise acceptable?

I see that Btrfs almost everywhere lacks XFS and others in some cases.

Thanks,
Andev
