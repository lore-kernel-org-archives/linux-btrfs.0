From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Free space left
Date: Sat, 16 Jan 2010 20:20:08 +0100
Message-ID: <201001162020.08633.kreijack@libero.it>
References: <20100116164120.47eceecd@simplux> <201001162010.37752.kreijack@libero.it> <20100116201733.1e30dad1@simplux>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100116201733.1e30dad1@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 16 January 2010, you (Dipl.-Ing. Michael Niederle) wrote:
> Hi, Goffredo!
> 
> > Try btrfs-show
> 
> Thanks for your advice!
> 
> btrfs-show works but it displays a lot of error message for non-btrfs 
devices:
> 
> > btrfs-show
> failed to read /dev/sdg
> failed to read /dev/sdg1
> failed to read /dev/sdg2
> failed to read /dev/sdg3
> failed to read /dev/sdg4
> failed to read /dev/md1
> failed to read /dev/fd0
> failed to read /dev/fd0u1440
> failed to read /dev/fd1
> failed to read /dev/hda
> failed to read /dev/hda1
> failed to read /dev/hda10
> failed to read /dev/hda11
> failed to read /dev/hda12
> ...
> failed to read /dev/sr0
> failed to read /dev/sr1
> failed to read /dev/sr2
> failed to read /dev/sr3
> ...
> Label: Alpha4  uuid: 63b82dad-ed81-41f4-910f-7b358ceb77ba
> 	Total devices 1 FS bytes used 11.81GB
> 	devid    1 size 20.01GB used 20.01GB path /dev/sda3
> 
> Btrfs v0.19-4-gab8fb4c
> 
> Even if I try
> 
> btrfs-show /dev/sda3
> 
> I get the same output.
> 
> Greetings, Michael
> 
Yes they search in every block devices a btrfs file-system. It may be 
smarter/faster skipping the floppy and the cd-rom..

BR
G.Baroncelli

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
