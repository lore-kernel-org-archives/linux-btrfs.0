Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33296 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbK1SzA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 13:55:00 -0500
Received: by iouu10 with SMTP id u10so141049366iou.0
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 10:55:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1448735936.31687.1.camel@scientia.net>
References: <1448643790.11377.39.camel@scientia.net>
	<CAPmG0jZDHkvFq8_f__2p2net3Qu_rfvxBeyRHNZPZ3tekbhMMQ@mail.gmail.com>
	<1448684040.6837.18.camel@scientia.net>
	<CAJCQCtQZ0-q5m=DM5nsrveU-W=Bc-L75m+Oyx6XsYHs2pJwzCg@mail.gmail.com>
	<1448735936.31687.1.camel@scientia.net>
Date: Sat, 28 Nov 2015 11:55:00 -0700
Message-ID: <CAJCQCtR7j_7oTmZT44_J15v0FH1WYVrk=7faoxYi9XrTEfLL1Q@mail.gmail.com>
Subject: Re: slowness when cp respectively send/receiving on top of dm-crypt
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 28, 2015 at 11:38 AM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> On Sat, 2015-11-28 at 11:34 -0700, Chris Murphy wrote:
>> It sounds to me like maybe LUKS is configured to use an encryption
>> algorithm that isn't subject to CPU optimized support, e.g. aes-xts
>> on
>> my laptop gets 1600MiB/s where serpent-cbc gets only 68MiB/s and pegs
>> the CPU. This is reported by 'cryptsetup benchmark'
>
> hmmm...
> $ /sbin/cryptsetup benchmark
> # Tests are approximate using memory only (no storage IO).
> PBKDF2-sha1       910222 iterations per second
> PBKDF2-sha256     590414 iterations per second
> PBKDF2-sha512     399609 iterations per second
> PBKDF2-ripemd160  548418 iterations per second
> PBKDF2-whirlpool  179060 iterations per second
> #  Algorithm | Key |  Encryption |  Decryption
>      aes-cbc   128b   474,3 MiB/s  1686,2 MiB/s
>  serpent-cbc   128b    69,4 MiB/s   235,3 MiB/s
>  twofish-cbc   128b   144,5 MiB/s   271,6 MiB/s
>      aes-cbc   256b   348,0 MiB/s  1239,4 MiB/s
>  serpent-cbc   256b    68,8 MiB/s   231,5 MiB/s
>  twofish-cbc   256b   146,6 MiB/s   268,9 MiB/s
>      aes-xts   256b  1381,3 MiB/s  1384,3 MiB/s
>  serpent-xts   256b   238,6 MiB/s   231,1 MiB/s
>  twofish-xts   256b   262,9 MiB/s   266,7 MiB/s
>      aes-xts   512b  1085,7 MiB/s  1078,9 MiB/s
>  serpent-xts   512b   242,1 MiB/s   230,2 MiB/s
>  twofish-xts   512b   266,8 MiB/s   265,9 MiB/s
>
> I'm having aes-xts-plain64 with 512 bit key...
> that's still 1 GiB/s

I'm using aes-xts-plain64 with a 512 bit keysize also, and dmcrypt
doesn't even register in iotop or top when I do a scrub of the file
system. So I'm not sure what's going on in your case. But I also don't
use compression. The apparent fragmentation is actually bogus, it's an
artifact of compression. If you look at the fragments with filefrag
-v, you'll see that these are actually contiguous extents for the most
part.


-- 
Chris Murphy
