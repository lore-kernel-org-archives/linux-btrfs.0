From: Gregory Maxwell <gmaxwell@gmail.com>
Subject: Re: btrfs csum failed on git .pack file
Date: Wed, 9 Sep 2009 03:28:01 -0400
Message-ID: <e692861c0909090028x53faa467g7e91bfaf6ad5139@mail.gmail.com>
References: <20090907203531.GA1889@phenom2.trippelsdorf.de>
	 <20090908200041.GF18599@kernel.dk>
	 <20090908202211.GA1901@phenom2.trippelsdorf.de>
	 <20090908215357.GK6779@tracyreed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
	Jens Axboe <jens.axboe@oracle.com>, linux-btrfs@vger.kernel.org
To: Tracy Reed <treed@ultraviolet.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090908215357.GK6779@tracyreed.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 8, 2009 at 5:53 PM, Tracy Reed<treed@ultraviolet.org> wrote=
:
> On Tue, Sep 08, 2009 at 10:22:11PM +0200, Markus Trippelsdorf spake t=
husly:
>> I've already deleted the file in question unfortunately.
>> On IRC Chris decided that either bad RAM or a harddrive error was th=
e
>> most likely reason for this chechsum mismatch.
>
> Which raises an interesting point: I know reiserfs had its problems
> but it also turned up a lot of machines with bad RAM which contribute=
d
> to giving the fs a bad name. With more and more complicated and memor=
y
> consuming filesystem datastructures being stored in RAM, larger volum=
es
> of RAM in systems, and RAM not really getting any more reliable will
> we ever see a day where something like btrfs is not recommended for
> use in any machine that doesn't have ECC? Does the filesystem do
> anything to protect itself from bad hardware?

Such as the checksums that started this thread?  That *is* a
protection against bad hardware feature.

A large part of reiserfs' problem was a religious degree of "panic on
inconsistency!" so failures of identical severity that might slip by
unnoticed on other file systems were more likely to be noticed. Sadly
shooting the messenger is still a popular sport and the qualities of
BTRFS which make it more bad hardware resistant may well give it a bad
reputation.  I don't know that there is much that can be done about
that.


On Wed, Sep 9, 2009 at 3:01 AM, Jens Axboe<jens.axboe@oracle.com> wrote=
:
> On Wed, Sep 09 2009, Markus Trippelsdorf wrote:
>> What a strange coincidence that it affected git pack files in both c=
ases.
>> It's almost too improbable...
>
> Probably more than a coincidence I think, the question is what though=
=2E..

Could this have been the same data in both cases?  Either way=E2=80=94 =
if the
hardware was randomly corrupting high entropy blocks with very-low
probability it's quite possible that you two would have seen it while
anyone else who did chalked it up to some other problem.

I've encountered telecom equipment where a particular packet data
interacted poorly with the clock recovery hardware. "Any file
transfers fine, except for this one. This one stalls and never
finishes, but if I unzip it. it's fine!". Ugh. or it could be some
busted ECC that always 'corrects' a particular class of perfectly
valid blocks to something wrong... or it could be a million other
things. At the end of the day you just need to accept that the
hardware is junk. Black list it, give the vendor the best black eye
that you can, and move on.

I can only expect that this is going to get worse over time. I really
wish that it had become the norm for drive makers to expose an
optional raw interface to the flash. Alas, we're stuck with the
equivalent of running Linux on a hypervisor provided by Microsoft...
except the SSD makers are less experienced.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
