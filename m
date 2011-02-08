From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: Error mounting multi-device fs after restart
Date: Tue, 8 Feb 2011 22:04:26 +0100
Message-ID: <20110208210426.GA2564@scooter>
References: <AANLkTi=vSb0i-joekFrZRmwcAE+5w8FwV2FFWcbMvC6n@mail.gmail.com>
 <AANLkTikkUFDTiGqRkMk-VtvxSFS3vNGp0QCn=HPef89V@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Diwaker Gupta <diwaker@maginatics.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikkUFDTiGqRkMk-VtvxSFS3vNGp0QCn=HPef89V@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I can't help you with your problem, but:

It is a really really really bad idea to store data without a backup on a filesystem
that is still in some kind of alpha stadium (don't understand me wrong, I like btrfs
and you guys do a really good job. But the lack of a working fsck keeps btrfs in that
stadium in my eyes).
I can't believe there are ppl out there who do that stupid things :/


Felix


On 08. February 2011 - 12:25, Diwaker Gupta wrote:
> Date:	Tue, 8 Feb 2011 12:25:55 -0800
> From: Diwaker Gupta <diwaker@maginatics.com>
> To: linux-btrfs@vger.kernel.org
> Subject: Re: Error mounting multi-device fs after restart
> 
> Help, anyone? Sorry for the quick repost, but there was some important
> data on that filesystem that I don't have a backup for. I'd really
> appreciate any pointers that can help recover the data.
> 
> Searching through the archives, it seems others have faced similar
> issues due to sudden power outages. AFAIK we did not have any power
> outage.
> 
> I've run badblocks on all of the 10 drives and three of them had a few
> bad blocks. I'm inclined to rule out bad disks as the root cause. In
> any case, isn't this exactly the kind of situation btrfs should
> protect users against?
> 
> A 'btrfsck' aborts on all of the drives. I've tried running it with
> '-s 1' as well as '-s 2' with no success. Does that mean that none of
> the drives have any copy of the superblock intact?
> 
> Diwaker
> 
> On Mon, Feb 7, 2011 at 11:46 AM, Diwaker Gupta <diwaker@maginatics.com> wrote:
> > Hello,
> >
> > We have 10 1-TB drives hosting a multi-device btrfs filesystem,
> > configured with raid1+0 for both data and metadata. After some package
> > upgrades over the weekend I restarted the system and it did not come
> > back up afterwards. I booted using a rescue disk and ran btrfsck (next
> > branch from Chris's git repository). Unfortunately btrfsck aborts on
> > every single drive with errors like this:
> >
> > parent transid verify failed on 12050980864 wanted 377535 found 128327
> > parent transid verify failed on 12074557440 wanted 422817 found 126691
> > parent transid verify failed on 12057542656 wanted 422786 found 126395
> > parent transid verify failed on 12075556864 wanted 423004 found 126691
> > bad block 12095545344
> > parent transid verify failed on 12079190016 wanted 422826 found 105147
> > leaf parent key incorrect 12097544192
> > bad block 12097544192
> >
> > I'm running 10.04 Ubuntu Lucid with the lts-backport x86_64 kernel:
> > 2.6.35-23-server
> >
> > Attempting to mount the filesystem blocks indefinitely, with
> > /var/log/messages getting filled with the 'parent transid verify'
> > errors.
> >
> > IIUC the 'btrfs-select-super' utility is not really helpful in our
> > case. At this point, my only priority is to somehow rescue the data
> > from the filesystem. I'd really appreciate if someone on the list
> > could help me out.
> >
> > I'm happy to provide any other information required. Please CC me on
> > replies as I'm not subscribed to the list.
> >
> > Thanks,
> > Diwaker
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
