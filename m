From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: interesting use case for multiple devices and delayed raid?
Date: Thu, 2 Apr 2009 16:41:39 +1100
Message-ID: <3a7f57190904012241y40f7a906x3edd1ad8002c3208@mail.gmail.com>
References: <1238577447.9099.150.camel@pc.interlinx.bc.ca>
	 <3a7f57190904010313q230f004chf7db770bb1169daa@mail.gmail.com>
	 <gr0kt0$t9l$3@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <gr0kt0$t9l$3@ger.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 2, 2009 at 8:04 AM, Brian J. Murrell <brian@interlinx.bc.ca=
> wrote:
>> A more complete solution, that requires no software changes, would b=
e
>> to have 3 or 4 disks. A stripe for really fast reads and writes, and
>> another disk (or another stripe) to act as a slave to the data being
>> written to the primary stripe. This seems to do what you want, at a
>> small price premium.
>
> No. =C2=A0That's not really what I am describing at all.

Well you get the bandwidth of 2 disks when reading and writing, and
still mirrored to a second stripe as time permits. Kind of like
delayed RAID10.

> I apologize if my original description was unclear. =C2=A0Hopefully i=
t is
> more so now.

Yes. It'll be up to the actual filesystem devs to weigh in on whether
it's worth implementing.

--=20
Dmitri Nikulin

Centre for Synchrotron Science
Monash University
Victoria 3800, Australia
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
