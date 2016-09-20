Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:42254 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753020AbcITWlC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 18:41:02 -0400
Date: Wed, 21 Sep 2016 00:40:57 +0200
From: Mathieu Chouquet-Stringer <m2n@csetco.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-btrfs@vger.kernel.org
Subject: Re: ChaCha20 vs. AES performance
Message-ID: <20160920224057.GA28476@bosco>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160920155152.eopgz7h2z6kpsfdy@kmo-pixel>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

kent.overstreet@gmail.com (Kent Overstreet) writes:
> On Tue, Sep 20, 2016 at 10:23:20AM -0400, Theodore Ts'o wrote:
>> On Tue, Sep 20, 2016 at 03:15:19AM -0800, Kent Overstreet wrote:
>> > Not on the list or I would've replied directly, but on Haswell, ChaCha20 (in
>> > software) is over 2x as fast as AES (in hardware), at realistic (for a
>> > filesystem) block sizes:
>> 
>> On Skylake and Broadwell processors, AES is faster (the posting is
>> from a ChaCha20 enthusiast):
>> 
>>      https://blog.cloudflare.com/it-takes-two-to-chacha-poly/
>
> The performance delta in his graphs isn't near as big as what I've measured,
> which makes me suspect OpenSSL's ChaCha20 implementation isn't nearly as fast as
> the kernel's.

The other thing to keep in mind is this (aka what's true for a big intel
cpu isn't true everywhere): "The new cipher suites are fast. As Adam
Langley described, ChaCha20-Poly1305 is three times faster than
AES-128-GCM on mobile devices. Spending less time on decryption means
faster page rendering and better battery life."

https://blog.cloudflare.com/do-the-chacha-better-mobile-performance-with-cryptography/

The argument made by Bernstein is in a nutshell than "CPUs are optimized
for video games and thus ciphers should use the same instructions which
makes games 'faster'" (I'd recommend to read his whole email to understand
what he means):
https://moderncrypto.org/mail-archive/noise/2016/000699.html )

Or as one person commented on the net
https://news.ycombinator.com/item?id=12264321 :

Bernstein agrees with you. His point isn't that it's dumb that CPUs are
optimized for games. It's that cipher designers should have enough
awareness of trends in CPU development to design ciphers that take
advantage of the same features that games do. That's what he did with
Salsa/ChaCha. *His subtext is that over the medium term he believes his
ciphers will outperform AES, despite AES having AES-NI hardware
support.* (emphasis mine)

-- 
Mathieu Chouquet-Stringer
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
