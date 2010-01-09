From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: How to mount a subvolume?
Date: Sat, 9 Jan 2010 21:07:37 +0100
Message-ID: <201001092107.38133.kreijack@libero.it>
References: <20100109150757.1051fd79@simplux>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100109150757.1051fd79@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 09 January 2010, Dipl.-Ing. Michael Niederle wrote:
> First thanks alot to Kay and Goffredo!
> 
> But I have another question.
> 
> I read that the current tools cannot display subvolumes, but one should 
still
> be able to mount them. If I try I get an error message:
> 
> > mount -t btrfs -o subvol=root.2010-01-07 /dev/sda3 /save
> mount: /dev/sda3 is not a valid block device
> 
> root.2010-01-07 is a snapshot of the /root-directory
> 
> /save is an empty directory used for mounting backups
> 
> taken (successfully) with the following command:
> 
> > btrfsctl -s root.2010-01-07 /root
> 
> What am I doing wrong? Isn't it possible to mount the whole filesystem and a
> subvolume at the same time?

It is possible. I do that on my machine. The magic part is that the 
subvolume/snapshot (are the same thing) has to be under the / of the 
filesystem.

  ghigo@arakne:/tmp$ mkdir test 
  ghigo@arakne:/tmp$ mkdir test-snap
  ghigo@arakne:/tmp$ sudo mount -o /dev/sdc test
  ghigo@arakne:/tmp$ mount | grep btrfs                  
  /dev/sdc on /tmp/test type btrfs (rw)
  ghigo@arakne:/tmp$ cd test                    
  ghigo@arakne:/tmp/test$ sudo mkdir a
  ghigo@arakne:/tmp/test$ sudo btrfsctl -s a/snap-on-subdir .
  operation complete
  Btrfs Btrfs v0.19
  ghigo@arakne:/tmp/test$ sudo btrfsctl -s snap-of-root .
  operation complete
  Btrfs Btrfs v0.19
  ghigo@arakne:/tmp/test$ cd ..
  ghigo@arakne:/tmp$ sudo mount -o subvol=snap-on-subdir  /dev/sdc test-snap/
  mount: /dev/sdc is not a valid block device
  ghigo@arakne:/tmp$ sudo mount -o subvol=snap-of-root  /dev/sdc test-snap/
  ghigo@arakne:/tmp$ mount | grep btrfs
  /dev/sdc on /tmp/test type btrfs (rw)
  /dev/sdc on /tmp/test-snap type btrfs (rw,subvol=snap-of-root)

Note:
- both the root of the btrfs filesystem and its snapshot are mounted at the 
same time
- if a subvolume/snapshot not placed in the root is mounted an error is 
returned (/dev/sdX is not a valid block device)

> Greetings, Michael

Goffredo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
