From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: nodatacsum broken?
Date: Mon, 16 Nov 2009 11:40:01 -0600
Message-ID: <4B018E71.3000003@austin.ibm.com>
References: <4B017C63.5000600@austin.ibm.com> <20091116172327.GD27677@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091116172327.GD27677@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Mon, Nov 16, 2009 at 10:22:59AM -0600, Steven Pratt wrote:
>   
>> Did we break the ability to run with -o nodatacsum somewhere along
>> the way? I had not run just this option in a while (usually doing
>> nodatacow which implies nodatacsum).  Just did a full run with just
>> nodatacsum and it looks like we still did csums.
>>
>> from proc/mounts:
>>
>> /dev/ffsbdev1 on /mnt/ffsb1 type btrfs (rw,nodatacsum)
>>     
>                                          ^^^^^^^^^^^^^^
>
> This should be mount -o nodatasum.
>
>   
Oops. My bad. Re-running.

> 2.6.33 will have a patch from Sage to fail mounting when we don't
> recognize the option instead of silently pretending it worked.  I just
> didn't want to introduce it this late in the 2.6.32-rc series.
>   
Good.

Steve


> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

