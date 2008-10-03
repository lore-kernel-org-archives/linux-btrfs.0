From: Avi Kivity <avi@redhat.com>
Subject: Re: packing structures and numbers
Date: Fri, 03 Oct 2008 16:40:26 +0300
Message-ID: <48E620CA.1030008@redhat.com>
References: <48E6053A.8010100@redhat.com> <1223036573.6836.19.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1223036573.6836.19.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Fri, 2008-10-03 at 14:42 +0300, Avi Kivity wrote:
>   
>> I've been reading btrfs's on-disk format, and two things caught my eye
>>
>> - attribute((packed)) structures everywhere, often with misaligned 
>> fields.  This conserves space, but can be harmful to in-memory 
>> performance on some archs.
>>     
>
> packed is important to make sure that a given field takes exactly the
> same amount of space everywhere, regardless of compiler optimization or
> arch.
>   

Yes, of course.

>> - le64's everywhere.   This scales nicely, but wastes space.  My home 
>> directory is unlikely to have more than 4G objects or 4GB extents (let 
>> alone >2 devices).
>>
>> I think the two issues can be improved by separating the on-disk format 
>> and the in-memory structure, and by using uleb128 as the on-disk format 
>> for numbers.  uleb128 is a variable-length format that encodes 7 bits of 
>> a number in each byte, using the eighth bit as a stop bit.
>>
>>     
>
> This couldn't be used everywhere, as the array of items headers and keys
> need to be a fixed sized the current bin_search code.  The items can be
> variable sized but in general they don't have as many le64s.
>
>   

You'd decode the keys and headers before searching.  This of couse 
negates the idea behind a binary search, unless you cache the decoded nodes.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

