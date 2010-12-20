From: Andy Isaacson <adi@hexapodia.org>
Subject: Re: btrfs: 21 minutes to read 1.2M file directory
Date: Mon, 20 Dec 2010 15:24:51 -0800
Message-ID: <20101220232451.GA9755@hexapodia.org>
References: <20101220222446.GA8629@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101220222446.GA8629@hexapodia.org>
List-ID: <linux-btrfs.vger.kernel.org>

Sigh, wrong btrfs address on the original.  Apologies for the
double-post.

On Mon, Dec 20, 2010 at 02:24:46PM -0800, Andy Isaacson wrote:
> I have a directory with 1.2M files in it, which makes readdir very slow
> on btrfs with cold caches (although it's reasonably fast with hot caches
> as in the first example below):
> 
> % time find /btr/foo > /btr/foo.list
> find /btr/foo > /btr/foo.list  4.10s user 7.97s system 36% cpu 33.275 total
> % head /btr/foo.list
> /btr/foo
> /btr/foo/1281373625.777.fg.jpg
> /btr/foo/1281373625.777.bg.jpg
> /btr/foo/1281373625.948.fg.jpg
> /btr/foo/1281373625.948.bg.jpg
> /btr/foo/1281373626.096.fg.jpg
> /btr/foo/1281373626.096.bg.jpg
> /btr/foo/1281373626.218.fg.jpg
> /btr/foo/1281373626.218.bg.jpg
> /btr/foo/1281373626.350.fg.jpg
> % wc !$
> wc /btr/foo.list
>  12166666  12166666 401499940 /btr/foo.list
> % wc -l /btr/foo.list
> 12166666 /btr/foo.list
> % sudo sysctl -w vm.drop_caches=3 vm.drop_caches=0
> vm.drop_caches = 3
> vm.drop_caches = 0
> % time find /btr/foo > /btr/foo.list.2
> find /btr/foo > /btr/foo.list.2  5.62s user 24.54s system 2% cpu 21:40.90 total
> % uname -a
> Linux pyron 2.6.36-rc7-00149-g29979aa #71 SMP Wed Oct 13 09:42:57 PDT 2010 x86_64 GNU/Linux
> 
> Interestingly, while readdir is busy I'm only seeing IO on sdb even
> though the btrfs is on 3 targets:
> 
> Label: btr  uuid: 1271de53-b3d2-4d68-9d48-b19487e1c982
>         Total devices 3 FS bytes used 555.13GB
>         devid    1 size 18.65GB used 18.64GB path /dev/sda2
>         devid    3 size 512.00GB used 44.13GB path /dev/sdc1
>         devid    2 size 512.00GB used 511.76GB path /dev/sdb1
> 
> "iostat -k 1 | grep sdb" tells me:
> 
> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> 
> sdb             173.00       692.00         0.00        692          0
> sdb             185.00       740.00         0.00        740          0
> sdb             198.00       792.00         0.00        792          0
> sdb             177.00       712.00         0.00        712          0
> 
> I updated to a recent git and it's still slow (my test hasn't completed
> yet 19 minutes in):
> 
> Linux pyron 2.6.37-rc6-11882-g55ec86f #72 SMP Mon Dec 20 13:34:38 PST 2010 x86_64 GNU/Linux
> 
> The devices are:
> 
> [    1.834527] ata1.00: ATA-7: INTEL SSDSA2M040G2GC, 2CV102HD, max UDMA/133
> [    1.834816] ata1.00: 78165360 sectors, multi 1: LBA48 NCQ (depth 31/32)
> [    1.835369] ata1.00: configured for UDMA/133
> [    1.835776] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2M040 2CV1 PQ: 0 ANSI: 5
> ...
> [    2.904919] ata3.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
> [    2.905206] ata3.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    2.947393] ata3.00: configured for UDMA/133
> [    2.947850] scsi 2:0:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
> ...
> [    3.989664] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    4.018524] ata5.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
> [    4.018811] ata5.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    4.060838] ata5.00: configured for UDMA/133
> [    4.061205] scsi 4:0:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
> 
> The host is a "Intel(R) Core(TM) i7 CPU 930 @2.80GHz" with 12GB RAM.
> 
> Thanks,
> -andy
