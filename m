Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:40412 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754524AbdDRE6w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 00:58:52 -0400
Date: Tue, 18 Apr 2017 09:58:45 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs/SSD
Message-ID: <20170418095845.503b5469@natsu>
In-Reply-To: <pan$3c7$b69cfe37$aed8e56e$e9f7b41d@cox.net>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
        <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com>
        <CAJCQCtS=xqcWMqiRxC_uoqTRUaW6aMwayoqjtMqq6XhcCJNVRg@mail.gmail.com>
        <8f046fa5-a458-9db8-b616-907afd34383b@gmail.com>
        <20170417232419.04474015@natsu>
        <pan$3c7$b69cfe37$aed8e56e$e9f7b41d@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 18 Apr 2017 03:23:13 +0000 (UTC)
Duncan <1i5t5.duncan@cox.net> wrote:

> Without reading the links...
> 
> Are you /sure/ it's /all/ ssds currently on the market?  Or are you 
> thinking narrowly, those actually sold as ssds?
> 
> Because all I've read (and I admit I may not actually be current, but...) 
> on for instance sd cards, certainly ssds by definition, says they're 
> still very write-cycle sensitive -- very simple FTL with little FTL wear-
> leveling.
> 
> And AFAIK, USB thumb drives tend to be in the middle, moderately complex 
> FTL with some, somewhat simplistic, wear-leveling.
> 

If I have to clarify, yes, it's all about SATA and NVMe SSDs. SD cards may be
SSDs "by definition", but nobody will think of an SD card when you say "I
bought an SSD for my computer". And yes, SD card and USB flash sticks are
commonly understood to be much simpler and more brittle devices than full
blown desktop (not to mention server) SSDs.

> While the stuff actually marketed as SSDs, generally SATA or direct PCIE/
> NVME connected, may indeed match your argument, no real end-user concern 
> necessary any more as the FTLs are advanced enough that user or 
> filesystem level write-cycle concerns simply aren't necessary these days.
> 
> 
> So does that claim that write-cycle concerns simply don't apply to modern 
> ssds, also apply to common thumb drives and sd cards?  Because these are 
> certainly ssds both technically and by btrfs standards.
> 


-- 
With respect,
Roman
