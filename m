From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Free space left
Date: Sat, 16 Jan 2010 21:01:23 +0100
Message-ID: <201001162101.23321.kreijack@inwind.it>
References: <20100116164120.47eceecd@simplux> <201001162010.37752.kreijack@libero.it> <m3tyulq1dg.fsf@mobydick.mine.nu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: "Mathieu Chouquet-Stringer" <mchouque@free.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3tyulq1dg.fsf@mobydick.mine.nu>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 16 January 2010, Mathieu Chouquet-Stringer wrote:
>         Hello,
> 
> kreijack@gmail.com (Goffredo Baroncelli) writes:
> > Try btrfs-show
> > [...]
> 
> How do you read this then:
> 
> Label: none  uuid: 27fafa43-7ad0-4e8a-ada8-36f73ef8984c
>         Total devices 2 FS bytes used 79.63GB
>         devid    2 size 111.79GB used 111.01GB path /dev/sdb
>         devid    1 size 111.79GB used 111.03GB path /dev/sda
> 
> I'm pretty sure I created this fs with -d raid1 -m raid1!  Speaking
> of which, is there a way to read a FS configuration: how can I tell
> this FS really uses raid1 for both data and metadata?

Even tough the raid mode is set per filesystem, btrfs has (will have) the 
capability to set the raid level per file. So it is no simple to estimate the 
free space: if every file is raid1 the real free space is half of the physical 
free space. But if some file are in raid1 (for examples /etc) and others are 
in raid0 (for example the ones under /usr which may be re-downloaded) the used 
space and the free space are difficult to estimate.

There are some efforts to fix this kind of situation (see the thread "[PATCH] 
Btrfs-progs: add btrfsctl -i to print space info").

> The used column is surprising: if it's a mirror why 111.01 and
> 111.03?  And why all the space is being used anyway: I mean what's
> the difference between the 79.63GB and 111.0[13]?
> 
> And the output of df is confusing too:
> /dev/sdb             234441648  83501968 150939680  36% /space
> 
> It's reporting twice the total space but I think I remember looking
> it up and that should be fixed in a future kernel version.
> -- 
> Mathieu Chouquet-Stringer                           mchouque@free.fr
>             The sun itself sees not till heaven clears.
> 	             -- William Shakespeare --
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
