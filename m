Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47567 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750807AbaFYTue convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 15:50:34 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Btrfs suddenly unmountable, open_ctree failed
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAB=7dhmfuwhKOKpA_MFz4XnysqRCLwuTQ=NdEcu+xSPPQ90uww@mail.gmail.com>
Date: Wed, 25 Jun 2014 13:50:32 -0600
Message-Id: <787D10F3-1ABD-4935-8C81-2E0EBC005EC2@colorremedies.com>
References: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com> <ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com> <CAB=7dhk-HM-uT891yKo3-XO2Ko_eC7=qNkLrV_4uM_UmOR1Rmg@mail.gmail.com> <144BDE55-B4B9-405A-B106-F7681FBAF761@colorremedies.com> <CAB=7dhms_ehP4y+L_tMBrdUnJiwXAOn7E4Fa9u3euVBwBKHOKA@mail.gmail.com> <27F042E8-CC94-497D-96B7-283AA1CBD296@colorremedies.com> <CAB=7dh=yq-KjtHOjKPncvGziCEiJgVyMiAAY=4w=Za0Sr9geAg@mail.gmail.com> <9C02AC8A-68FE-4344-A59B-7580D9E0D0C5@colorremedies.com> <CAB=7dhkRURCdaSjYvJfKUecfVt_q+_q26yyEpo2w9Wp1echLjQ@mail.gmail.com> <45855B95-503F-41D2-B569-D88F5F726525@colorremedies.com> <CAB=7dhmfuwhKOKpA_MFz4XnysqRCLwuTQ=NdEcu+xSPPQ90uww@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Mike Hartman <mike@hartmanipulation.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 25, 2014, at 1:32 PM, Mike Hartman <mike@hartmanipulation.com> wrote:

>> I don't know all states of this file system, and copies you have. Right now the earliest copy is obviously broken, and the latest copy is probably more broken because at the least its csum tree has been blown away meaning there's no checksums to confirm whether any data extracted/copied from the file system is OK. You'd just have to open the file and look at it to see if it behaves as it should, and even then depending on what kind of file it is, corruption may not be obvious immediately. So... catch22.
> 
> I'm not sure I follow you. I have a clean dd image, and I made a fresh
> copy of it every time I tried something new, so no copy should be any
> more broken than whatever the current recovery operation did to it.

e.g. --init-csum blows away checksums, so any file read will show checksum mismatches. And I'm not sure the state of btrfs check --repair but in the recent past it has sometimes made problems worse. So that's what I mean. If you're making new copies each time, then of course the original isn't affected…


> (There shouldn't be a distinction between earliest and latest if I
> understand what you mean by "copy".)
> 
> I get all those tree errors when it tries to access the "active"
> versions of the @ and @home volumes. But by the time it starts
> restoring the snapshots I don't see those anymore. So my
> interpretation of the output was that the trees rooted at @ and @home
> are messed up, but the tree structures for the snapshots are ok. Am I
> misunderstanding that output, or are we both equally in the dark about
> what it's telling us?

I'm definitely in the dark about what it's saying.


Chris Murphy

