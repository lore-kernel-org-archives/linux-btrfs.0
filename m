From: Dongjun Shin <djshin90@gmail.com>
Subject: Re: ssd optimised mode
Date: Mon, 23 Feb 2009 10:22:29 +0900
Message-ID: <7fe698080902221722q257819aaj4378dfc1509d3c7d@mail.gmail.com>
References: <934e480c0902200326m7647d87cq28bfa1675ef012f4@mail.gmail.com>
	 <20090220160134.GE24890@unused.rdu.redhat.com>
	 <1235147425.13249.16.camel@think.oraclecorp.com>
	 <3a7f57190902211707h37ff1478vdc0e5ffff66fa4da@mail.gmail.com>
	 <49A18F01.3090300@austin.ibm.com>
	 <3a7f57190902221706l34e8f925m9ef687c1df920123@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Dmitri Nikulin <dnikulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a7f57190902221706l34e8f925m9ef687c1df920123@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 23, 2009 at 10:06 AM, Dmitri Nikulin <dnikulin@gmail.com> wrote:
> On Mon, Feb 23, 2009 at 4:44 AM, Steven Pratt <slpratt@austin.ibm.com> wrote:
>> Well this is not really a problem with enterprise class SSD drives.  They
>> almost all use super capacitors to be able to have enough power to flush the
>> dram cache to the nand chips without the need for any external battery
>> backup.
>
> That's excellent, but until consumer-level drives have the same
> feature, the fact remains that consumer SSDs are a net loss in
> reliability compared to consumer rotating disks, where by their
> marketing material they should be a gain. That's an issue with SSDs in
> general and certainly no fault of btrfs, I'm just curious if there's
> anything that can be done in a filesystem to minimise the damage of a
> lost eraseblock. In fact, will metadata mirroring solve this for us
> already, or does that still not handle failures in some "critical"
> blocks at the root of a filesystem?
>

A well-designed SSD should survive power cycling and should provide atomicity
of flush operation regardless of the underlying flash operations. I don't expect
that users of SSD have different requirements about atomicity.

The existence of super capacitors may help increasing the performance
as well as the reliability of data. However, that should not be the necessary
condition for the atomicity.

-- 
Dongjun
