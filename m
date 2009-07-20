From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Random write regression
Date: Mon, 20 Jul 2009 09:47:27 -0500
Message-ID: <4A64837F.7090206@austin.ibm.com>
References: <4A646D0E.1060006@austin.ibm.com> <20090720133431.GB25193@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Steven Pratt <slpratt@austin.ibm.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090720133431.GB25193@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Mon, Jul 20, 2009 at 08:11:42AM -0500, Steven Pratt wrote:
>   
>> Finally got around to going through latest data.  Seems like we lost all  
>> the random write performance gains.  Creates are better, but total  
>> regression on the random workload.  Sequential reads seem to have  
>> dropped as well.
>>     
>
> Interesting, was this filesystem freshly created?
>   
Yes, alway mkfs before the runs.

Steve

> -chris
>   

