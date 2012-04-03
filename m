From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: do not mount when we have a sectorsize unequal to PAGE_SIZE
Date: Tue, 3 Apr 2012 15:18:21 +0200
Message-ID: <20120403131821.GE14256@twin.jikos.cz>
References: <1333418213-2718-1-git-send-email-liubo2009@cn.fujitsu.com> <20120403080659.GF1084@x2.net.home> <4F7AB650.3000108@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Karel Zak <kzak@redhat.com>, linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F7AB650.3000108@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 03, 2012 at 04:35:28PM +0800, Liu Bo wrote:
> >  That's strange. Does it mean that if I create the filesystem and then
> >  reboot to another kernel with different PAGE_SIZE then the filesystem
> >  is unaccessible for me?
> 
> I'm afraid yes until we can deal with sectorsize and PAGE_SIZE
> gracefully.
> 
> For now, I didn't test if a read will cause oops or not, but if it's
> ok, an alternative way is to make FS readonly.

Writes will cause hang. I have tested that read-only mount of a 64k
sectorsize is ok, file reads do not hang, but any file larger than the
inline limit is empty due to failed csums.

Example read of

65483 ./drivers/scsi/qla2xxx/qla_isr.c

leads to

[ 9249.370133] btrfs csum failed ino 13837 off 0 csum 4169121208 private 3722900035

while reading

65471 ./arch/powerpc/platforms/cell/spufs/file.c

is just fine.

So for now even forcing a read-only mount is not good option, though we
may try to enhance the csum verification.


david
