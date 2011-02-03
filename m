From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #27842] [regression?] hang with 2.6.37 on a BTRFS test machine
Date: Thu, 3 Feb 2011 20:05:53 +0100
Message-ID: <201102032005.53772.rjw@sisk.pl>
References: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera> <-tcJxClTQPH.A.Z6D.r6eSNB@chimera> <201102031220.46250.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>,
	linux-btrfs@vger.kernel.org, "Helmut Hullen" <Hullen@t-online.de>
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201102031220.46250.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, February 03, 2011, Martin Steigerwald wrote:
> Added linux-btrfs and Helmut Hullen, who seemed to experience hangs on a 
> T23 with BTRFS as well, to Cc.
> 
> Am Thursday 03 February 2011 schrieb Rafael J. Wysocki:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.36 and 2.6.37.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.36 and 2.6.37.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=27842
> > Subject		: [regression?] hang with 2.6.37 on a BTRFS test machine
> > Submitter	: Martin Steigerwald <Martin@lichtvoll.de>
> > Date		: 2011-01-23 12:06 (11 days old)
> > Message-ID	: <201101231306.23069.Martin@lichtvoll.de>
> > References	: http://marc.info/?l=linux-kernel&m=129578445613283&w=2
> 
> Well I now tested with 2.6.36 for more than a week and I did not see any 
> of such hangs upto now. The machine seems table with 2.6.36. So I think 
> its really an regression of 2.6.37.
> 
> I am stuck with what to try next. Since trying to track it down to a 
> specific commit appears too involved for me and its appears also quite 
> laborious to get any value debug information out of the kernel - cause it 
> can take days for the bug to appear -, I am inclined to either test with 
> 2.6.37.1 once its available or just give it a go with 2.6.38-rc3 or rc4. 
> Maybe 2.6.38-rc3/4 would be the best bet, I have seen a report on the 
> btrfs mailing list of 2.6.38 fixing a BTRFS hang bug that appeared with 
> 2.6.37. I am just not sure whether its related or not.
> 
> Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped buffer of 
> the same page
> http://marc.info/?l=linux-btrfs&m=129623925116051&w=2
> 
> There is another thread about 2.6.37 related BTRFS hang:
> 
> flush-btrfs-1 hangs when building openwrt
> http://marc.info/?l=linux-btrfs&m=129594547616298&w=2
> 
> I will add this as comment to the bug report as well.

Thanks for the update.

Rafael
