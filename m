From: Jim <jim@webstarts.com>
Subject: snapshot issues
Date: Fri, 14 Oct 2011 13:13:31 -0400
Message-ID: <4E986DBB.4080100@webstarts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Good afternoon btrfs,
I have been having issues with snapshots not reading the whole file tree 
below them.  I have installed new btrfs-progs from

git://git.darksatanic.net/repo/btrfs-progs-unstable.git

made and installed them.  My tree is:  /Btrfs |
                                               |__ nfs1 |
                                                        |__ data |
                                                                 |__ sites |
                                                                           |__ 00xx |
                                                                                    |__ email@address

If I use btrfsctl -s (btrfs sub snapshot isn't working) snappath-name /btrfs/nfs1  I get a mountable snapshot of nfs1
but data is all that I can see below it.  If I btrfsctl -s snappath-name /btrfs/nfs1/data/sites/0000 I can mount /0000 and
get a full list of email@address accounts but none of the files below them.  I should have stated earlier, everything down
to and including /email@address are subvolumes.  Below /email@address directories and files were rsync'd into the subvol from
an nfs mount.  Finally if I snapshot /email@address I have access to all directories and files below them.  Because of this I
believe that the issue is with snapshots of subvolumes.  I thought I just couldn't see subvols above the snapshot level and was able to see subvols below.  Am I confused or is this a real problem.  I am using kernel 3.1.0-rc4 and will be happy to trace anything you need if you can tell me how to get what you need.  Thanks for your help.
Jim

