From: Avi Kivity <avi@redhat.com>
Subject: Re: packing structures and numbers
Date: Sat, 04 Oct 2008 11:31:19 +0300
Message-ID: <48E729D7.4030509@redhat.com>
References: <48E6053A.8010100@redhat.com> <48E66659.1030202@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48E66659.1030202@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Zach Brown wrote:
> Avi Kivity wrote:
>   
>> I've been reading btrfs's on-disk format, and two things caught my eye
>>
>> - attribute((packed)) structures everywhere, often with misaligned
>> fields.  This conserves space, but can be harmful to in-memory
>> performance on some archs.
>>     
>
> How harmful?  Do you have any profiles that can even pick this out of
> the noise?
>   

On those archs that take faults on unaligned accesses it's unlikely to 
be in the noise.  But we could (and should) stick a get_unaligned() in 
the accessor functions.

uleb128 encoding is orthogonal to this issue, however.  It's only about 
getting better density.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

