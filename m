From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: BTRFS Performance page
Date: Wed, 22 Oct 2008 14:46:12 -0500
Message-ID: <48FF8304.6060707@austin.ibm.com>
References: <48FE5593.2080209@austin.ibm.com> <48FF4028.5080109@austin.ibm.com> <20081022192528.GB19187@stingr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Paul P Komkoff Jr <i@stingr.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081022192528.GB19187@stingr.net>
List-ID: <linux-btrfs.vger.kernel.org>

Paul P Komkoff Jr wrote:
> Replying to Steven Pratt:
>   
>> Steven Pratt wrote:
>> RAID data is now uploaded.  The config used is 136 15k rpm fiber disks  
>> in 8 arrays all striped together with DM.  These results are not as  
>> favorable to BTRFS, as there seem to be some major issues with random  
>> write and mail server workloads.
>>     
>
> Why don't use btrfs' own RAID capabilities instead?
> Honestly, I will never ever use md as soon as I'll get btrfs working
> :)
>
>   
On the list of things to try.  Main reason was we wanted to be able to 
compare to other file systems and they are lacking that feature. 

Steve

>> http://btrfs.boxacle.net/repository/raid/Initial-compare/Initial-Compare-RAID0.html
>>     
>
>   

