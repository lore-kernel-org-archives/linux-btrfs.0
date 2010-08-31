From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: remote mirroring in the works?
Date: Tue, 31 Aug 2010 20:29:06 +0200
Message-ID: <201008312029.06424.kreijack@libero.it>
References: <AANLkTinmSdHwXXq3s64sM39GjacafgwgTjPadZGHuway@mail.gmail.com> <AANLkTimNOqfQHwPmJk4mQUsFOwORHtZvyZ_8QZ5om=wT@mail.gmail.com> <20100831063841.GF29552@hostway.ca>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100831063841.GF29552@hostway.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, 31 August, 2010, Simon Kirby wrote:
[...]
> Anyway, there _is_ this interface:
> 
> 	btrfs subvolume find-new <path> <last_gen>
> 		List the recently modified files in a filesystem.
> 
> Eg:
> 
> 	btrfs sub find-new /mnt 0
> 
> This should print all files on the file system, and the last transaction
> ID marker.  This can be used to call the interface again, which lists
> only new changed things since that ID.
  ^^^^

It is not fully correct. In fact Chris Mason says

(from http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04620.html)


Chris> When we find an inode in the output, it doesn't mean that inode has
Chris> changed.  It just means the btree block holding that inode has 
changed.
Chris> So we'll want to add limiting based on the ctime/mtime of the inode as
Chris> well.

So even tough this command definitely helps, false positives may happen. 
And moreover an empty file is not detected (I think because the file doesn't 
have associated data). But I think that this may be easily corrected.

Regards
G.Baroncelli

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
