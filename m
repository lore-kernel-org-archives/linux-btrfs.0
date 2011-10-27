From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Unable to mount (or, why not to work late at night).
Date: Thu, 27 Oct 2011 11:22:52 -0400
Message-ID: <47bc8413b603ceebfb85404d10cdc5f3@www.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=fixed
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

So, I was trying to downgrade my Ubuntu last night, and, before doing anything
risky like that, I backed up my disk via dd to an image on an external disk. 
The critical part here is that I'm afraid I did something truly stupid: I'm
afraid I did the dd... live.  (I can't swear to this, and it does seem
unlikely, but it also seems to be the most likely circumstance.)

So, I dd'd everything back, and now it crashes on boot.  Booting to a 2.6.x
kernel (which is what I had on-hand on a USB drive) mounts it, but doesn't let
me *do* anything (though it spews btrfs errors in dmesg).  Getting Ubuntu 11.10
(kernel rev. 3.0.0) gives me this:

[  121.226246] device fsid d657ce6a-d353-4c2c-858a-6a1f4d9e766e devid 1 transid
217713 /dev/sda1
[  121.232430] parent transid verify failed on 100695031808 wanted 217713 found
217732
[  121.232898] parent transid verify failed on 100695031808 wanted 217713 found
217732
[  121.233357] parent transid verify failed on 100695031808 wanted 217713 found
217732
[  121.233365] parent transid verify failed on 100695031808 wanted 217713 found
217732
[  121.248231] btrfs: open_ctree failed

As I have this complete image on-disk, I'm more than willing to try Extreme
Measures(tm), whatever that might entail.  If I can't get it back, it's not
like it's the loss of my job or anything, but there *is* stuff I'd really like
to get back.

Thanks,

-Ken





