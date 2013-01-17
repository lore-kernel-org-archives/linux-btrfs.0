Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19320 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757464Ab3AQEM3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jan 2013 23:12:29 -0500
Message-ID: <50F77A50.1000109@cn.fujitsu.com>
Date: Thu, 17 Jan 2013 12:13:04 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 05/11] Btrfs: protect fs_info->alloc_start
References: <50EEB880.4060308@cn.fujitsu.com> <20130110171040.GG20089@twin.jikos.cz> <50F3BC2B.2010407@cn.fujitsu.com> <20130116124300.GR20089@twin.jikos.cz>
In-Reply-To: <20130116124300.GR20089@twin.jikos.cz>
Content-Type: multipart/mixed;
 boundary="------------090806070006090203080508"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--------------090806070006090203080508
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On wed, 16 Jan 2013 13:43:00 +0100, David Sterba wrote:
> On Mon, Jan 14, 2013 at 04:04:59PM +0800, Miao Xie wrote:
>> On Thu, 10 Jan 2013 18:10:40 +0100, David Sterba wrote:
>>> On Thu, Jan 10, 2013 at 08:48:00PM +0800, Miao Xie wrote:
>>>> fs=5Finfo->alloc=5Fstart was not protected strictly, it might be chang=
ed while
>>>> we were accessing it. This patch fixes this problem by using two locks=
 to
>>>> protect it (fs=5Finfo->chunk=5Fmutex and sb->s=5Fumount). On the read =
side, we
>>>> just need get one of these two locks, and on the write side, we must l=
ock
>>>> all of them.
>>>
>>> Can you please describe how this can theoretically cause any problems?
>>>
>>> Out of curiosity I've been running this command on a 60G ssd disk for a=
 while
>>>
>>> for i in `seq 1 10000|shuf`;do
>>> 	mount -o remount,alloc=5Fstart=3D$(($i*1024*1024)) /mnt/sdc;done
>>> 	#sleep 0 / 1 / 5
>>> done
>>>
>>> together with one of my favourite stresstests (heavy writes, subvolume
>>> activity).
>>>
>>> There are two direct users of fs=5Finfo->alloc=5Fstart:
>>>
>>> * statfs via btrfs=5Fcalc=5Favail=5Fdata=5Fspace
>>> * find=5Ffree=5Fdev=5Fextent
>>>
>>> 960         search=5Fstart =3D max(root->fs=5Finfo->alloc=5Fstart, 1024=
ull * 1024);
>>>
>>> as remount calls sync, there is a very tiny window where an allocation =
could
>>> get the old value of alloc=5Fstart just between sync and do=5Fremount. =
Theoretical
>>> and without any visible effect.
>>
>> ->alloc=5Fstart is a 64bits variant, on the 32bits machine, we have to l=
oad it
>> by two instructions.
>>
>> Assuming -> alloc=5Fstart is 0x00010000 at the beginning, then we remoun=
t and
				^ it should be 0x0000 0001 0000 0000

>> set ->alloc=5Fstart to 0x00000100
				^ should be 0x0000 0000 0001 0000

>> 	Task0 			Task1
>> 				load low 32 bits
>> 	set high 32 bits
>> 				load high 32 bits
>> 	set low 32 bits
>>
>> Task1 will get 0.
>=20
> That's an insufficient description of how a race could actually happen,
> it's only a high-level scheme how a 64bit value can get mixed up with
> 32bit access.
>=20
> How exactly does it cause problems in btrfs code?
>=20
> IMO the bug is not there due to various reasons like instruction
> scheduling and cache effect that may hide the actual split of the 32bit
> value.
>=20
> * the value set on one cpu is not immediatelly visible on another cpu
> * the full 64bit value of alloc=5Fstart lives inside a single cacheline
>   and will be updated as a whole in context of btrfs -- there's only one

I know it lives inside a single cacheline, but only the cacheline will be u=
pdated
as a whole, not the 64bit value. And cacheline is not a lock, it can not pr=
event
that it is acquired by the other CPU when only a half is updated. Right?

>   place where it's set so multiple places that would store the value and
>   fight over the cacheline exclusivity are out of question;
>   the storing cpu will flush the pending writes at some point in time
>   so they're visible by other cpus, until then the load side reads a
>   consistent value -- in almost all cases, and this gets even more wild
>   and counts on exact timing of a memory barriers triggered from other
>   cpu and cacheline ownership, so the store finishes only one half,
>   barrier, load finds half new and half old value, store does the other
>   half
> * this needs to happen within 4-5 instructions for an operation that
>   involves a IO sync -- makes it much harder to provoke right timing
>=20
> Your example with 0x00010000 and 0x00000100 uses only 32bit values, so

My mistake, sorry. The number we want to use is 64bit(see above).

> it cannot be applied here. Also, alloc=5Fstart is always compared with the
> hardcoded 1M limit so it cannot go below to 0.

0 is just a sample. The point is we should not allocate a extent from a une=
xpected
address.

> The point is not the one extra mutex lock, but that you're attempting to
> fix a bug highly improbable if possible at all without a proper

On 32bit machines, it is not highly improbable, we can trigger this bug eas=
ily
(The attached code which simulates the process of the btrfs can reproduce t=
he bug).

This problem don't happen on btrfs is because:
1. Most of the users use btrfs on 64bit machine
2. Changing alloc=5Fstart is infrequent=EF=BC=8Cand chunk allocation is not=
 frequent.
So the race is hard to be triggered on btrfs. But it doesn't means it can
not happen.

> description and analysis. I don't want to spend the time on this and do
> the work for instead of you next time, please try harder to convince us.

Miao

=

--------------090806070006090203080508
Content-Transfer-Encoding: 7bit
Content-Type: text/x-csrc;
 name="test.c"
Content-Disposition: attachment;
 filename="test.c"

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

unsigned long long global = 0x00010000;
#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))

void *thread_set_function(void *arg);
void *thread_read_function(void *arg);

int main(int argc, char **argv)
{
	int ret;
	pthread_t pthread_set;
	pthread_t pthread_read;

	ret = pthread_create(&pthread_set, NULL, thread_set_function, NULL);
	if (ret) {
		fprintf(stderr, "ERROR: fail to create set_thread\n");
		exit(EXIT_FAILURE);
	}
	ret = pthread_create(&pthread_read, NULL, thread_read_function, NULL);
	if (ret) {
		fprintf(stderr, "ERROR: fail to create read_thread\n");
		exit(EXIT_FAILURE);
	}
	pthread_join(pthread_set, NULL);
	pthread_join(pthread_read, NULL);
	return 0;
}

void *thread_set_function(void *arg)
{
	sleep(1);
	while(1) {
		ACCESS_ONCE(global) = 0x0000000000000100;
		ACCESS_ONCE(global) = 0x0010000000000000;
	}
}

void *thread_read_function(void *arg)
{
	if (global)
		printf("no 0 \n");
	while(1) {
		if (global == 0) {
			printf("0 is detected\n");
			exit(0);
		}
	}
}

--------------090806070006090203080508--
