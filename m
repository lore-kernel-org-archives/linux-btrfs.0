From: Erik Hoppe <amiga600dev@yahoo.de>
Subject: Re: system crash at mounting of btrfs
Date: Wed, 13 Oct 2010 12:33:12 +0000 (UTC)
Message-ID: <loom.20101013T143053-455@post.gmane.org>
References: <loom.20101007T155351-932@post.gmane.org> <20101008171635.GS4804@think> <loom.20101009T073143-310@post.gmane.org> <loom.20101009T150327-437@post.gmane.org> <20101011235525.GK22691@think> <loom.20101012T083638-169@post.gmane.org> <20101013004915.GM22691@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi There,

I got the same problem (freezing kernel while mounting btfs disk). My block 
device is a 8gb sdcard, it should be physical intact cause 
i can dd the card into a file without problems.
Here is what i did so far:
mount mmcblk0 under 2.6.35 (freeze)
mount the diskdumped image as a loop device on another system using 2.6.35
and current git kernel (freeze)

so i'm pretty much lost a.t.m.

I'm willing to send the metadata image (instructions please) and Chris
could you please send me your wipe-log tool
so i can maybee restore my data files ;)
 

greetings

erik





