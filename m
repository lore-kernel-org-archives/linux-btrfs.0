Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49963 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222AbcAFLER (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Jan 2016 06:04:17 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 88C6A20C68
	for <linux-btrfs@vger.kernel.org>; Wed,  6 Jan 2016 06:04:16 -0500 (EST)
Message-Id: <1452078256.371119.484306690.4F4014FE@webmail.messagingengine.com>
From: Rasmus Abrahamsen <btrfs@rasmusa.net>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: Add big device, remove small device, read-only
Date: Wed, 06 Jan 2016 12:04:16 +0100
In-Reply-To: <pan$8f979$3e11d093$c11f0907$776df255@cox.net>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net>
 <CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com>
 <1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com>
 <pan$8f979$3e11d093$c11f0907$776df255@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, Jan 6, 2016, at 07:45 AM, Duncan wrote:
> Rasmus Abrahamsen posted on Fri, 01 Jan 2016 21:20:13 +0100 as excerpted:
> 
> > I accidentically sent my messages directly to Duncan, I am copying them
> > in here.
> > 
> > Hello Duncan,
> > 
> > Thank you for the amazing response. Wow, you are awesome.
> 
> Just a note to mention that real life (TM) got in the way, and I'm a few 
> days and a couple hundred posts behind on the list, now.  Sounds like you 
> have a backup tho, and if worse comes to worse, you can simply blow away 
> the filesystem and start over.  Between that and Chris Murphy helping you 
> now, I read the thread to date but am simply marking it read without 
> further replies as it exists ATM, but might reply to new posts to the 
> thread from now, if I think I can be helpful.
> 
> (Which is why I try to discourage direct replies, too.  With direct 
> replies to a single person, if that person doesn't get back...  While if 
> it's to the list, there's more that can take up the thread, it's not on 
> just one person.  Of course the just to me was an accident, but...)
> 
> -- 
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Yeah, I have made many mistakes as this is my first time participating
on a mailing list :)

I decided to blow away the filesystem and start over. I did so by
physically removing the new 4 TB drive, mounting -o degraded and then
running:

find . -type f -exec cat {} >> /dev/null \;

In all folders that matter to me to make sure everything is readable
without the new drive. I then formatted the new drive as BTRFS and moved
over all my data. Then I added my old 4 TB drive to the new filesystem
and did balance -dconvert=raid1 -mconvert=raid1. I am now online with
the new filesystem and things are good.

I was expecting btrfs to just work (tm) when adding the new drive and
removing the old, so that made me a little sad. However, it's awesome
that no data was lost and my method actually worked.

Thanks for a great place and product.
