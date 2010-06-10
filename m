From: Gordan Bobic <gordan@bobich.net>
Subject: Copy-on-write hard-links
Date: Thu, 10 Jun 2010 18:11:40 +0100
Message-ID: <4C111CCC.8070103@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Is there a feature in btrfs to manually/explicitly mark hard-links to be 
copy-on-write? My understanding is that this is what happens when a 
snapshot is mounted rw and files modified.

Consider this scenario:

I have a base template fs. I make two snapshots of it that are 
identical. The files in the template and both snapshots are hard-links 
and have the same inode number.

I change a file in one of the snapshots, and it gets copied on write. I 
make the same change in the other snapshot, and that, too, gets copied 
on write. I now have two identical files that are not hard-links any more.

What happens if I remove one of those files and create a hard-link to 
the file in the other snapshot? Will this implicitly become a 
copy-on-write file or will the hard-link aspect in the traditional sense 
be preserved? If I modify the file, will it end up modified in both? Is 
there a way to explicitly set a COW flag (on a file with hard-links)?

The reason I am asking this is because I am looking into using either 
VServer or LXC virtualization. VServer has a "hashify" feature that 
works as I described (copy-on-write hard-linking identical files between 
multiple guests). But VServer isn't, and is unlikely to ever be in the 
mainline kernel. LXC is already in the mainline kernel, but relies on 
the FS to provide this functionality. For future proofing reasons, I 
would prefer to use LXC+btrfs, but hashify is too valuable a feature to 
sacrifice for staying with the mainline. Also note that simple 
block-level dedupe isn't sufficient for the full benefit in this context 
- hard-linking has the additional benefit that multiple copies of DLLs 
in multiple guests will not use separate memory when hard-linked (i.e. 
their inodes are the same). This equates to a very substantial memory 
saving (poor man's KSM) in addition to the disk space savings when there 
are many guests.

TIA.

Gordan
