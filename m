From: Avi Kivity <avi@redhat.com>
Subject: Re: packing structures and numbers
Date: Sun, 05 Oct 2008 07:31:57 +0200
Message-ID: <48E8514D.9060909@redhat.com>
References: <48E6053A.8010100@redhat.com> <48E66659.1030202@oracle.com>	<48E729D7.4030509@redhat.com> <87prmgnwsv.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Zach Brown <zach.brown@oracle.com>, linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87prmgnwsv.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

Andi Kleen wrote:
>> On those archs that take faults on unaligned accesses it's unlikely to
>> be in the noise.  But we could (and should) stick a get_unaligned() in
>> the accessor functions.
>>     
>
> Normally the compiler on such architectures generates special load/store code
> for known unaligned types that does not actually fault, but just uses multiple
> instructions. That is slower than a normal memory access, but still much
> faster than a exception.
>
> You only really get the full exception fault penalty when the compiler
> cannot figure out at compile time that a given variable is unaligned.
> But with packed it normally assumes that (I think)

Sounds reasonable.  In which case the unaligned access issue I raised is 
a red herring.  So using uleb128 or not is down to whether the improved 
packing efficiency is worth the increased complexity; it seems unlikely 
that it is.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

