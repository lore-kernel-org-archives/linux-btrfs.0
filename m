From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 11:11:07 -0800
Message-ID: <93cdabd21002261111v211e77e6ic789a2487461a420@mail.gmail.com>
References: <20100226175927.GG12841@think>
	 <20100226181157.50F73414B9@viridian.itc.virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100226181157.50F73414B9@viridian.itc.virginia.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2010 at 10:11 AM, Bill Pemberton
<wfp5p@viridian.itc.virginia.edu> wrote:
>>
>> Does the array have any kind of writeback cache?
>>
>
> Yes, the array has a writeback cache.
>
>>
>> Are all of the filesystems spread across all of the drives? =C2=A0Or=
 do some
>> filesystems use some drives only?
>>
>
> In all cases the array is presenting 1 physical volume to the host
> system (which is RAID 6 on the array itself). =C2=A0That physical vol=
ume is
> made into a volume group and the filesystems are on logical volumes i=
n
> that volume group.
>

I wonder if the barrier messages are making it to this write back
cache.  Do you see any messages about barriers in your kernel logs?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
