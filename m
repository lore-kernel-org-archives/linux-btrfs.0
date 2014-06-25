Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:60841 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaFYTc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 15:32:56 -0400
Received: by mail-qc0-f170.google.com with SMTP id l6so2249488qcy.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jun 2014 12:32:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <45855B95-503F-41D2-B569-D88F5F726525@colorremedies.com>
References: <CAB=7dhnnfr_5bpkD5k29f0xHHMbyUy8EXPsE6RC3r=JgPbE7Gw@mail.gmail.com>
 <ECEE7DFB-E4E1-482D-929F-ABAF8133E1F4@colorremedies.com> <CAB=7dhk-HM-uT891yKo3-XO2Ko_eC7=qNkLrV_4uM_UmOR1Rmg@mail.gmail.com>
 <144BDE55-B4B9-405A-B106-F7681FBAF761@colorremedies.com> <CAB=7dhms_ehP4y+L_tMBrdUnJiwXAOn7E4Fa9u3euVBwBKHOKA@mail.gmail.com>
 <27F042E8-CC94-497D-96B7-283AA1CBD296@colorremedies.com> <CAB=7dh=yq-KjtHOjKPncvGziCEiJgVyMiAAY=4w=Za0Sr9geAg@mail.gmail.com>
 <9C02AC8A-68FE-4344-A59B-7580D9E0D0C5@colorremedies.com> <CAB=7dhkRURCdaSjYvJfKUecfVt_q+_q26yyEpo2w9Wp1echLjQ@mail.gmail.com>
 <45855B95-503F-41D2-B569-D88F5F726525@colorremedies.com>
From: Mike Hartman <mike@hartmanipulation.com>
Date: Wed, 25 Jun 2014 15:32:35 -0400
Message-ID: <CAB=7dhmfuwhKOKpA_MFz4XnysqRCLwuTQ=NdEcu+xSPPQ90uww@mail.gmail.com>
Subject: Re: Btrfs suddenly unmountable, open_ctree failed
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I don't know all states of this file system, and copies you have. Right now the earliest copy is obviously broken, and the latest copy is probably more broken because at the least its csum tree has been blown away meaning there's no checksums to confirm whether any data extracted/copied from the file system is OK. You'd just have to open the file and look at it to see if it behaves as it should, and even then depending on what kind of file it is, corruption may not be obvious immediately. So... catch22.

I'm not sure I follow you. I have a clean dd image, and I made a fresh
copy of it every time I tried something new, so no copy should be any
more broken than whatever the current recovery operation did to it.
(There shouldn't be a distinction between earliest and latest if I
understand what you mean by "copy".)

I get all those tree errors when it tries to access the "active"
versions of the @ and @home volumes. But by the time it starts
restoring the snapshots I don't see those anymore. So my
interpretation of the output was that the trees rooted at @ and @home
are messed up, but the tree structures for the snapshots are ok. Am I
misunderstanding that output, or are we both equally in the dark about
what it's telling us?

Setting aside the tree integrity issue, does anyone know what
condition causes that "offset is <number>" output during a restore
operation? I've seen several wiki pages and posts about how to use the
restore feature, but nothing that details what's going on under the
hood or how to interpret the output. If it's not complaining about the
tree, and there are none of those "offset" errors, would the
assumption be that the entire snapshot was recovered successfully?

>But seems to me in any case sda6 needs to be reformatted, the only question is if you reformat it Btrfs or something else (honestly - it doesn't matter whether it was the chicken soup that made you sick, the association is understandable).

Yep. I'll probably stick with Btrfs and just try to improve my backup
strategy. I think I need to start a) replicating my snapshots to
another file system and b) more aggressively snapshotting @home. I've
been avoiding that because I have so many big files that come and go
so often there the snapshots would take up a lot of space. But maybe a
single rolling snapshot hourly or daily would make this kind of issue
easier to deal with.

> I'm very interesting in how this turns out. Is it a Btrfs bug, is it a hardware bug, is it some bad/unlucky collision of more than one problem? Is it possible metadata DUP might have changed the outcome? If so are we better off in the short term using metadata DUP on SSDs? Or is the hindsight takeway "metadata DUP isn't worth it on SSD, better is more frequent backups than what was done" and you just have to weigh whether that's practical for your workflow.

I'll definitely report back here if #btrfs provides any insight. And
anyone else who comes across this and has suggestions, please, chime
in!
