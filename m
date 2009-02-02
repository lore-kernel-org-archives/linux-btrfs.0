From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: More performance results
Date: Mon, 02 Feb 2009 11:35:23 -0600
Message-ID: <49872EDB.2060609@austin.ibm.com>
References: <49871813.8090309@austin.ibm.com> <1233590423.18113.25.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1233590423.18113.25.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Mon, 2009-02-02 at 09:58 -0600, Steven Pratt wrote:
>   
>> Finally cleared out a backlog of results to upload.  Main performance 
>> page is updated with all the links.  (http://btrfs.boxacle.net/)  Most 
>> recent results are on 2.6.29-rc2. As usual see analysis directory of 
>> results for oprofile, including call graphs.
>>
>> Single disk results are not too bad.  Raid still falls apart on any 
>> write heavy workload.
>>     
>
> Thanks Steve, was the mainline btrfs used for this?  I'm working on the
> write heavy problems this week.
>
>   
This was straight mainline Linus tree.

Steve

> -chris
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

