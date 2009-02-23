From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: ssd optimised mode
Date: Mon, 23 Feb 2009 11:40:29 -0500
Message-ID: <yq1wsbht8ci.fsf@sermon.lab.mkp.net>
References: <934e480c0902200326m7647d87cq28bfa1675ef012f4@mail.gmail.com>
	<20090220160134.GE24890@unused.rdu.redhat.com>
	<1235147425.13249.16.camel@think.oraclecorp.com>
	<3a7f57190902211707h37ff1478vdc0e5ffff66fa4da@mail.gmail.com>
	<49A18F01.3090300@austin.ibm.com>
	<3a7f57190902221706l34e8f925m9ef687c1df920123@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Dmitri Nikulin <dnikulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a7f57190902221706l34e8f925m9ef687c1df920123@mail.gmail.com> (Dmitri Nikulin's message of "Mon\, 23 Feb 2009 12\:06\:38 +1100")
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Dmitri" == Dmitri Nikulin <dnikulin@gmail.com> writes:

Dmitri> That's excellent, but until consumer-level drives have the same
Dmitri> feature, the fact remains that consumer SSDs are a net loss in
Dmitri> reliability compared to consumer rotating disks,

My SSD testing has not been very promising in the data integrity
department.  I've got a couple of drives here which end up corrupting
stuff every time they are reset or lose power.

"Stuff" in this case is on the order of megabytes, not a few sectors
like on spinning media.  With disk drives the risk of garbling unrelated
files is there but relatively small.  On SSDs it's much higher because
of the big blocking and the high latency erase/rewrite cycle.  In
several cases I've lost system binaries that obviously weren't being
written when I crashed the system.  In one case I even lost all of
/sbin.


Dmitri> I'm just curious if there's anything that can be done in a
Dmitri> filesystem to minimise the damage of a lost eraseblock.

The problem is that we have no way of knowing what's inside each erase
block.  We don't even know how big the erase block is.

-- 
Martin K. Petersen	Oracle Linux Engineering

