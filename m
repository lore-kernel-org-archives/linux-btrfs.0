From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: btrfs subvol find-modified
Date: Fri, 26 Mar 2010 23:23:08 +0100
Message-ID: <201003262323.08270.kreijack@libero.it>
References: <20100326111807.24dcc2f0@simplux> <201003262136.32330.kreijack@libero.it> <20100326211124.GK13680@think>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: Chris Mason <chris.mason@oracle.com>,
	"Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100326211124.GK13680@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 26 March 2010, Chris Mason wrote:

> In general, the end goal is backing up a snapshot the changes from a
> point in time to right now.  We don't actually need a snapshot to do
> this, we just need the generation number and (optionally) a timestamp.

I think that backup the difference between two snapshot has a big advantage: 
the snapshot is a coherent state.

For example what if we are doing a backup during a package installation or 
during a database working ? The risk is to take some files from an old "state" 
and other files from a new "state"...


> 
> So, we could store these things into a state file that gets fed into the
> next backup, but I'd like to keep a command that can print them as well.
> 
> -chris
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
