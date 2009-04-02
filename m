From: Chris Mason <chris.mason@oracle.com>
Subject: Re: interesting use case for multiple devices and delayed raid?
Date: Thu, 02 Apr 2009 07:27:16 -0400
Message-ID: <1238671636.27540.8.camel@think.oraclecorp.com>
References: <1238577447.9099.150.camel@pc.interlinx.bc.ca>
	 <3a7f57190904010313q230f004chf7db770bb1169daa@mail.gmail.com>
	 <gr0kt0$t9l$3@ger.gmane.org>
	 <3a7f57190904012241y40f7a906x3edd1ad8002c3208@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Dmitri Nikulin <dnikulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a7f57190904012241y40f7a906x3edd1ad8002c3208@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-04-02 at 16:41 +1100, Dmitri Nikulin wrote:
> On Thu, Apr 2, 2009 at 8:04 AM, Brian J. Murrell <brian@interlinx.bc.ca> wrote:
> >> A more complete solution, that requires no software changes, would be
> >> to have 3 or 4 disks. A stripe for really fast reads and writes, and
> >> another disk (or another stripe) to act as a slave to the data being
> >> written to the primary stripe. This seems to do what you want, at a
> >> small price premium.
> >
> > No.  That's not really what I am describing at all.
> 
> Well you get the bandwidth of 2 disks when reading and writing, and
> still mirrored to a second stripe as time permits. Kind of like
> delayed RAID10.
> 
> > I apologize if my original description was unclear.  Hopefully it is
> > more so now.
> 
> Yes. It'll be up to the actual filesystem devs to weigh in on whether
> it's worth implementing.
> 

It's an interesting idea, but I think we've got fast front end devices
higher up on the todo list.  That will still support the destaging to
slower disks idea, but will be more flexible overall.

-chris


