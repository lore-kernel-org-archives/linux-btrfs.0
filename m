From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 05 Jan 2011 20:27:35 +0000
Message-ID: <4D24D437.4010308@bobich.net>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>	<4D24AD92.4070107@bobich.net> <201101051941.13268.diegocg@gmail.com> <20110105190139.GA32671@bludgeon.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110105190139.GA32671@bludgeon.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/05/2011 07:01 PM, Ray Van Dolson wrote:
> On Wed, Jan 05, 2011 at 07:41:13PM +0100, Diego Calleja wrote:
>> On Mi=E9rcoles, 5 de Enero de 2011 18:42:42 Gordan Bobic escribi=F3:
>>> So by doing the hash indexing offline, the total amount of disk I/O
>>> required effectively doubles, and the amount of CPU spent on doing =
the
>>> hashing is in no way reduced.
>>
>> But there are people who might want to avoid temporally the extra co=
st
>> of online dedup, and do it offline when the server load is smaller.
>>
>> In my opinion, both online and offline dedup have valid use cases, a=
nd
>> the best choice is probably implement both.
>
> Question from an end-user.  When we say "offline" deduplication, are =
we
> talking about post-process deduplication (a la what Data ONTAP does
> with their SIS implementation) during which the underlying file syste=
m
> data continues to be available, or a process that needs exclusive
> access ot the blocks to do its job?

I was assuming it was a regular cron-job that grinds away on the disks=20
but doesn't require downtime.

Gordan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
