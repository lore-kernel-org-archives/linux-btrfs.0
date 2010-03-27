From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Missing entry for updated directory
Date: Sat, 27 Mar 2010 20:47:30 +0100
Message-ID: <201003272047.30636.kreijack@libero.it>
References: <20100327120420.28af24dd@simplux>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100327120420.28af24dd@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 27 March 2010, Dipl.-Ing. Michael Niederle wrote:
> I'm using BTRFS_DIR_INDEX_KEY as suggested by Chris to find all updated
> directories.
> 
> But I'm missing one:
> 
> The directory has 3 entries deleted and stat shows different
> mtimes and ctimes for the directory in the two snapshots.
> 
> The highest generation number in the older snapshot is 82623.
> 
> But the generation number of the updated directory is 31758 in both 
snapshots.
> 


I am not an export of the internal btrfs structure, but reading btrfs-print.c 
it seems to me:
- the mtimes and ctimes are stored in the INODE_ITEM; 
- the INODE_ITEM has an own generator
- the DIR_INDEX doesn't have a own generator; they store only the filename, so 
it may be not updated if the inode is updated. 
- On the basis of what Chris said, it seems that the generator for this kind 
of object (DIR_INDEX) is the generator of the block which may included other 
changes..

The notes above may explain the observed behaviour. But these are only my 
hypothesis. 


Goffredo

> Greetings, Michael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
