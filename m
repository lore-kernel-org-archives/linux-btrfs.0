Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:49467 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab2LSLIm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Dec 2012 06:08:42 -0500
Received: by mail-bk0-f45.google.com with SMTP id jk13so868044bkc.4
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Dec 2012 03:08:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121218121311.GL19051@carfax.org.uk>
References: <kanf24$o8e$1@news.dmz-ext.fr.lan> <20121217162350.GJ19051@carfax.org.uk>
 <50D05174.4060109@swiftspirit.co.za> <20121218121311.GL19051@carfax.org.uk>
From: C Anthony Risinger <anthony@xtfx.me>
Date: Wed, 19 Dec 2012 05:01:22 -0600
Message-ID: <CAGAVQTHrzavOaQfgb_P6_BPdJo28SBPtmDrWKT3To2dJwcRV7A@mail.gmail.com>
Subject: Re: Feeback on RAID1 feature of Btrfs
To: Hugo Mills <hugo@carfax.org.uk>, Brendan Hide <brendan@swiftspirit.co.za>,
        Sebastien Luttringer <sebastien.luttringer@smartjog.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 18, 2012 at 6:13 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Dec 18, 2012 at 01:20:20PM +0200, Brendan Hide wrote:
>> On 2012/12/17 06:23 PM, Hugo Mills wrote:
>> >On Mon, Dec 17, 2012 at 04:51:33PM +0100, Sebastien Luttringer wrote:
>> >>Hello,
>> snip
>> >>I get the feeling that RAID1 only allow one disk removing. Which is more
>> >>a RAID5 feature.
>> >    The RAID-1 support in btrfs makes exactly two copies of each item
>> >of data, so you can lose at most one disk from the array safely. Lose
>> >any more, and you're likely to have lost data, as you've found out.
>> >>I'm afraid Btrfs raid1 will not be working before the end of the world.
>> >    It does work (as you demonstrated with the first disk being
>> >removed) -- but just not as you thought it should. Now, you can argue
>> >that "RAID-1" isn't a good name to use here, but there's no good name
>> >in RAID terminology to describe what we actually have here.
>> Technically, btrfs's "RAID1" implementation is much closer to RAID1E
>> than traditional RAID1. See
>> http://en.wikipedia.org/wiki/Non-standard_RAID_levels#RAID_1E or http://pic.dhe.ibm.com/infocenter/director/v5r2/index.jsp?topic=/serveraid_9.00/fqy0_craid1e.html
>>
>> Perhaps a new name, as with ZFS, might be appropriate. RAID-Z and
>> RAID-Z2, for example, could not adequately be described by any
>> existing RAID terminology and, technically, RAID-Z still isn't a
>> RAID in the classical sense.
>
>    Yeah, we did have a naming scheme proposed, with combinations of
> nCmSpP, where n is the number of copies held, m the number of stripes,
> and p the number of parity stripes. So btrfs RAID-1 is 2C, RAID-5 on 5
> disks would be 4S1P, and RAID-10 on 4 disks would be 2C2S.

...yes.  something like this is not only reflects reality better,, and
actually transfers information in consistent way (vs RAID-XYZ...
meaningless ENUM!) you could maybe do something like:

2C2S : -1S : 0

...or similar, showing:

{normal}
{OFFSET max degraded [rel boundary]}
{OFFSET current}

... which instantly makes the useful boundaries known, along with the
active "panic level" i should be experiencing :)

> I'd prefer
> to see that than some non-"standard" RAID-18KTHXBYE formulation.

^^^ this. the term "RAID" conjures expectations that run afoul of
btrfs's reality and should thus simply be avoided altogether

IMO, unless you wish/must explicitly correlate some similarity X,
there is no need to even mention the work RAID, because it carries no
information.

-- 

C Anthony
