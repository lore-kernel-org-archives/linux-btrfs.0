From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel bug in file-item.c
Date: Wed, 29 Apr 2009 14:40:19 -0400
Message-ID: <1241030419.20099.55.camel@think.oraclecorp.com>
References: <49F73F69.4010205@oel.state.nj.us>
	 <1240946633.15136.55.camel@think.oraclecorp.com>
	 <49F87A7F.7090804@oel.state.nj.us>
	 <1241027618.20099.48.camel@think.oraclecorp.com>
	 <49F89AB4.2090001@oel.state.nj.us>
	 <1241029841.20099.53.camel@think.oraclecorp.com>
	 <49F89E91.3020604@oel.state.nj.us>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: mroconnor@oel.state.nj.us
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49F89E91.3020604@oel.state.nj.us>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-04-29 at 14:38 -0400, Marc R. O'Connor wrote:
> > 
> >> I have done that on all btrfs partitions I have and btrfsck did not
> >> return anything odd.
> >>
> > 
> > In that case, the bad ordering is being introduced at run time.  Could
> > you please run memtest86 on the box?
> > 
> > -chris
> > 
> > 
>  memtest comes back with two errors very early on then reboots the
> sysrescueCD. :(

Well, then I'm surprised btrfs doesn't crash more violently and more
often ;)

Do you think you're hitting a memtest bug or is the HW really bad?

-chris




