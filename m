Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wnls-smtp2.wa.co.za ([41.185.62.207]:45130 "EHLO
	wnls-smtp2.wa.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2LRLu1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 06:50:27 -0500
Message-ID: <50D05174.4060109@swiftspirit.co.za>
Date: Tue, 18 Dec 2012 13:20:20 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>,
        Sebastien Luttringer <sebastien.luttringer@smartjog.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Feeback on RAID1 feature of Btrfs
References: <kanf24$o8e$1@news.dmz-ext.fr.lan> <20121217162350.GJ19051@carfax.org.uk>
In-Reply-To: <20121217162350.GJ19051@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012/12/17 06:23 PM, Hugo Mills wrote:
> On Mon, Dec 17, 2012 at 04:51:33PM +0100, Sebastien Luttringer wrote:
>> Hello,
snip
>> I get the feeling that RAID1 only allow one disk removing. Which is more
>> a RAID5 feature.
>     The RAID-1 support in btrfs makes exactly two copies of each item
> of data, so you can lose at most one disk from the array safely. Lose
> any more, and you're likely to have lost data, as you've found out.
>> I'm afraid Btrfs raid1 will not be working before the end of the world.
>     It does work (as you demonstrated with the first disk being
> removed) -- but just not as you thought it should. Now, you can argue
> that "RAID-1" isn't a good name to use here, but there's no good name
> in RAID terminology to describe what we actually have here.
Technically, btrfs's "RAID1" implementation is much closer to RAID1E 
than traditional RAID1. See 
http://en.wikipedia.org/wiki/Non-standard_RAID_levels#RAID_1E or 
http://pic.dhe.ibm.com/infocenter/director/v5r2/index.jsp?topic=/serveraid_9.00/fqy0_craid1e.html

Perhaps a new name, as with ZFS, might be appropriate. RAID-Z and 
RAID-Z2, for example, could not adequately be described by any existing 
RAID terminology and, technically, RAID-Z still isn't a RAID in the 
classical sense.

-- 
Brendan Hide

083 448 3867
http://swiftspirit.co.za/

