From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Updated performance results
Date: Wed, 23 Sep 2009 10:24:42 -0500
Message-ID: <4ABA3DBA.6000607@austin.ibm.com>
References: <4AAAC2B6.8040105@austin.ibm.com> <20090914135130.GE8839@think> <4AAEB89C.3040100@austin.ibm.com> <20090916005225.GG23965@think> <4AB280AD.5080306@hp.com> <4AB28245.2000704@austin.ibm.com> <20090917185220.GA18165@think> <20090917201714.GE18165@think> <20090917204331.GG18165@think> <4AB2B25B.5070706@austin.ibm.com> <20090918201409.GF21798@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Eric Whitney <eric.whitney@hp.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090918201409.GF21798@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Thu, Sep 17, 2009 at 05:04:11PM -0500, Steven Pratt wrote:
>   
>> Chris Mason wrote:
>>     
>>> On Thu, Sep 17, 2009 at 04:17:14PM -0400, Chris Mason wrote:
>>>       
>>>> [ crashes on runs involving unmounts ]
>>>>
>>>> The run is still going here, but it has survived longer than before.
>>>> I'm trying with Yan Zheng's patch:
>>>>
>>>> From: Yan Zheng <zheng.yan@oracle.com>
>>>> Date: Fri, 11 Sep 2009 16:11:19 -0400
>>>> Subject: [PATCH] Btrfs: improve async block group caching
>>>>         
>>> Quick update, I got through a full run of Steve's test with this
>>> applied.  I'll start  a few more ;)
>>>       
>> Seems to work for me too!  Got through all the random write tests
>> with no problems. Will kick off full run overnight.
>>     
>
> Thanks again.
>
> I've updated the btrfs-unstable tree to include Yan Zheng's fix.  I've
> also included two more buffered writeback speedups, and I expect these
> to make a difference on the multi-threaded tests.
>
> I took a look at 1MB O_DIRECT writes, and the latencies of sending off
> checksumming to the checksum threads seem to be the biggest problem.  I
> get full tput at 8MB O_DIRECT writes, so for now I'm going to leave this
> one alone.
>   
Updated performance results are available.  Ran both the 9/16 tree + 
async patches and the tree from 9/18.  Results are a mixed bag, some 
faster some slower.

http://btrfs.boxacle.net/repository/raid/history/History.html

Steve

> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

