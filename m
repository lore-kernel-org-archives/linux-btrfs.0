From: "kreijack@libero.it" <kreijack@libero.it>
Subject: R: Re: [RFC] Move all btrfs command to only one command
Date: Fri, 22 Jan 2010 13:47:13 +0100 (CET)
Message-ID: <7491720.68711264164433888.JavaMail.defaultUser@defaultHost>
Reply-To: "kreijack@libero.it" <kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: <avbidder@fortytwo.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>



>----Messaggio originale----
>Da: avbidder@fortytwo.ch
>Data: 22/01/2010 9.23
>A: <linux-btrfs@vger.kernel.org>
>Cc: "Goffredo Baroncelli"<kreijack@gmail.com>
>Ogg: Re: [RFC] Move all btrfs command to only one command
>
>Hi,
>
>I like this very much, I found myself wondering which program did what 
again 
>and again when I started to use btrfs, too.
>
>On Thursday 21 January 2010 20.29:26 Goffredo Baroncelli wrote:
>>        btrfs resize|-r [+/-]<newsize>[gkm]|max <filesystem>
>>                Resize the file system. If 'max' is passed, the filesystem
>>                will occupe all available space on the device.
>
>Switch the arguments, and if the 2nd is missing do what you propose for 
>"max".

I prefer that the switch still be before. But if it is missing, 'max' should 
be a reasonable default.
So the syntax becomes:

      btrfs resize|-r [[+/-]<newsize>[gkm]|max] <filesystem>
               Resize the file system. If '-r' is missing or 'max' is passed, 
the filesystem
               will occupe all available space on the device. 

>
>>         btrfs scan|-S [<device> [<device>..]
>>                 Scan all device for or the passed device for a btrfs
>> filesystem.
>
>This is the only that *migt* be sensible to have as a separate tool, if 
>"btrfs" ends up requiring additional runtime dependencies: the scan utility 
>should be small since it will need to be included in the initrd.

My command "btrfs" is only a front end which call library functions. It 
doesn't implement the scan engine.
But I agree that a "small" tool which performs the scanning only function is 
reasonable.

>-- 
>Protect your privacy - encrypt your email: http://fortytwo.ch/gpg/intro
>


