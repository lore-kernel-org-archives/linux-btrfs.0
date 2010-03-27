From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Missing entry for updated directory
Date: Sat, 27 Mar 2010 23:13:08 +0100
Message-ID: <201003272313.08817.kreijack@libero.it>
References: <20100327120420.28af24dd@simplux> <201003272047.30636.kreijack@libero.it> <20100327221953.35781dcd@simplux>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>,
	"Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100327221953.35781dcd@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Michael,

it seems that the generation number of an inode is the generation number at  
creation time of the inode.

I fear that even though is possible to detect an extent update, looking at the 
generation number, it is impossible to detect a inode update.

Chris, could help us to understand better that ?
Thanks


BR
Goffredo

On Saturday 27 March 2010, Dipl.-Ing. Michael Niederle wrote:
> Hi, Goffredo!
> 
> I checked all btrfs-item types (changed sk->max_type to 255 and removed the
> filtering) connected with the updated directory's inode.
> 
> But none of them had got a new generation number.
> 
> I found the missing directory only using a more conventional tool that 
checked
> all files and directories in both snapshots.
> 
> Here the output from stat:
> 
> >stat 2010-03-21/root/.googleearth/Temp/.kmztmp/
>   File: `2010-03-21/root/.googleearth/Temp/.kmztmp/'
>   Size: 21340     	Blocks: 0          IO Block: 4096   directory
> Device: 15h/21d	Inode: 31757       Links: 1
> Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2010-02-19 22:12:25.339932662 +0100
> Modify: 2009-11-18 13:45:52.000000000 +0100
> Change: 2010-01-12 19:48:01.911913031 +0100
> 
> >stat 2010-03-22/root/.googleearth/Temp/.kmztmp/
>   File: `2010-03-22/root/.googleearth/Temp/.kmztmp/'
>   Size: 21268     	Blocks: 0          IO Block: 4096   directory
> Device: 16h/22d	Inode: 31757       Links: 1
> Access: (0755/drwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
> Access: 2010-02-19 22:12:25.339932662 +0100
> Modify: 2010-03-21 21:49:16.512553912 +0100
> Change: 2010-03-21 21:49:16.512553912 +0100
> 
> Greetings, Michael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
