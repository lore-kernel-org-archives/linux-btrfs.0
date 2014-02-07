Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41387 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753437AbaBGRn5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 12:43:57 -0500
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: lost with degraded RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CABgvyo8iS-8i-NKDUPX30B+Mk-B8-ZjLU7p_N7XefXtcSDvCFg@mail.gmail.com>
Date: Fri, 7 Feb 2014 10:43:56 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <C37F3250-AA5B-4C75-8ECB-D1E7B6FFEADD@colorremedies.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com> <C0AD9885-8F81-4642-809F-BDC3933A5932@colorremedies.com> <20140130175831.GU3314@carfax.org.uk> <C3B0EA86-0CBA-4500-81A8-7F3A99306E76@colorremedies.com> <CABgvyo8ZG=pk=i-7iXzoOWqZj_fVvUd6xiaXef1KWR8QLibhXg@mail.gmail.com> <6C293A14-9A38-4DAA-A720-1F77B9CB083D@colorremedies.com> <CABgvyo-cZ1bw7Gyd5sUYK11mMUp3N2w6v=SNEdXBRYqbNSNNFQ@mail.gmail.com> <CABgvyo8iS-8i-NKDUPX30B+Mk-B8-ZjLU7p_N7XefXtcSDvCFg@mail.gmail.com>
To: =?iso-8859-1?Q?Johan_Kr=F6ckel?= <johan.kroeckel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 7, 2014, at 4:34 AM, Johan Kröckel <johan.kroeckel@gmail.com> wrote:

> Is there anything else I should do with this setup or may I nuke the
> two partitions and reuse them?

Well I'm pretty sure once you run 'btrfs check --repair' that you've hit the end of the road. Possibly btrfs restore can still extract some files, it might be worth testing whether that works.

Otherwise blow it away. I'd say test with 3.14-rc2 with a new file system and see if you can reproduce the sequence that caused this problem in the first place. If it's reproducible, I think there's a bug here somewhere.


Chris Murphy