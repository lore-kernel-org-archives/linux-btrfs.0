From: Felix Blanke <felixblanke@gmail.com>
Subject: Determine if a given fs is a btrfs fs
Date: Sun, 24 Oct 2010 22:24:10 +0200
Message-ID: <20101024202410.GA2830@scooter>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've some btrfs fs which are encrypted with loopaes.

I decrypt them in a script during bootup. Now I want to determine if the decrypted fs
is a btrfs fs. If not I missspelled the password and I can handle that error in my
script.


Thanks for any help!


Felix
