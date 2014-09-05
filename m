Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49832 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750966AbaIEBlm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Sep 2014 21:41:42 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:54274 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XPiWz-002765-5u
	for linux-btrfs@vger.kernel.org; Thu, 04 Sep 2014 19:41:41 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BTRFS critical (device dm-0): invalid dir item name len: 45389
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CANg_oxzTv3cDyS0prJc_ZLopt3YNvm7oa9dFnghV7aZGNiyMvA@mail.gmail.com>
Date: Thu, 4 Sep 2014 19:41:39 -0600
Message-Id: <03A7512C-C195-4906-9995-945AF3D76EB2@colorremedies.com>
References: <CANg_oxxmR+qkSfZeVYK5dF1HnbSJapEF1tZ+3-9ij5hq7d2E=w@mail.gmail.com> <CANg_oxzsAAV3S-Qc=mz0GTVXnPFrQ43riNXVbtT4Wjqtwsbo2A@mail.gmail.com> <pan$680f3$c4143e4$b1f456fa$d9f8eac0@cox.net> <CANg_oxzTv3cDyS0prJc_ZLopt3YNvm7oa9dFnghV7aZGNiyMvA@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 4, 2014, at 6:20 PM, john terragon <jterragon@gmail.com> wrote:

> Everyone knows what raid0 entails. Moreover, with btrfs being an
> experimental fs, not having backups would obviously be pure idiocy.

That is a bit of hyperbole. There is such a thing as innocently ignorant, as well as the misinformed.

> I don't know if you are a btrfs developer but that "pretty serious"
> was not meant to offend them nor to complain.

I think the "pretty serious" statement is legit. No one wants filesystems themselves responsible for losing data, if they did this with any regularity we wouldn't trust them, and we need to trust them. Since there are myriad sources for data loss or corruption a good autopsy is needed to understand the problem, and then whether the fix is one of prevented or can also be done during normal read, scrub, or btrfsck.

If the conditions can be repeated and reproduce the problem, that's a happy day.

> So, the "pretty serious" was more due to the surprise than anything else.

Right. Off chance scrub might fix the problem and then the evidence of why a regular read can't deal with it is gone. So I'd either take a btrfs-image first, or do a read-only non-background scrub and see what you get in dmesg:

btrfs scrub start -BRr <mp>

And btrfs check unmounted and without any options.


Chris Murphy