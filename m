From: John Dong <jdong@ubuntu.com>
Subject: btrfsck aborts after transid verify failed?
Date: Wed, 21 Oct 2009 02:05:42 -0400
Message-ID: <4ADEA4B6.8050001@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a fairly stock Ubuntu Karmic install within a VMWare session, 
converted from ext4 via btrfs-convert out of git, and also btrfs.ko 
compiled out of git.

A btrsfsck run after removing the ext2_saved image yielded the following:

parent transid verify failed on 17092046848 wanted 9067 found 8931
btrfsck: disk-io.c:416: find_and_setup_root: Assertion `!(!root->node)' 
failed.
[1]    2252 abort (core dumped)  sudo btrfsck /dev/sda2

