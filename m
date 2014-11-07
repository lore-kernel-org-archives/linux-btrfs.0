Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 2.mo6.mail-out.ovh.net ([46.105.76.65]:35120 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753018AbaKGTMe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Nov 2014 14:12:34 -0500
Received: from mail179.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo6.mail-out.ovh.net (Postfix) with SMTP id DA578FF9F37
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Nov 2014 20:06:43 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: Quota question
From: Cyril Scetbon <cyril.scetbon@free.fr>
In-Reply-To: <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net>
Date: Fri, 7 Nov 2014 20:06:40 +0100
Cc: linux-btrfs@vger.kernel.org
Message-Id: <CCA13B0E-D1EE-44D8-A634-FD17C2B22C72@free.fr>
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr> <F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr> <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

I've made some tests with a newer version of btrfs, and I still have issues :(

http://pastebin.com/cycu08LG

I have 2 directories with quotas and a parent qgroup. All have quotas limits but something goes wrong. When the parent limit is exceeded I have a "Disk quota exceeded" which is what was expecting. However, after some tests I can exceed the limits (see line 80 and 84), but after that I can nolonger write to disk without getting an error and even if I just want to suppress the data !

FYI I'm using this kernel https://launchpad.net/ubuntu/+source/linux/3.16.0-25.33

Any idea ? Bug ?
-- 
Cyril SCETBON

> On 01 Nov 2014, at 08:00, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> Cyril Scetbon posted on Fri, 31 Oct 2014 09:45:23 +0100 as excerpted:
> 
>> Besides the first question, I met an issue using parent groups (see
>> http://pastebin.com/asT5ZFsi). I can't reproduce it all the time, but it
>> seems to appear frequently. Is there any know BUG that can be the source
>> of this error ? I'm using version 3.12 on Trusty
> 
> I don't use quotas personally, but I know for quite some time they were 
> essentially "broken" in certain instances.  My recommendation as a list 
> regular then was, unless your goal is specific quota-feature-testing, if 
> you /need/ quotas, use a more mature filesystem that can reliably provide 
> them; if you don't need quotas, turn them off and avoid the quota related 
> btrfs bugs.
> 
> Recently, around 3.16 timeframe I believe, there was quite a btrfs quota-
> subsystem rewrite designed to tackle and eliminate these problems.  Now 
> since I don't use quotas personally and I've not seen a definitive 
> statement on-list one way or the other I'm not sure if the full rewrite 
> is done yet or not, but I've not see further followup patches either, so 
> barring further information to the contrary I'd guess it is.  However, 
> it's still early in the history of the new code  and it's still just 
> that, new.  While I've not seen many quota-related bug reports from it, 
> it may well be that enough people took the general recommendation above 
> that it simply hasn't gotten much testing.
> 
> So I honestly can't say what the state of the new quota code is, but one 
> thing I can say for sure is that the quota code in 3.12 is the old code, 
> known to be broken and now rewritten, dead quota code.  So for sure I'd 
> say don't use it.  It's known to be broken and there's simply no reason 
> to do so.
> 
> But with the rewrite you now have three choices instead of two.  If you 
> need quotas and are up for testing relatively new code (and btrfs itself 
> isn't exactly the maturest around, so if you're not up for testing new 
> code, why are you running btrfs at all?), try a recent enough btrfs that 
> you are running the new quota code and your tests and potentially bug 
> reports will be actually worthwhile.  I just read today that Ubuntu is 
> maintaining the 3.16 kernel for somewhat longer in coordination with 
> their distro releases, after Greg recently released the last planned 
> regular stable 3.16 release, so that's a reasonable kernel series to 
> settle with.  I /think/ it has the new quota code, and certainly, the bad 
> bug in the 3.15 series is fixed (in 3.16.2) and the bug that plagued 
> 3.17, now fixed in 3.18-rc2 and headed for 3.17 stable, wouldn't be in 
> 3.16 stable either.  Or you can of course follow current mainline.
> 
> The other two choices are as before, turn off quotas in btrfs, or switch 
> to a more mature filesystem with reliable quota support.  But staying 
> with 3.12 with btrfs quotas enabled simply doesn't make sense, because as 
> I said, the quota code there is dead and known broken, so that's not a 
> reasonable option at all.
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

