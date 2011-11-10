From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Stupid newb tricks: making a subvolume of root.
Date: Thu, 10 Nov 2011 09:50:00 -0500
Message-ID: <6c5dc86169d45cbc1001d0daa2d51a08@www.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=fixed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hey, all.  I did a "convert" on my ext-3 system, and now I've got a monolithic
btrfs volume.  I'd like to break / and /home into subvolumes.  /home is easy (I
think): I just create a subvolume, and move stuff into it, and mount it.  Done.
 But how do I do that for root?  (Don't worry about the actual mounting, grub,
etc.,; I have a different system that works the way I want it to.)

Thanks,

-Ken





