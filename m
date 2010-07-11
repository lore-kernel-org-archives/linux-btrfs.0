From: redneb@gmx.com
Subject: bug (?) with statvfs call on a subvolume
Date: Sun, 11 Jul 2010 08:16:07 -0400
Message-ID: <20100711121607.GA5234@epicurus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I am trying to use EncFS in conjunction with btrfs and I ran into a 
weird situation which I think is caused by statvfs being called on a 
btrfs subvolume.


In particular, when I do something like the following:
        statvfs("/mnt/btrfs-volume/some-subvolume")
then all mounted FUSE file-systems receive a GETATTR request. This is 
strange because it happens to FUSE file-systems completely unrelated to 
/mnt/btrfs-volume.


This can cause serious problems with some FUSE file-systems such as 
EncFS.  For instance, suppose that you have an EncFS file-systems as 
follows:
        encfs /mnt/btrfs-volume/some-subvolume /home/user/private
Whenever you do statvfs("/home/user/private") then EncFS will internally 
call statvfs("/mnt/btrfs-volume/some-subvolume") but this in turn will 
cause the FUSE method getattr to be called. This cycle of dependencies 
results in a deadlock.


STEP TO REPRODUCE:
1. btrfs subvolume create /mnt/btrfs-volume/private
2. mkdir /home/user/private
3. encfs /mnt/btrfs-volume/private /home/user/private
4. [ do statvfs("/home/user/private") ]

In step 4, stavfs will never return and /home/user/private will become 
unresponsive.
