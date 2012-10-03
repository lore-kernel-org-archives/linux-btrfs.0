Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:35861 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656Ab2JCQSB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Oct 2012 12:18:01 -0400
Message-ID: <506C6531.4060700@inwind.it>
Date: Wed, 03 Oct 2012 18:17:53 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
CC: Hugo Mills <hugo@carfax.org.uk>, Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it> <20121003115615.GB25498@carfax.org.uk>
In-Reply-To: <20121003115615.GB25498@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/03/2012 01:56 PM, Hugo Mills wrote:
>     Looks good. Only a few comments, inline.
>
> On Wed, Oct 03, 2012 at 01:43:14PM +0200, Goffredo Baroncelli wrote:
>> $ ./btrfs filesystem df --help
>> usage: btrfs filesystem disk-usage [-d][-s][-k]<path>  [<path>..]
>>
>>      Show space usage information for a mount point(s).
>>
>>      -k  Set KB (1024 bytes) as unit
>>      -s  Don't show the summary section
>>      -d  Don't show the detail section
>
>     These are kind of logical, but I think would be hard to remember
> the right way round. I would suggest swapping the actions of the
> switches, and rewording the help:
>
> -s Show only summary section
> -d Show only detail section

Yes this make sense...

>
>> $ ./btrfs filesystem df /
>> Path: /
>> Summary:
>>    Disk_size:                 72.57GB
>
>                                      ^ space between the value and the
>                                        unit (as ISO says), throughout.
>                                        This also makes it easier to
>                                        parse, if anyone wants to.
>
>     Also, use kB, MB, GB, TB for powers-of-ten based units, and KiB,
> MiB, GiB, TiB for powers-of-two based units, please. I don't care
> which you report in, but please do make the distinction. (And note
> that it's kB with a lower case k, but KiB with an upper case K). This
> brings us in line with the relevant ISO and IEEE standards.

I forgot to reply you when you raised this question the first time. Even 
though I am inclined to accept your suggestions, this change is not 
related to my patches. My code uses the functions print_sizes(), which 
is quite old (about 2008). This function is used in a lot of places. 
This suggested to address this issue with another patch.

>
>>    Disk_allocated:            25.10GB
>>    Disk_unallocated:          47.48GB
>>    Logical_size:              23.06GB
>>    Used:                      11.01GB
>>    Free_(Estimated):          55.66GB    (Max: 59.52GB, Min: 35.78GB)
>>    Data_to_disk_ratio:           92 %
>>
>> Details:
>>    Chunk-type  Mode      Chunk-size Logical-size        Used
>>    Data        Single       21.01GB      21.01GB     10.34GB
>>    System      DUP          80.00MB      40.00MB      4.00KB
>>    System      Single        4.00MB       4.00MB        0.00
>>    Metadata    DUP           4.00GB       2.00GB    686.93MB
>>    Metadata    Single        8.00MB       8.00MB        0.00
>
>     Why are the field headings here using - where the field headings in
> the first section used _? Should you be using _ in both places?

2 persons highlighted that :-( ... I will update the code

>
>     Hugo.
>

