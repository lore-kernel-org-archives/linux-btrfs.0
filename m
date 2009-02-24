From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: ssd optimised mode
Date: Tue, 24 Feb 2009 11:16:12 +1100
Message-ID: <3a7f57190902231616h15578ceal968c190b10a40157@mail.gmail.com>
References: <934e480c0902200326m7647d87cq28bfa1675ef012f4@mail.gmail.com>
	 <20090220160134.GE24890@unused.rdu.redhat.com>
	 <1235147425.13249.16.camel@think.oraclecorp.com>
	 <3a7f57190902211707h37ff1478vdc0e5ffff66fa4da@mail.gmail.com>
	 <1235399593.11205.15.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1235399593.11205.15.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 24, 2009 at 1:33 AM, Chris Mason <chris.mason@oracle.com> wrote:
> On Sun, 2009-02-22 at 12:07 +1100, Dmitri Nikulin wrote:
>> On Sat, Feb 21, 2009 at 3:30 AM, Chris Mason <chris.mason@oracle.com> wrote:
>> > The short answer is that in ssd mode we don't try to avoid random reads.
>>
>> In the ideal future where SSDs can be run without a flimsy hardware
>> FTL, and btrfs can use something like ubi directly, would SSD mode
>> also be able to enable more intelligent wear levelling and safer use
>> of eraseblocks?
>
> I think this kind of future is less and less likely.  SSD makers are
> going to differentiate themselves via their FTL, and they are not going
> to give the OS the chance to mess around with the flash directly.
>
> There will surely be exceptions, but I don't think we're going to find
> them in a dell any time soon.

Already SanDisk are offering a proprietary "Extreme FFS" (perhaps even
based on Unix FFS) for Windows Vista only.
http://www.technewsworld.com/story/65072.html?wlc=1235097496&wlc=1235434234
It is not clear whether this is purely a filesystem which could work
on any SSD, but I think it is much more likely it has an FTL bypass
that lets it get higher performance than any FTLed filesystem. <RMS>It
is proprietary from the ground up and products like these could undo
the decades of standardisation and interoperability that have made
hard disks and their controllers a commodity. </RMS>

> I'm sure that some early flash drives got this wrong, but the crummy
> drives will eventually drop out of the market as the reliable ones gain
> traction.

I'm glad to see this is the trend. I would like nothing more than to
not have to care about the SSD being an SSD. Right now it seems you do
have to care to get good performance and longevity, but if you can
just treat them as a regular disk for the most part, that is a very
valuable product even worth the exorbitant price tags. Personally I'm
happy as long as I can make one big PV (or RAID0 then a PV) and have
that perform well with minimum tweaking. If I can use btrfs as a RAID
and volume manager and have that perform even better on the SSD, all
the better :)

-- 
Dmitri Nikulin

Centre for Synchrotron Science
Monash University
Victoria 3800, Australia
