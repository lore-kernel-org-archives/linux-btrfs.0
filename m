From: Jason White <jason@jasonjgw.net>
Subject: cp --reflink with Btrfs
Date: Sun, 13 Dec 2009 00:29:03 +0000 (UTC)
Message-ID: <hg1cge$74i$1@ger.gmane.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I am testing a Btrfs root file system with Debian (kernel 2.6.32) under KVM.

jason@vrtl:~$ touch testfile
jason@vrtl:~$ cp --reflink testfile /tmp
cp: failed to clone `/tmp/testfile': Invalid argument

This is with GNU Coreutils 8.0 taken from debian Sid.

Is this a Coreutils issue, a Btrfs problem or something in my local
configuration?

All the other issues that I have encountered so far are known limitations, for
example, lack of Btrfs support in Grub 2 and the current inability of the
initrd scripts from Debian to recognize the file system type. All of this will
be fixed, no doubt, over time.

Also, if this is the wrong list for such questions, I would appreciate a
reference to the preferred mailing list.

Thank you for an excellent project which is very important to the future of
file systems under Linux.


