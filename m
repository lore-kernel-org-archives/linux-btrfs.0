Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:35882 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaHTF7S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 01:59:18 -0400
Message-ID: <53F4398A.5000000@glidelink.net>
Date: Tue, 19 Aug 2014 23:00:42 -0700
From: Daniel Mizyrycki <mzdaniel@glidelink.net>
Reply-To: mzdaniel@glidelink.net
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Zach Brown <zab@zabbo.net>,
        Klaus Holler <kho@gmx.at>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs receive problem on ARM kirkwood NAS with kernel 3.16.0
 and btrfs-progs 3.14.2
References: <53F0A3B2.80709@gmx.at> <20140819221055.GI429@lenny.home.zabbo.net> <20140819222241.GD31558@carfax.org.uk>
In-Reply-To: <20140819222241.GD31558@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you Hugo!  Amazing. It almost work all the way,

According to some tests I did, echo 2 >/proc/cpu/alignment does allow in 
fact btrfs receive to work in most cases. For the tests, a x86_64 for 
send, a armv5tel for receive and 2 subvolumes (one with just a few
data and binary files and the other a full root partition) were used.
The send blobs were md5sum and verified at receive side matched.
The small blob was properly process by btrfs receive (file sha1s and 
metadata all matched).
The big blob with the root partition did partially succeeded as it ended
abruptly with ERROR: lsetxattr var/log/journal 
system.posix_acl_default=. failed. Operation not supported. I checked
a few restored files and their sha1 and metadata matched.

Daniel


On 08/19/14 15:22, Hugo Mills wrote:
> On Tue, Aug 19, 2014 at 03:10:55PM -0700, Zach Brown wrote:
>> On Sun, Aug 17, 2014 at 02:44:34PM +0200, Klaus Holler wrote:
>>> Hello list,
>>>
>>> I want to use an ARM kirkwood based NSA325v2 NAS (dubbed "Receiver") for
>>> receiving btrfs snapshots done on several hosts, e.g. a Core Duo laptop
>>> running kubuntu 14.04 LTS (dubbed "Source"), storing them on a 3TB WD
>>> red disk (having GPT label, partitions created with parted).
>>>
>>> But all the btrfs receive commands on 'Receiver' fail soon with e.g.:
>>>    ERROR: writing to initrd.img-3.13.0-24-generic.original failed. File
>>> too large
>>> ... and that stops reception/snapshot creation.
>>
>> ...
>>
>>> Increasing the verbosity with "-v -v" for btrfs receive shows the
>>> following differences between receive operations on 'Receiver' and
>>> 'OtherHost', both of them using the identical inputfile
>>> /boot/.snapshot/20140816-1310-boot_kernel3.16.0.btrfs-send
>>>
>>> * the chown and chmod operations are different -> resulting in
>>> weird/wrong permissions and sizes on 'Receiver' side.
>>> * what's "stransid", this is the first line that differs
>>
>> This is interesting, thanks for going to the trouble to show those
>> diffs.
>>
>> That the commands and strings match up show us that the basic tlv header
>> chaining is working.  But the u64 attribute values are sometimes messed
>> up.  And messed up in a specific way.  A variable number of low order
>> bytes are magically appearing.
>>
>> (gdb) print/x 11709972488
>> $2 = 0x2b9f80008
>> (gdb) print/x 178680
>> $3 = 0x2b9f8
>>
>> (gdb) print/x 588032
>> $6 = 0x8f900
>> (gdb) print/x 2297
>> $7 = 0x8f9
>>
>> Some light googling makes me think that the Marvell Kirkwood is not
>> friendly at all to unaligned accesses.
>
>     ARM isn't in general -- it never has been, even 20 years ago in the
> ARM3 days when I was writing code in ARM assembler. We've been bitten
> by this before in btrfs (mkfs on ARM works, mounting it fails fast,
> because userspace has a trap to fix unaligned accesses, and the kernel
> doesn't).
>
>> The (biting tongue) send and receive code is playing some games with
>> casting aligned and unaligned pointers.  Maybe that's upsetting the arm
>> toolchain/kirkwood.
>
>     Almost certainly the toolchain isn't identifying the unaligned
> accesses, and thus building code that uses them causes stuff to break.
>
>     There's a workaround for userspace that you can use to verify that
> this is indeed the problem: echo 2 >/proc/cpu/alignment will tell the
> kernel to fix up unaligned accesses initiated in userspace. It's a
> performance killer, but it should serve to identify whether the
> problem is actually this.
>
>     Hugo.
>
>>   Does this completely untested patch to btrfs-progs,
>> to be run on the receiver, do anything?
>>
>> - z
>>
>> diff --git a/send-stream.c b/send-stream.c
>> index 88e18e2..4f8dd83 100644
>> --- a/send-stream.c
>> +++ b/send-stream.c
>> @@ -204,7 +204,7 @@ out:
>>                  int __len; \
>>                  TLV_GET(s, attr, (void**)&__tmp, &__len); \
>>                  TLV_CHECK_LEN(sizeof(*__tmp), __len); \
>> -               *v = le##bits##_to_cpu(*__tmp); \
>> +               *v = get_unaligned_le##bits(__tmp); \
>>          } while (0)
>>
>>   #define TLV_GET_U8(s, attr, v) TLV_GET_INT(s, attr, 8, v)
>
