Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:38662 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbaKTUfB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 15:35:01 -0500
Received: by mail-qg0-f50.google.com with SMTP id e89so2732966qgf.9
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 12:35:00 -0800 (PST)
Message-ID: <546E5066.1040107@ubuntu.com>
Date: Thu, 20 Nov 2014 15:34:46 -0500
From: Phillip Susi <psusi@ubuntu.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>	<546AF572.2020101@swiftspirit.co.za> <20141118153526.GS20972@merlins.org>	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>	<546BB2EA.5080809@ubuntu.com> <pan$7c051$a7c25939$cafa59e$f63379c9@cox.net> <546CC04F.6040207@ubuntu.com> <546D0609.9040105@pobox.com> <546D0FEA.5000608@ubuntu.com> <546D1AD3.2010206@pobox.com>
In-Reply-To: <546D1AD3.2010206@pobox.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/19/2014 5:33 PM, Robert White wrote:
>> That would be fake raid, not hardware raid.
> 
> The LSI MegaRaid controller people would _love_ to hear more about
> your insight into how their battery-backed multi-drive RAID
> controller is "fake". You should go work for them. Try the "contact
> us" link at the bottom of this page. I'm sure they are waiting for
> your insight with baited breath!

Forgive me, I should have trimmed the quote a bit more.  I was
responding specifically to the "many mother boards have hardware RAID
support available through the bios" part, not the lsi part.

> Odd, my MegaRaid controller takes about fifteen seconds
> by-the-clock to initialize and to the integrity check on my single
> initialized drive.

It is almost certainly spending those 15 seconds on something else,
like bootstrapping its firmware code from a slow serial eeprom or
waiting for you to press the magic key to enter the bios utility.  I
would be very surprised to see that time double if you add a second
disk.  If it does, then they are doing something *very* wrong, and
certainly quite different from any other real or fake raid controller
I've ever used.

> It's amazing that with a fail and retry it would be _faster_...

I have no idea what you are talking about here.  I said that they
aren't going to retry a read that *succeeded* but came back without
their magic signature.  It isn't like reading it again is going to
magically give different results.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJUblBmAAoJEI5FoCIzSKrwFKkIAKNGOGyLrMIcTeV4DQntdbaa
NMkjXnWnk6lHeqTyE/pb+l4VgVH8nQwDp8hRCnKNnKHoZbT8LOGFULSmBes+DDmW
dxPVDTytUu1AiqB7AyxNJU8213BQCaF0inL7ofZmX95N+0eajuVxOyHIMeokdwUU
zLOnXQg0awLkQwk7U6YLAKA4A7HrOEXw4wHt9hPy/yUySMVqCeHYV3tpf7t96guU
0IRctvpwcNvvVtt65I8A4EklR+vCvqEDUZfKyG8WJAeyAdC4UoHT9vZcJAVkiFl+
Y+Mp5wsr1vuo3dYQ1bKO8RvPTB9D9npFyFIlyHEBMJlCHDU43YsNP8hGcu0mKco=
=AJ6/
-----END PGP SIGNATURE-----
