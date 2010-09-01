From: Alexander Vdovichev <ext-alexander.vdovichev@nokia.com>
Subject: Re: Question about specific patch (eMMC)
Date: Wed, 01 Sep 2010 11:31:59 +0300
Message-ID: <1283329919.3347.17.camel@calladain.research.nokia.com>
References: <1283255825.3347.4.camel@calladain.research.nokia.com>
	 <20100831172715.GA14509@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: ext Tomasz Torcz <tomek@pipebreaker.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100831172715.GA14509@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
On Tue, 2010-08-31 at 19:27 +0200, ext Tomasz Torcz wrote:
> On Tue, Aug 31, 2010 at 02:57:05PM +0300, Alexander Vdovichev wrote:
> > Hello all,
> > Is there any patches for btrfs to use enhanced area in eMMC (it will
> > allow to boost performance i.e. it very useful to keep metadata within
> > this area) ?
> > 
> > If it's exist let me know how to find it and use it.
> 
>   I'm not aware of this at the moment.  However, there are data-temperature
> tracking patches.  Their point is to move hot data into faster storage.
Could you point me where I can find it ?
> I believe they can grow into generic infrastructure to inform filesystems
> about non-homogenous nature of underlaying storage.
I guess that it will require specific patches to the filesystem.
Each filesystem has a specific policy to locate metadata, but most
manufacturers believe that the device will use fat filesystem and they
creates special areas to keep fat metadata (allocation table).
If btrfs will has an option to use this area it will be a good advantage
to use it in embedded area.

Thanks,



