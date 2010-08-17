From: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: 2.6.36-rc1 btrfs still unstable
Date: Tue, 17 Aug 2010 13:57:26 +0200
Message-ID: <20100817115726.GA338@Pilar.aei.mpg.de>
References: <1281948382.1888.7.camel@chotu>
 <20100816121658.GT3315@think>
 <7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5BC@mail.corp.imt-systems.com>
 <m3iq3a4l46.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Morten P.D. Stevens" <mstevens@imt-systems.com>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3iq3a4l46.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mo 16.Aug'10 at 11:45:29 -0400, Chris Ball wrote:
> 
>    Note that Btrfs does not yet have a fsck tool that can fix errors.
>    While Btrfs is stable on a stable machine, it is currently possible
>    to corrupt a filesystem irrecoverably if your machine crashes or
>    loses power.  This will be fixed when the fsck tool is ready.

Shouldn't this (surprising) information be in the kernel config option too?

I am testing a btrfs /home on my laptop since January 2010, and somehow
I missed this particular risk. As I knew about the others, I do backups
almost everyday, but anyway.

