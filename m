From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: snapshots changed behavior
Date: Fri, 21 Oct 2011 20:43:37 +0200
Message-ID: <4489587.KaadkGf3Et@venice>
References: <4EA19E66.2020102@webstarts.com> <38803013.ZrEk6jGlKT@venice> <4EA1B9F7.1060001@webstarts.com>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Jim <jim@webstarts.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA1B9F7.1060001@webstarts.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, 21 October, 2011 14:29:11 Jim wrote:
> Goffredo,
> Thank you very much for your reply.  That was the information I needed 
> to understand the behavior I was observing.  Just to be sure that I 
> understand correctly, you wrote:
> 
> I am quite sure that the snapshot is NOT recursive. If a subvolume contains
> another subvolume, and you snapshot the former, the new subvolume shall not
> contain the "child" subvolume.
> 
> when I snapshot /data, a subvolume I can see (but not enter) the 
> subvolume /sites below it.  
You should be able to enter; however in the latter case /sites is a 
subdirectory instead of a subvolume.

To check if a directory is a subvolume, you can see its inode number. If the 
inode number is 256, then the directory is a entry point of a subvolume.


See this example


# btrfs subvolume create a
Create subvolume './a'
# btrfs subvolume create a/b
Create subvolume 'a/b'
# echo 123 >a/b/c
# btrfs subvolume snapshot a d
Create a snapshot of 'a' in './d'
# ls -li d/
total 0
2 drwxr-xr-x 1 root root 0 Oct 21 20:41 b

d/b is a directory, because its inode number is 2

# ls -li a/
total 0
256 drwx------ 1 root root 2 Oct 21 20:41 b

a/b is a subvolume because its inode number is 256

# ls -li a/b
total 0
257 -rw-r--r-- 1 root root 4 Oct 21 20:41 c
# ls -li d/b/
total 0

d/b is an empty directory

> When I snapshot subvolume /sites I can see 
> and navigate through all directories (not subvolumes) below it.  I am 
> assuming that this is expected behavior.  Thanks again for taking the 
> time to help me here.
> Jim
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
