From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Mis-Design of Btrfs?
Date: Thu, 14 Jul 2011 07:02:22 +0100
Message-ID: <4E1E866E.2050405@redhat.com>
References: <20110623105337.GD3753@ethz.ch>	<20110627164637.377314e2@notabene.brown>	<4E0AF091.9030301@redhat.com> <20110714155620.6e9ac2cc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Nico Schottelius <nico-lkml-20110623@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Alasdair G Kergon <agk@redhat.com>
To: NeilBrown <neilb@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110714155620.6e9ac2cc@notabene.brown>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/14/2011 06:56 AM, NeilBrown wrote:
> On Wed, 29 Jun 2011 10:29:53 +0100 Ric Wheeler<rwheeler@redhat.com>  wrote:
>
>> On 06/27/2011 07:46 AM, NeilBrown wrote:
>>> On Thu, 23 Jun 2011 12:53:37 +0200 Nico Schottelius
>>> <nico-lkml-20110623@schottelius.org>   wrote:
>>>
>>>> Good morning devs,
>>>>
>>>> I'm wondering whether the raid- and volume-management-builtin of btrfs is
>>>> actually a sane idea or not.
>>>> Currently we do have md/device-mapper support for raid
>>>> already, btrfs lacks raid5 support and re-implements stuff that
>>>> has already been done.
>>>>
>>>> I'm aware of the fact that it is very useful to know on which devices
>>>> we are in a filesystem. But I'm wondering, whether it wouldn't be
>>>> smarter to generalise the information exposure through the VFS layer
>>>> instead of replicating functionality:
>>>>
>>>> Physical:   USB-HD   SSD   USB-Flash          | Exposes information to
>>>> Raid:       Raid1, Raid5, Raid10, etc.        | higher levels
>>>> Crypto:     Luks                              |
>>>> LVM:        Groups/Volumes                    |
>>>> FS:         xfs/jfs/reiser/ext3               v
>>>>
>>>> Thus a filesystem like ext3 could be aware that it is running
>>>> on a USB HD, enable -o sync be default or have the filesystem
>>>> to rewrite blocks when running on crypto or optimise for an SSD, ...
>>> I would certainly agree that exposing information to higher levels is a good
>>> idea.  To some extent we do.  But it isn't always as easy as it might sound.
>>> Choosing exactly what information to expose is the challenge.  If you lack
>>> sufficient foresight you might expose something which turns out to be
>>> very specific to just one device, so all those upper levels which make use of
>>> the information find they are really special-casing one specific device,
>>> which isn't a good idea.
>>>
>>>
>>> However it doesn't follow that RAID5 should not be implemented in BTRFS.
>>> The levels that you have drawn are just one perspective.  While that has
>>> value, it may not be universal.
>>> I could easily argue that the LVM layer is a mistake and that filesystems
>>> should provide that functionality directly.
>>> I could almost argue the same for crypto.
>>> RAID1 can make a lot of sense to be tightly integrated with the FS.
>>> RAID5 ... I'm less convinced, but then I have a vested interest there so that
>>> isn't an objective assessment.
>>>
>>> Part of "the way Linux works" is that s/he who writes the code gets to make
>>> the design decisions.   The BTRFS developers might create something truly
>>> awesome, or might end up having to support a RAID feature that they
>>> subsequently think is a bad idea.  But it really is their decision to make.
>>>
>>> NeilBrown
>>>
>> One more thing to add here is that I think that we still have a chance to
>> increase the sharing between btrfs and the MD stack if we can get those changes
>> made. No one likes to duplicate code, but we will need a richer interface
>> between the block and file system layer to help close that gap.
>>
>> Ric
>>
> I'm certainly open to suggestions and collaboration.  Do you have in mind any
> particular way to make the interface richer??
>
> NeilBrown

Hi Neil,

I know that Chris has a very specific set of use cases for btrfs and think that 
Alasdair and others have started to look at what is doable.

The obvious use case is the following:

If a file system uses checksumming or other data corruption detection bits, it 
can detect that it got bad data on a write. If that data was protected by RAID, 
it would like to ask the block layer to try to read from another mirror (for 
raid1) or try to validate/rebuild from parity.

Today, I think that a retry will basically just give us back a random chance of 
getting data from a different mirror or the same one that we got data from on 
the first go.

Chris, Alasdair, was that a good summary of one concern?

Thanks!

Ric
