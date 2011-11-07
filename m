From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: grub-1.99 and btrfs-only
Date: Mon, 07 Nov 2011 16:07:55 -0500
Message-ID: <4EB848AB.1000006@cfl.rr.com>
References: <1485076.Kk29g2Lexo@funbeast>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chuck Burns <break19@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1485076.Kk29g2Lexo@funbeast>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/5/2011 10:02 PM, Chuck Burns wrote:
> These are my current subvolumes:
> # btrfs sub list /
> ID 256 top level 5 path mainroot
> ID 257 top level 5 path home
>
> I have sub 256 set as default, and then home is mounted onto mainroot.

I advise against using set-default at all.  The setup Ubuntu seems to be 
going for ( and is working well for me so far ) creates two subvolumes 
under the default root, named @ and @home, and intended to be mounted in 
/ and /home respectively.  The /@ subvolume is then mounted as the root 
via rootflags=subvol=@ argument, and grub is configured to use 
/@/boot/grub as its prefix directory.

I'm still getting a "sparse file not allowed" error during boot, and 
have to press enter to continue though.  Still not tracked that one down.

