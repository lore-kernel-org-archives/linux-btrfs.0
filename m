From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: RAID-10 arrays built with btrfs & md report 2x difference in available size?
Date: Sat, 30 Jan 2010 14:29:46 +0100
Message-ID: <201001301429.46634.kreijack@libero.it>
References: <048D5581-1D1D-4F82-9FE3-0DBC1106EDB4@kupper.org> <c67eed301001291553m8d59819oaab942b42e10c35d@mail.gmail.com> <201001301424.25481.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001301424.25481.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 30 January 2010, Goffredo Baroncelli wrote:
> On Saturday 30 January 2010, 0bo0 wrote:
> 
> > Is the goal NOT to accurately represent the actual available space?
> > Seems rather odd that users are simply to know/accept that "available
> > space" in btrfs RAID-10 != "available space" in md RIAD-10 ...
> 
> As reported more time in this ML, btrfs is able to store the data in 
> striping/raid1 mode per-file-basis. 
> 
> The space on the disk is grouped in chunk. The raid mode is set per-chunk-
> basis [1]. So a file stored in a chunk may be written two times (in one or 
two 
> different disk), and another file stored in another chunk may be written 
with 
> a different policy.


Sorry, I forgot the reference:
[1] http://btrfs.wiki.kernel.org/index.php/Multiple_Device_Support

> 
> In fact the btrfs store the data in "raid0" mode, and the metadata in raid1 
> mode, even with only one disk. Even tough the words "raid1/0" are incorrect 
> with only one disk.
> 
> So key points are:
> - it is incorrect to say that the btrfs filesystem is configured in raidX 
mode
> - it is correct that the file xyz is stored in raidX mode
> - is quite simple to evaluate the space available. It is more complex to 
> evaluate before the file creation how many of the space available a file of 
a 
> certain size consumes.
> - unfortunately, today are not available tools that permits to manage the 
raid 
> mode of a file
> 
> BR
> G.Baroncelli
> 
> 
> 
> -- 
> gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack inwind 
it>
> Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
