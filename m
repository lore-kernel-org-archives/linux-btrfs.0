From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: btrfs panic - BUG: soft lockup - CPU#0 stuck for 61s!	[fs_mark:4573]
Date: Thu, 05 Jun 2008 11:16:26 -0400
Message-ID: <4848034A.6090009@redhat.com>
References: <4844336F.1010807@redhat.com> <20080605143428.GA16999@think.oraclecorp.com>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080605143428.GA16999@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Mon, Jun 02, 2008 at 01:52:47PM -0400, Ric Wheeler wrote:
>   
>> I can reliably get btrfs to panic by running my fs_mark code on a newly  
>> created file system with lots of threads on an 8-way box. If this is too  
>> aggressive, let me know ;-)
>>
>> Here is a summary of the panic:
>>     
>
> BTW, exactly how are you running fs_mark?  Mingming reminded me that
> strictly speaking this patch shouldn't be required, so there might be
> other related problems.
>
> -chris
>
>   
This was the actual command:

./fs_mark -d /mnt/test -D 512 -t 16 -s 409600 -F

I will give your patch a spin right after lunch ;-)

ric


