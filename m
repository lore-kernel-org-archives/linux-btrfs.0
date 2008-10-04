From: Andi Kleen <andi@firstfloor.org>
Subject: Re: packing structures and numbers
Date: Sat, 04 Oct 2008 18:34:56 +0200
Message-ID: <87prmgnwsv.fsf@basil.nowhere.org>
References: <48E6053A.8010100@redhat.com> <48E66659.1030202@oracle.com>
	<48E729D7.4030509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zach Brown <zach.brown@oracle.com>, linux-btrfs@vger.kernel.org
To: Avi Kivity <avi@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48E729D7.4030509@redhat.com> (Avi Kivity's message of "Sat, 04 Oct 2008 11:31:19 +0300")
List-ID: <linux-btrfs.vger.kernel.org>

Avi Kivity <avi@redhat.com> writes:

> Zach Brown wrote:
>> Avi Kivity wrote:
>>
>>> I've been reading btrfs's on-disk format, and two things caught my eye
>>>
>>> - attribute((packed)) structures everywhere, often with misaligned
>>> fields.  This conserves space, but can be harmful to in-memory
>>> performance on some archs.
>>>
>>
>> How harmful?  Do you have any profiles that can even pick this out of
>> the noise?
>>
>
> On those archs that take faults on unaligned accesses it's unlikely to
> be in the noise.  But we could (and should) stick a get_unaligned() in
> the accessor functions.

Normally the compiler on such architectures generates special load/store code
for known unaligned types that does not actually fault, but just uses multiple
instructions. That is slower than a normal memory access, but still much
faster than a exception.

You only really get the full exception fault penalty when the compiler
cannot figure out at compile time that a given variable is unaligned.
But with packed it normally assumes that (I think).

-Andi

-- 
ak@linux.intel.com
