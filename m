From: Chris Mason <chris.mason@oracle.com>
Subject: Re: fstrim on BTRFS
Date: Tue, 3 Jan 2012 16:05:36 -0500
Message-ID: <20120103210536.GJ6262@shiny>
References: <201112281757.16019.Martin@lichtvoll.de>
 <4EFBE668.7030800@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
	linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EFBE668.7030800@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 29, 2011 at 12:02:48PM +0800, Li Zefan wrote:
> Martin Steigerwald wrote:
> > Hi!
> > 
> > With 3.2-rc4 (probably earlier), Ext4 seems to remember what areas it 
> > trimmed:
> > 
> > merkaba:~> fstrim -v /boot
> > /boot: 224657408 bytes were trimmed
> > merkaba:~> fstrim -v /boot
> > /boot: 0 bytes were trimmed
> > 
> > 
> > But BTRFS does not:
> > 
> > merkaba:~> fstrim -v /
> > /: 4431613952 bytes were trimmed
> > merkaba:~> fstrim -v /    
> > /: 4341846016 bytes were trimmed
> > 
> > 
> > Is it planned to add this feature to BTRFS as well?
> > 
> 
> There's no such plan, but it's do-able, and I can take care of it.
> There's an issue though.
> 
> Whether we want to store TRIMMED information on disk? ext4 doesn't
> do this, so the first fstrim will be slow though you've done fstrim
> in previous mount.

I'd rather not store the trim status on disk.  The extra trims
don't have a huge cost, and since some devices have a large granularity
for trims, they may ignore the trim until it tosses a larger contiguous
area of the disk.

I'd be fine with a flag to the in-memory free extent struct that
indicates if it has been trimmed down to the device.

-chris
