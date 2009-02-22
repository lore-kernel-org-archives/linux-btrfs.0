From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: ssd optimised mode
Date: Sun, 22 Feb 2009 11:44:33 -0600
Message-ID: <49A18F01.3090300@austin.ibm.com>
References: <934e480c0902200326m7647d87cq28bfa1675ef012f4@mail.gmail.com>	 <20090220160134.GE24890@unused.rdu.redhat.com>	 <1235147425.13249.16.camel@think.oraclecorp.com> <3a7f57190902211707h37ff1478vdc0e5ffff66fa4da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Dmitri Nikulin <dnikulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a7f57190902211707h37ff1478vdc0e5ffff66fa4da@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Dmitri Nikulin wrote:
> On Sat, Feb 21, 2009 at 3:30 AM, Chris Mason <chris.mason@oracle.com> wrote:
>   
>> The short answer is that in ssd mode we don't try to avoid random reads.
>>     
>
> In the ideal future where SSDs can be run without a flimsy hardware
> FTL, and btrfs can use something like ubi directly, would SSD mode
> also be able to enable more intelligent wear levelling and safer use
> of eraseblocks?
>
> I've read that one of the potentially crippling limitations of ZFS is
> that even its reliability features depend largely on being able to
> perform atomic writes, which are currently impossible (?) on flash
> media where a block has to be erased before it can be updated, clearly
> not an atomic operation. Is there any solution to this that doesn't
> depend on a battery backup? Clearly it's not something a filesystem
> can practically solve.
>
>   
Well this is not really a problem with enterprise class SSD drives.  
They almost all use super capacitors to be able to have enough power to 
flush the dram cache to the nand chips without the need for any external 
battery backup.

Steve
> --
> Dmitri Nikulin
>
> Centre for Synchrotron Science
> Monash University
> Victoria 3800, Australia
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

