Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37582 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaCTGTk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 02:19:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WQWKG-0004MT-B7
	for linux-btrfs@vger.kernel.org; Thu, 20 Mar 2014 07:19:36 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Mar 2014 07:19:36 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Mar 2014 07:19:36 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-rmw-2: page allocation failure: order:1, mode:0x8020
Date: Thu, 20 Mar 2014 06:19:10 +0000 (UTC)
Message-ID: <pan$abf66$faea9a06$c5ce02f4$1e7a0c96@cox.net>
References: <20140320002007.GY18959@merlins.org> <CF4FB5F3.2116%clm@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason posted on Thu, 20 Mar 2014 01:01:35 +0000 as excerpted:

> Message-ID: <CF4FB5F3.2116%clm@fb.com>
> Accept-Language: en-US
> Content-Type: text/plain; charset=euc-kr
> Content-Transfer-Encoding: base64
> Content-Language: en-US

>>> Sorry, I misspoke, you should bump /proc/sys/vm/min_free_kbytes.
>>> Honestly though, it©ös just a bug in the mvs driver.  Atomic 8K
>>> allocations are doomed to fail eventually.

> The process is a btrfs worker, and the IO was started by btrfs, but the
> allocation failure is all inside the mvs driver.  There¡¯s even the
> printk in there from mvs about the allocation failing.

> -chris
> 
> N§²æìržyúèØb²X¬¶Ç§vØ^)Þº{.nÇ+·¥{±nÚß²)íæèw*jg¬±š¶Ý¢
j/êäz¹Þà2Þšè­Ú&¢)ß¡«a¶Úþø®G«éh®æj:+všwèÙ¥


Chris, you might wish to take a look at this and/or have one of the FB 
techs familiar with your mail transport layers (and/or your mail client, 
and/or perhaps it's vger's list-serv bot) look at it.  That list-sig came 
thru as garbage at least here, and your "it's" and "there's" appear to 
have strange apostrophes as well.  As you can see I also included the 
headers I think might be relevant, plus the Message-ID.

The problem wasn't a big one here, but if it starts corrupting patches or 
something too...

I'd guess it has something to do with that content-type charset=euc-kr in 
the headers, which looks really strange combined with the accept-language 
and content-language both being en-US.

The other messages of yours (with an uncorrupted list sig) I checked had 
a content-type charset=iso-8859-1 header, which seems to be most common 
in English messages, anyway.  Why this one had euc-kr I don't know.

However, it's also worth noting that the third-level quoting above, also 
from you, has an "it's", and when I checked /that/ message, the 
apostrophe was a super-script-1, as it was when quoted in Marc's reply, 
but that got changed to the copyright symbol (plus something else) in 
your quote, which at least as I'm posting the quote, is showing the same 
way.

Meanwhile, the apostrophe in the "there's" in your message's new content 
(which is thus first-level quote in this message) is different, an i 
followed by an over-line.  I'd /guess/ that's what actually triggered the 
Korean (?) charset in your message, in ordered to handle that or perhaps 
some other character I missed, while your other messages are iso-8859-1, 
which thus changed the auto-inserted list-sig into garbage, since the 
list-bot presumably inserted it as the usual iso-8859-1 while your 
message claimed to be in eur-kr.

(It'll be interesting to see if my message, with both quotes, looks the 
same when I read it on the list via gmane, as it does when I send it, or 
if it's further garbled, and if my charset gets set to something exotic 
too.  FWIW, my client, which should be visible in my headers, is pan, via 
gmane.org's list2news service.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

