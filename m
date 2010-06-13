From: David Brown <btrfs@davidb.org>
Subject: Re: default subvolume abilities/restrictions
Date: Sat, 12 Jun 2010 17:22:53 -0700
Message-ID: <20100613002252.GA12170@arch.davidb.org>
References: <29213501.290601274270192630.JavaMail.defaultUser@defaultHost>
 <AANLkTinCbFQkWvehlmnmGrPdduWfWUjutgYADZAkSlCe@mail.gmail.com>
 <AANLkTikHScVP2MylD7EXVC-d-v0RloxVpv8P5SEgrXd6@mail.gmail.com>
 <AANLkTim0VvWP0CLIWCqHMUZX1dAHPOBWWcRoZYSRUgyn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim0VvWP0CLIWCqHMUZX1dAHPOBWWcRoZYSRUgyn@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 12, 2010 at 06:06:23PM -0500, C Anthony Risinger wrote:

>> # btrfs subvolume create new_root
>> # mv . new_root/old_root

>can i at least get confirmation that the above is possible?

I've had no problem with

   # btrfs subvolume snapshot . new_root
   # mkdir old_root
   # mv * old_root
   # rm -rf old_root

Make sure the 'mv' fails fo move new_root, and I'd look at the
new_root before removing everything.

David
