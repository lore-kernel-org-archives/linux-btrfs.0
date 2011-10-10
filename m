From: David Sterba <dave@jikos.cz>
Subject: Re: read error: how to fix?
Date: Mon, 10 Oct 2011 13:48:09 +0200
Message-ID: <20111010114809.GH17912@twin.jikos.cz>
References: <BvO7vnJy1uB@helmut.hullen.de>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BvO7vnJy1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 07, 2011 at 06:51:00PM +0200, Helmut Hullen wrote:
> Oct  7 18:16:55 Arktur kernel: ata5.00: exception Emask 0x0 SAct 0x0  
> SErr 0x0 action 0x0
> Oct  7 18:16:55 Arktur kernel: ata5.00: BMDMA2 stat 0x80d2009
> Oct  7 18:16:55 Arktur kernel: ata5.00: failed command: READ DMA
> Oct  7 18:16:55 Arktur kernel: ata5.00: cmd c8/00:40:57:d0:34/00:00:00:00:00/ee tag 0 dma 32768 in
> Oct  7 18:16:55 Arktur kernel:          res 51/40:40:57:d0:34/00:03:0e:00:00/fe Emask 0x9 (media error)
> Oct  7 18:16:55 Arktur kernel: ata5.00: status: { DRDY ERR }
> Oct  7 18:16:55 Arktur kernel: ata5.00: error: { UNC }
> Oct  7 18:16:55 Arktur kernel: ata5.00: configured for UDMA/100
> Oct  7 18:16:55 Arktur kernel: ata5: EH complete
> 
> (repeating every 3 seconds)
> 
> The files contain no valuable data (*.mpeg files, reproducable). But how  
> can I tell the disk not to use the damaged sector(s)?
> 
> On an ext2/3 system I used "badblocks" - is there some comparable tool  
> for btrfs?

No there isn't, but it's a good topic for a btrfs project :)

(I see lots of interesting problems like relocating superblocks, damaged
allocator structures, ...)


david
