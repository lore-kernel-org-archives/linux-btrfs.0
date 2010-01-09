From: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Subject: How to mount a subvolume?
Date: Sat, 9 Jan 2010 15:07:57 +0100
Message-ID: <20100109150757.1051fd79@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

First thanks alot to Kay and Goffredo!

But I have another question.

I read that the current tools cannot display subvolumes, but one should still
be able to mount them. If I try I get an error message:

> mount -t btrfs -o subvol=root.2010-01-07 /dev/sda3 /save
mount: /dev/sda3 is not a valid block device

root.2010-01-07 is a snapshot of the /root-directory

/save is an empty directory used for mounting backups

taken (successfully) with the following command:

> btrfsctl -s root.2010-01-07 /root

What am I doing wrong? Isn't it possible to mount the whole filesystem and a
subvolume at the same time?

Greetings, Michael
