From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Updated performance results
Date: Thu, 17 Sep 2009 17:04:11 -0500
Message-ID: <4AB2B25B.5070706@austin.ibm.com>
References: <4A9C0D19.5010108@austin.ibm.com> <20090911192955.GB2894@think> <4AAAC2B6.8040105@austin.ibm.com> <20090914135130.GE8839@think> <4AAEB89C.3040100@austin.ibm.com> <20090916005225.GG23965@think> <4AB280AD.5080306@hp.com> <4AB28245.2000704@austin.ibm.com> <20090917185220.GA18165@think> <20090917201714.GE18165@think> <20090917204331.GG18165@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Eric Whitney <eric.whitney@hp.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090917204331.GG18165@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Thu, Sep 17, 2009 at 04:17:14PM -0400, Chris Mason wrote:
>   
>> [ crashes on runs involving unmounts ]
>>
>> The run is still going here, but it has survived longer than before.
>> I'm trying with Yan Zheng's patch:
>>
>> From: Yan Zheng <zheng.yan@oracle.com>
>> Date: Fri, 11 Sep 2009 16:11:19 -0400
>> Subject: [PATCH] Btrfs: improve async block group caching
>>     
>
> Quick update, I got through a full run of Steve's test with this
> applied.  I'll start  a few more ;)
>   
Seems to work for me too!  Got through all the random write tests with 
no problems. Will kick off full run overnight.

Steve

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

