From: email@joachim-neu.de
Subject: Unable to mount btrfs partition
Date: Fri, 28 Oct 2011 20:36:28 +0000
Message-ID: <4941f692b926ed2b19ccde5c3a791cdf@joachim-neu.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


 Hello!

 Today I downgraded from Ubuntu's APT repo "oneiric-proposed" (which 
 brings some kernel 3.0.0-13) back to the standard repo "oneiric".

 Now I'm not able to mount my btrfs / and /home (both on the same 
 partition) anymore:

 device fsid SOME-UUID devid 1 transid 84229 /dev/dm-0
 parent transid verify failed on 77078528 wanted 83774 found 84226
 parent transid verify failed on 77078528 wanted 83774 found 84226
 parent transid verify failed on 77078528 wanted 83774 found 84226
 parent transid verify failed on 77078528 wanted 83774 found 84226
 btrfs: open_ctree failed

 The boot process drops to the initramfs shell with no btrfsck 
 available. I tried to boot with both the "new" 3.0.0-13 kernel and the 
 old 3.0.0-12 and 3.0.0-11 kernels -- no success. I'm running a live cd 
 right now with 3.0.0-12 and I get the above error no matter what I do: 
 no mount, no fsck, no nothing.

 I really hope someone can help me get my data back...

 Joachim
