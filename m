From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Mis-Design of Btrfs?
Date: Thu, 14 Jul 2011 18:27:14 +0200
Message-ID: <4E1F18E2.9030100@libero.it>
References: <20110623105337.GD3753@ethz.ch>	<20110627164637.377314e2@notabene.brown>	<4E0AF091.9030301@redhat.com>	<20110714155620.6e9ac2cc@notabene.brown>	<4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
To: NeilBrown <neilb@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110714163836.35a729c1@notabene.brown>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/14/2011 08:38 AM, NeilBrown wrote:
> On Thu, 14 Jul 2011 07:02:22 +0100 Ric Wheeler <rwheeler@redhat.com> wrote:
> 
>>> I'm certainly open to suggestions and collaboration.  Do you have in mind any
>>> particular way to make the interface richer??
>>>
>>> NeilBrown
>>
>> Hi Neil,
>>
>> I know that Chris has a very specific set of use cases for btrfs and think that 
>> Alasdair and others have started to look at what is doable.
>>
>> The obvious use case is the following:
>>
>> If a file system uses checksumming or other data corruption detection bits, it 
>> can detect that it got bad data on a write. If that data was protected by RAID, 
>> it would like to ask the block layer to try to read from another mirror (for 
>> raid1) or try to validate/rebuild from parity.
>>
>> Today, I think that a retry will basically just give us back a random chance of 
>> getting data from a different mirror or the same one that we got data from on 
>> the first go.
>>
>> Chris, Alasdair, was that a good summary of one concern?
>>
>> Thanks!
>>
>> Ric
> 
> I imagine a new field in 'struct bio' which was normally zero but could be
> some small integer.  It is only meaningful for read.
> When 0 it means "get this data way you like".
> When non-zero it means "get this data using method N", where the different
> methods are up to the device.

In more general terms, the filesystem should be able to require: try
another read different regarding the previous ones. The term are
important because we should differentiate the case of "wrong data from
disk1, read from disk0" and "wrong data from disk0 read disk1". I prefer
thinking the field as bitmap. Every bit represent a different way of
read. So it is possible to reuse to track which "kind of read" was
already used.

After a 2nd read, the block layer should:
	a) redo the read if possible, otherwise FAIL
	b) pass the data to the filesystem
	c) if the filesystem accepts the new data, replace the wrong
	   data with the correct one or mark the block as broken.
	d) inform the userspace/filesystem of the result

> 
> For a mirrored RAID, method N means read from device N-1.
> For stripe/parity RAID, method 1 means "use other data blocks and parity
> blocks to reconstruct data.
> 
> The default for non RAID devices is to return EINVAL for any N > 0.
> A remapping device (dm-linear, dm-stripe etc) would just pass the number
> down.  I'm not sure how RAID1 over RAID5 would handle it... that might need
> some thought.
> 
> So if btrfs reads a block and the checksum looks wrong, it reads again with
> a larger N.  It continues incrementing N and retrying until it gets a block
> that it likes or it gets EINVAL.  There should probably be an error code
> (EAGAIN?) which means "I cannot work with that number, but try the next one".
> 
> It would be trivial for me to implement this for RAID1 and RAID10, and
> relatively easy for RAID5.
> I'd need to give a bit of thought to RAID6 as there are possibly multiple
> ways to reconstruct from different combinations of parity and data.  I'm not
> sure if there would be much point in doing that though.
> 
> It might make sense for a device to be able to report what the maximum
> 'N' supported is... that might make stacked raid easier to manage...
> 
> NeilBrown
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 
