From: "Oliver Mattos" <oliver.mattos08@imperial.ac.uk>
Subject: Re: ssd optimised mode
Date: Mon, 23 Feb 2009 09:31:37 -0000
Message-ID: <3BF870F389974F6AA76880C734BF46D2@laptop>
References: <934e480c0902200326m7647d87cq28bfa1675ef012f4@mail.gmail.com>, <20090220160134.GE24890@unused.rdu.redhat.com>, <1235147425.13249.16.camel@think.oraclecorp.com>, <3a7f57190902211707h37ff1478vdc0e5ffff66fa4da@mail.gmail.com>, <49A18F01.3090300@austin.ibm.com>, <3a7f57190902221706l34e8f925m9ef687c1df920123@mail.gmail.com>, <7fe698080902221722q257819aaj4378dfc1509d3c7d@mail.gmail.com>, <3a7f57190902221833i61beb82u38c29dda0eaf5f42@mail.gmail.com> <200902231117406717229@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="gb2312";
	reply-type=original
To: "Seth Huang" <seth.hg@gmail.com>, <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200902231117406717229@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

While this sounds nice in practice, in reality since eraseblocks are 
generally very large, and with hardware based block remapping (FTL), you can 
never be sure which data blocks are at risk when re-writing just one block. 
There is a good chance that rewriting one block of data somewhere will wipe 
out a block of data at a totally different location of the disk.

Since the filesystem has no understanding of the hardware FTL, there isn't 
much that can be done about this at the filesystem level.

The only thing that could be done is metadata mirroring on the same disk, 
but I suspect even that would only marginally improve reliability, since 
both copies of the metadata are likely to be written to storage at nearly 
the same time, they are quite likely to be re-mapped into the same block, 
and then if you loose one, you loose both.

The solution to this is twofold:
1 :- filesystems should be able to detect when a non-atomic write has 
corrupted the filesystem and tell the user - eg. "Filesystem corruption 
found, Likley hardware malfunction detected"  (since with a fs like btrfs, 
when all big software bugs are resolved, the only thing that can cause disk 
corruption are hardware issues)

2 :- Someone who feels this is close to their heart needs to test every big 
brand of SSD and name and shame those where writes are non-atomic - as soon 
as you get this publicised that certain brands of SSD put data at risk, the 
manufacturer will be very fast at resolving it.


----- Original Message ----- 
From: "Seth Huang" <seth.hg@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Sent: Monday, February 23, 2009 3:17 AM
Subject: Re: ssd optimised mode


> On Mon, Feb 23, 2009 at 12:22 PM, Dongjun Shin <djshin90@gmail.com> wrote:
>> A well-designed SSD should survive power cycling and should provide 
>> atomicity
>> of flush operation regardless of the underlying flash operations. I don't 
>> expect
>> that users of SSD have different requirements about atomicity.
>
> A reliable system should be based on the assumption that the underlying 
> parts are unreliable. Therefore, we should do as much as possible to make 
> sure the reliability in our filesystem instead of leaning on the SSDs.
>
> -- 
> Seth Huang
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

