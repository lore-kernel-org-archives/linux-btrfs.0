Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39344 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954AbcCQHzL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 03:55:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1agSlu-0001jd-Qg
	for linux-btrfs@vger.kernel.org; Thu, 17 Mar 2016 08:55:07 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 08:55:06 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 08:55:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Incompat features: raid56 ... when creating a RAID6?
Date: Thu, 17 Mar 2016 07:55:01 +0000 (UTC)
Message-ID: <pan$1be34$8fa35fd6$fbfff80f$41034782@cox.net>
References: <16570443.SxVegaKaET@andilaptop>
	<2241137.7FlY2XkjWK@andilaptop> <56E8AE64.2090704@oracle.com>
	<1770754.bSus6jR0QL@andilaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andreas Grosse posted on Wed, 16 Mar 2016 10:12:47 +0100 as excerpted:

> Am Mittwoch, 16. MÃ€rz 2016, 08:52:52 CET schrieb Anand Jain:
>>   Yes looks like. As it was there when I read your posting.
>> 
>> 
>> >>> AndiNâ¹Â§Â²ÃŠÃ¬rÂžâºyÃºÃšÅ¡ÃbÂ²XÂ¬Â¶ÃÂ§vÃ^â)ÃÂº
{.nÃ+â°Â·Â¥Å {Â±nÃÃÂ²)Ã­âŠÃŠÃšw*jgÂ¬Â±ÂšÂ¶â°Å¡ÅœÅ ÃÂ¢j/
ÂÃª
>> >>> Ã€z
>> >>> Â¹ÃâÅ Ã 2Å Ãâ¢ÂšÃšÂ­Ã&Â¢)ÃÂ
¡Â«aÂ¶ÃÃŸÃžÂ®GÂ«ÂÃ©hÂ®ÃŠj:+vâ°ÂšÅ wÃšâ ÃÂ¥
> 
> I'll have a look at this. I have no idea where this came from. But it
> seems this stuff is invisible on the list archives on the web on my
> initial message...
> 
> N§²æìržyúèØb²X¬¶Ç§vØ^)Þº{.nÇ+·¥{±nÚß²)íæèw*jg¬
±š¶Ý¢j/êäz¹Þà2Þšè­Ú&¢)ß¡«a¶Úþø®G«éh®æj:
+všwèÙ¥


FWIW, your posting as it appeared on gmane's news (nntp, which I use for 
this list) and web archives was truncated.  Hugo evidently got a better 
copy than gmane did, as he quoted text that wasn't there for me.

Here's (one of) the gmane web link(s) to your post on the web archive:

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/54108

As you can see, it's truncated there, tho the web interface doesn't let 
you see the raw message.

The nntp/news archive does better at letting you at the raw message.  I 
use pan as my nntp client, and fetched the raw message file itself from 
cache after getting the messageID from the pan GUI.  Unfortunately, not a 
lot of web or mail clients know what to do with links like...

nntp://news.gmane.org/gmane.comp.file-systems.btrfs

... and I don't remember how to add the specific article to the link.  So 
you may have trouble getting the article from news.

Tho AFAIK lynx, the text-mode browser, can handle news.  You might try 
that.


I could send you personally a copy of the message file, however, if you 
like.  Selected headers say:

User-Agent: KMail/ (Linux/4.5.0-gentoo; KDE/5.20.0; x86_64; ; )
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: base64


With the base64 encoding, of course the raw message body is just a big 
block of ASCII chars encoding the base64 ... notably, with the list 
footer/signature appended below in plain 7-bit ASCII.  I wonder if some 
clients (including pan, it would appear, tho gmane's web interface 
displayed the same body I saw in pan) can't handle the mix of base64 
encoding and plain 7-bit ASCII?, in a message the headers clearly state 
as base64 encoded?  Certainly, the listserv shouldn't just add a plain-
text blob of text to a message body that is base64 encoded like that, 
instead making it multi-part and putting the sig in a 7-bit ascii or 
whatever encoding, if need be, or decoding the base64, appending the text 
blob, and recoding, but regardless, if that's all the "corruption" is, 
clients should handle it better than trucating and/or corrupting.

I didn't try to manually decode the block of base64 either using uudeview 
or the like or fully manually, to see if it stopped at the same spot, or 
included the corruption, or something else, but I do have the full raw 
message file as downloaded via gmane using pan, and can mail it to you 
privately if you'd like.  Tho if you're familiar at all with news and 
have a client to use on news.gmane.org, or simply have lynx around and 
can follow the link above in it, you can find and grab the news article 
for yourself.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

