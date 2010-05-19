From: Chris Ball <cjb@laptop.org>
Subject: Re: default subvolume abilities/restrictions
Date: Wed, 19 May 2010 10:20:52 -0400
Message-ID: <m3y6fg7z23.fsf@pullcord.laptop.org>
References: <AANLkTilY3SUN01IRz1mkKPlkMAJabJr-hYiWazPpeXsx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTilY3SUN01IRz1mkKPlkMAJabJr-hYiWazPpeXsx@mail.gmail.com>
	(C. Anthony Risinger's message of "Wed, 19 May 2010 01:50:27 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > moving along to a question... can the default subvolume be
   > swapped/removed/renamed/popped/shifted?

I think "btrfs subvolume list; btrfs subvolume set-default <id> <path>"
does what you need.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
