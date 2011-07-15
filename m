From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Mis-Design of Btrfs?
Date: Fri, 15 Jul 2011 09:55:57 -0400
Message-ID: <CAMM=eLcXz7=tVdHTyUzctaaqGUd0+9n5OZ9Z_=sixm3Y-Hsgfw@mail.gmail.com>
References: <20110623105337.GD3753@ethz.ch> <20110627164637.377314e2@notabene.brown>
 <4E0AF091.9030301@redhat.com> <20110714155620.6e9ac2cc@notabene.brown>
 <4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown>
 <4E1E9372.3030208@redhat.com> <1310696606-sup-710@shiny> <alpine.DEB.2.02.1107142149420.3558@asgard.lang.hm>
 <20110715163354.74fa2083@notabene.brown> <1310728784-sup-9024@shiny> <4E20395C.1000301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, NeilBrown <neilb@suse.de>,
	david <david@lang.hm>,
	Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E20395C.1000301@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 15, 2011 at 8:58 AM, Ric Wheeler <rwheeler@redhat.com> wrot=
e:
> On 07/15/2011 12:34 PM, Chris Mason wrote:
>>
>> Excerpts from NeilBrown's message of 2011-07-15 02:33:54 -0400:
>>>
>>> On Thu, 14 Jul 2011 21:58:46 -0700 (PDT) david@lang.hm wrote:
>>>
>>>> On Thu, 14 Jul 2011, Chris Mason wrote:
>>>>
>>>>> Excerpts from Ric Wheeler's message of 2011-07-14 02:57:54 -0400:
>>>>>>
>>>>>> On 07/14/2011 07:38 AM, NeilBrown wrote:
>>>>>>>
>>>>>>> On Thu, 14 Jul 2011 07:02:22 +0100 Ric Wheeler<rwheeler@redhat.=
com>
>>>>>>> wrote:
>>>>>>>
>>>>>>>>> I'm certainly open to suggestions and collaboration. =A0Do yo=
u have
>>>>>>>>> in mind any
>>>>>>>>> particular way to make the interface richer??
>>>>>>>>>
>>>>>>>>> NeilBrown
>>>>>>>>
>>>>>>>> Hi Neil,
>>>>>>>>
>>>>>>>> I know that Chris has a very specific set of use cases for btr=
fs and
>>>>>>>> think that
>>>>>>>> Alasdair and others have started to look at what is doable.
>>>>>>>>
>>>>>>>> The obvious use case is the following:
>>>>>>>>
>>>>>>>> If a file system uses checksumming or other data corruption
>>>>>>>> detection bits, it
>>>>>>>> can detect that it got bad data on a write. If that data was
>>>>>>>> protected by RAID,
>>>>>>>> it would like to ask the block layer to try to read from anoth=
er
>>>>>>>> mirror (for
>>>>>>>> raid1) or try to validate/rebuild from parity.
>>>>>>>>
>>>>>>>> Today, I think that a retry will basically just give us back a
>>>>>>>> random chance of
>>>>>>>> getting data from a different mirror or the same one that we g=
ot
>>>>>>>> data from on
>>>>>>>> the first go.
>>>>>>>>
>>>>>>>> Chris, Alasdair, was that a good summary of one concern?
>>>>>>>>
>>>>>>>> Thanks!
>>>>>>>>
>>>>>>>> Ric
>>>>>>>
>>>>>>> I imagine a new field in 'struct bio' which was normally zero b=
ut
>>>>>>> could be
>>>>>>> some small integer. =A0It is only meaningful for read.
>>>>>>> When 0 it means "get this data way you like".
>>>>>>> When non-zero it means "get this data using method N", where th=
e
>>>>>>> different
>>>>>>> methods are up to the device.
>>>>>>>
>>>>>>> For a mirrored RAID, method N means read from device N-1.
>>>>>>> For stripe/parity RAID, method 1 means "use other data blocks a=
nd
>>>>>>> parity
>>>>>>> blocks to reconstruct data.
>>>>>>>
>>>>>>> The default for non RAID devices is to return EINVAL for any N>=
 =A0 0.
>>>>>>> A remapping device (dm-linear, dm-stripe etc) would just pass t=
he
>>>>>>> number
>>>>>>> down. =A0I'm not sure how RAID1 over RAID5 would handle it... t=
hat
>>>>>>> might need
>>>>>>> some thought.
>>>>>>>
>>>>>>> So if btrfs reads a block and the checksum looks wrong, it read=
s
>>>>>>> again with
>>>>>>> a larger N. =A0It continues incrementing N and retrying until i=
t gets a
>>>>>>> block
>>>>>>> that it likes or it gets EINVAL. =A0There should probably be an=
 error
>>>>>>> code
>>>>>>> (EAGAIN?) which means "I cannot work with that number, but try =
the
>>>>>>> next one".
>>>>>>>
>>>>>>> It would be trivial for me to implement this for RAID1 and RAID=
10,
>>>>>>> and
>>>>>>> relatively easy for RAID5.
>>>>>>> I'd need to give a bit of thought to RAID6 as there are possibl=
y
>>>>>>> multiple
>>>>>>> ways to reconstruct from different combinations of parity and d=
ata.
>>>>>>> =A0I'm not
>>>>>>> sure if there would be much point in doing that though.
>>>>>>>
>>>>>>> It might make sense for a device to be able to report what the
>>>>>>> maximum
>>>>>>> 'N' supported is... that might make stacked raid easier to mana=
ge...
>>>>>>>
>>>>>>> NeilBrown
>>>>>>>
>>>>>> I think that the above makes sense. Not sure what your "0" defin=
ition
>>>>>> is, but I
>>>>>> would assume that for non-raided devices (i.e., a single s-ata d=
isk),
>>>>>> "0" would
>>>>>> be an indication that there is nothing more that can be tried. T=
he
>>>>>> data you got
>>>>>> is all you are ever going to get :)
>>>>>>
>>>>>> For multiple mirrors, you might want to have a scheme where you =
would
>>>>>> be able to
>>>>>> cycle through the mirrors. You could retry, cycling through the
>>>>>> various mirrors
>>>>>> until you have tried and returned them all at which point you wo=
uld
>>>>>> get a "no
>>>>>> more" error back or some such thing.
>>>>>
>>>>> Hi everyone,
>>>>>
>>>>> The mirror number idea is basically what btrfs does today, and I =
think
>>>>> it fits in with Neil's idea to have different policies for differ=
ent
>>>>> blocks.
>>>>>
>>>>> Basically what btrfs does:
>>>>>
>>>>> read_block(block_num, mirror =3D 0)
>>>>> if (no io error and not csum error)
>>>>> =A0 =A0 horray()
>>>>>
>>>>> num_mirrors =3D get_num_copies(block number)
>>>>> for (i =3D 1; i< =A0num_mirrors; i++) {
>>>>> =A0 =A0 read_block(block_num, mirror =3D i);
>>>>> }
>>>>>
>>>>> In a stacked configuration, the get_num_copies function can be sm=
arter,
>>>>> basically adding up all the copies of the lower levels and findin=
g a
>>>>> way
>>>>> to combine them. =A0We could just send down a fake bio that is
>>>>> responsible
>>>>> for adding up the storage combinations into a bitmask or whatever
>>>>> works.
>>>>>
>>>>> We could also just keep retrying until the lower layers reported =
no
>>>>> more
>>>>> mirror were available.
>>>>>
>>>>> In btrfs at least, we don't set the data blocks up to date until =
the
>>>>> crc
>>>>> has passed, so replacing bogus blocks is easy. =A0Metadata is a l=
ittle
>>>>> more complex, but that's not really related to this topic.
>>>>>
>>>>> mirror number 0 just means "no mirror preference/pick the fastest
>>>>> mirror" to the btrfs block mapping code.
>>>>>
>>>>> Btrfs has the concept of different raid levels for different logi=
cal
>>>>> block numbers, so you get_num_copies might return one answer for =
block
>>>>> A
>>>>> and a different answer for block B.
>>>>>
>>>>> Either way, we could easily make use of a bio field here if it we=
re
>>>>> exported out.
>>>>
>>>> you don't want to just pass the value down as that will cause prob=
lems
>>>> with layering (especially if the lower layer supports more values =
than a
>>>> higher layer)
>>>>
>>>> I would suggest that each layer take the value it's give, do an in=
teger
>>>> division by the number of values that layer supports, using the mo=
dulo
>>>> value for that layer and pass the rest of the result down to the n=
ext
>>>> layer.
>>>
>>> I, on the other hand, would suggest that each layer be given the fr=
eedom,
>>> and
>>> the responsibility, to do whatever it thinks is most appropriate.
>>>
>>> This would probably involved checking the lower levels to see how m=
any
>>> strategies each has, and doing some appropriate arithmetic dependin=
g on
>>> how
>>> it combines those devices.
>>>
>>> One problem here is the assumption that the lower levels don't chan=
ge,
>>> and we
>>> know that not to be the case.
>>> However this is already a problem. =A0It is entirely possible that =
the
>>> request
>>> size parameters of devices can change at any moment, even while a r=
equest
>>> is
>>> in-flight ... though we try to avoid that or work around it.
>>>
>>> The sort of dependencies that we see forming here would probably ju=
st
>>> make
>>> the problem worse.
>>>
>>> Not sure what to do about it though.... maybe just hope it isn't a
>>> problem.
>>
>> Agreed, if we want to go beyond best effort for a stacking config, w=
e'll
>> need to put some state struct in the bio that each layer can play wi=
th.
>> That way each layer knows which mirrors have already been tried.
>>
>> But, maybe the whole btrfs model is backwards for a generic layer.
>> Instead of sending down ios and testing when they come back, we coul=
d
>> just set a verification function (or stack of them?).
>>
>> For metadata, btrfs compares the crc and a few other fields of the
>> metadata block, so we can easily add a compare function pointer and =
a
>> void * to pass in.
>>
>> The problem is the crc can take a lot of CPU, so btrfs kicks it off =
to
>> threading pools so saturate all the cpus on the box. =A0But there's =
no
>> reason we can't make that available lower down.
>>
>> If we pushed the verification down, the retries could bubble up the
>> stack instead of the other way around.
>>
>> -chris
>
> I do like the idea of having the ability to do the verification and r=
etries
> down the stack where you actually have the most context to figure out=
 what
> is possible...
>
> Why would you need to bubble back up anything other than an error whe=
n all
> retries have failed?

Right, passing a validator is natural.  We've done the same for
validating DM thinp's metadata (crc, blocknr, etc), btree nodes,
bitmaps, etc.  The dm-thinp code is very much under review but I
figured I'd share.

See:
https://github.com/jthornber/linux-2.6/blob/4c4089de2e5a4f343d9810f7653=
1cb25aa13f91c/drivers/md/dm-thin-metadata.c

Specifically:
static struct dm_block_validator sb_validator_

So we pass a dm_block_validator around when doing block IO.  Each
validator has a .check and a .preparse_for_write method.

If the greater kernel offered a comparable mechanism we'd just switch
over to using it.

Mike
