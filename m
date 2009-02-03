From: jim owens <jowens@hp.com>
Subject: Re: More performance results
Date: Tue, 03 Feb 2009 09:22:33 -0500
Message-ID: <49885329.6000501@hp.com>
References: <49871813.8090309@austin.ibm.com> <f24d23310902030532w6cad0b6v209951bb24fba388@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Steven Pratt <slpratt@austin.ibm.com>, linux-btrfs@vger.kernel.org
To: debian developer <debiandev@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f24d23310902030532w6cad0b6v209951bb24fba388@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

debian developer wrote:
> On Mon, Feb 2, 2009 at 9:28 PM, Steven Pratt <slpratt@austin.ibm.com> wrote:
>> Finally cleared out a backlog of results to upload.  Main performance page is updated with all the links.  (http://btrfs.boxacle.net/)  Most recent results are on 2.6.29-rc2. As usual see analysis directory of results for oprofile, including call graphs.
>>
>> Single disk results are not too bad.  Raid still falls apart on any write heavy workload.
> 
> Would you please mind explaining how bad the results are and
> how much more this needs to be improved for Btrfs to be perfomance
> wise acceptable?
> 
> I see that Btrfs almost everywhere lacks XFS and others in some cases.

Nobody working on btrfs development is satisfied with
the current performance.  We knew before the merge that
the present code would not be a benchmarking champion.

We are working on improving it.  The more testing of
different configurations and more feedback, the better
we understand what areas need work.

For example, I'm working on really implementing O_DIRECT.
Today O_DIRECT just goes through buffer cache.

"Acceptable performance" will depend on what features are
important to a user.  For example, we expect to use more
CPU than other filesystems with btrfs doing checksumming.

jim
