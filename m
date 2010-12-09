From: "Michael Niederle" <mniederle@gmx.at>
Subject: mount snapshot by object-id
Date: Thu, 9 Dec 2010 14:51:14 +0100
Message-ID: <20101209145114.07f55914@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I'm currently writing a btrfs-rescue tool and therefor began to study the
btrfs-on-disk structures in detail.

The root tree contains a ROOT_ITEM entry for *every* subvolume in the whole
file system, but only DIR_ITEM entries for subvolumes that were created in the
root directory of the filesystem.

If we have a destroyed root directory, there is no way to access subvolumes
stored deeper in the fs-tree by name. It might be nice to have the ability to
mount a subvolume by object-id. A simple tool could list all available
subvolumes with their object-ids, generation numbers, and so on.

Greetings, Michael
