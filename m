From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Updated performance results
Date: Fri, 24 Jul 2009 10:05:56 -0500
Message-ID: <4A69CDD4.6060302@austin.ibm.com>
References: <4A68AD69.4030803@dangyankee.net> <20090723210051.GB1040@think> <4A68DE81.3020505@dangyankee.net> <20090724132407.GC16192@think> <20090724140002.GD16192@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090724140002.GD16192@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Fri, Jul 24, 2009 at 09:24:07AM -0400, Chris Mason wrote:
>   
>>>>   
>>>>         
>>> Sure, will try to get to it tomorrow.
>>>       
>> Sorry, I missed a fix in the experimental branch.  I'll push out a
>> rebased version in a few minutes.
>>
>>     
>
> Ok, the rebased version is ready to use.
>   
Ok, good.  Also seems I misspoke on the -o ssd results. I looked them 
over again this morning and they are slightly bette than without.  
Initial score of 46MB/sec vs 44MB/sec without, and degrades after 30 
minutes to about 25MB/sec vs 20MB/sec without.  So after 30 minutes of 
runtime -o ssd is running about 25% faster, but still significant degrade.

Steve

> -chris
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

