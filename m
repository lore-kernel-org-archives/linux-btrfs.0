From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: SSD Optimizations
Date: Fri, 12 Mar 2010 10:15:28 +0100
Message-ID: <20100312101528.8e87810f.skraw@ithnet.com>
References: <4B97F7CE.4030405@bobich.net>
	<0592c2cb505638c1110eaef97192eb60@localhost>
	<20100311161932.GH6509@think>
	<201003120207.40740.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>,
	Gordan Bobic <gordan@bobich.net>, linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003120207.40740.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 12 Mar 2010 02:07:40 +0100
Hubert Kario <hka@qbs.com.pl> wrote:

> > [...]
> > If the FS were to be smart and know about the 256kb requirement, it
> > would do a read/modify/write cycle somewhere and then write the 4KB.
> 
> If all the free blocks have been TRIMmed, FS should pick a completely free 
> erasure size block and write those 4KiB of data.
> 
> Correct implementation of wear leveling in the drive should notice that the 
> write is entirely inside a free block and make just a write cycle adding zeros 
> to the end of supplied data.

Your assumption here is that your _addressed_ block layout is completely
identical to the SSDs "disk" layout. Else you cannot know where a "free
erasure block" is located and how to address it from FS.
I really wonder what this assumption is based on. You still think a SSD is a
true disk with linear addressing. I doubt that very much. Even on true
spinning disks your assumption is wrong for relocated sectors. Which basically
means that every disk controller firmware fiddles around with the physical
layout since decades. Please accept that you cannot do a disks' job in FS. The
more advanced technology gets the more disks become black boxes with a defined
software interface. Use this interface and drop the idea of having inside
knowledge of such a device. That's other peoples' work. If you want to design
smart SSD controllers hire at a company that builds those.

-- 
Regards,
Stephan
