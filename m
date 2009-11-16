From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: nodatacsum broken?
Date: Mon, 16 Nov 2009 10:51:21 -0600
Message-ID: <4B018309.8070104@austin.ibm.com>
References: <4B017C63.5000600@austin.ibm.com> <20091116162706.GA27677@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Steven Pratt <slpratt@austin.ibm.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091116162706.GA27677@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Mon, Nov 16, 2009 at 10:22:59AM -0600, Steven Pratt wrote:
>   
>> Did we break the ability to run with -o nodatacsum somewhere along
>> the way? I had not run just this option in a while (usually doing
>> nodatacow which implies nodatacsum).  Just did a full run with just
>> nodatacsum and it looks like we still did csums.
>>     
>
> Were the files created without nodatasum?  The sum option actually ends
> up stored in the file itself, so if you're reading from an old dataset
> you'll still sum.
>   
No, fresh mkfs and all mounts used nodatacsum.

Steve

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

