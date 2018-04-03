Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:39750 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754675AbeDCA75 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Apr 2018 20:59:57 -0400
Date: Tue, 3 Apr 2018 02:59:51 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Hugo Mills <hugo@carfax.org.uk>, Fedja Beader <fedja@protonmail.ch>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [wiki] Please clarify how to check whether barriers are properly
 implemented in hardware
Message-ID: <20180403005951.hgjokwvjtwpqzrqm@angband.pl>
References: <4qM6bqeIXt1jGOul3HmynOFezEQLL--S4mQQsyYaGU5u_eYiiCP9uLZnyuBYU4LyUbe9Yp32oYU1rY-wh6p5Jg==@protonmail.ch>
 <u_zEBVQVCIIoJiHQIDjqqi7rHOFPhczdc2XdtJiOWRo7_5ththeYDrz_jnkNaSirIpkV94nBhQAtzWP2viADYw==@protonmail.ch>
 <20180402220701.GK17966@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20180402220701.GK17966@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 02, 2018 at 10:07:01PM +0000, Hugo Mills wrote:
> On Mon, Apr 02, 2018 at 06:03:00PM -0400, Fedja Beader wrote:
> > Is there some testing utility for this? Is there a way to extract this/tell with a high enough certainty from datasheets/other material before purchase?
> 
>    Given that not implementing barriers is basically a bug in the
> hardware [for SATA or SAS], I don't think anyone's going to specify
> anything other than "fully suppors barriers" in their datasheets.
> 
>    I don't know of a testing tool. It may not be obvious that barriers
> aren't being honoured without doing things like power-failure testing.

And you'd need to do a lot of power-cycling during writes, with various
write patterns -- as unless you have a case of "let's lie about barriers to
make benchmarks better than the competition" where barriers are consistently
absent, it might be a genuine bug in a well-meaning controller that at least
tries but sometimes fails to.  The intentional case is usually easy to
detect -- but just wait go get volkswagenized. :/


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ 
⢿⡄⠘⠷⠚⠋⠀ ... what's the frequency of that 5V DC?
⠈⠳⣄⠀⠀⠀⠀
