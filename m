From: Paul Komkoff <i@stingr.net>
Subject: Re: btrfs: unable to remove the only writeable device
Date: Tue, 14 Dec 2010 19:24:32 +0000
Message-ID: <AANLkTik8j92LrOthZreZJuMmdLLy3u825acfZqbJ_5AU@mail.gmail.com>
References: <Pine.LNX.4.64.1009081954310.11139@claw.oc9.org>
	<AANLkTim0ZU_b68dvYrEy2rWctUhVWLND1+9XZT76LCCt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Roy Keene <btrfs@rkeene.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim0ZU_b68dvYrEy2rWctUhVWLND1+9XZT76LCCt@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 13, 2010 at 2:23 PM, Paul Komkoff <i@stingr.net> wrote:
> Hello.

I'm curious... why everyone is ignoring me?

Anyway. While trying to beat btrfs into submission I managed to make
it fill my dmesg with this:
[3301790.155343] block group 6435937189888 has 1073741824 bytes,
733720576 used 0 pinned 0 reserved
[3301790.155349] entry offset 6436670910464, bytes 340021248, bitmap no
[3301790.155697] block group has cluster?: no
[3301790.155700] 0 blocks of free space at or bigger than bytes is
[3301790.155705] block group 6437010931712 has 1073741824 bytes,
366215168 used 0 pinned 0 reserved
[3301790.155710] entry offset 6437377146880, bytes 707526656, bitmap no
[3301790.156055] block group has cluster?: no
[3301790.156058] 0 blocks of free space at or bigger than bytes is

... and then, as before, fails to remove device.

-- 
This message represents the official view of the voices in my head
