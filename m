Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:50187 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbaADPcq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Jan 2014 10:32:46 -0500
Message-ID: <52C8275C.8010404@libero.it>
Date: Sat, 04 Jan 2014 16:23:08 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: "1i5t5.duncan@cox.net" <1i5t5.duncan@cox.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
References: <52C73987.7000106@jrs-s.net> <52C73D1A.8060805@gmail.com>  <52C7402A.7050605@jrs-s.net> <52C741F5.7030106@gmail.com>  <52C74415.3020407@jrs-s.net>  <7B4E55D1-BA9B-4560-8442-429EDD01C92A@colorremedies.com>  <pan$4ef1f$8e2a9876$c1faa462$63914453@cox.net> <1388847120.23513.21.camel@ret.masoncoding.com>
In-Reply-To: <1388847120.23513.21.camel@ret.masoncoding.com>
Content-Type: text/plain; charset=UTF-7
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-01-04 15:51, Chris Mason wrote:
> I added mount -o degraded just because I wanted the admin to be notified
> of failures.  Right now it's still the most reliable way to notify them,
> but I definitely agree we can do better.  

I think that we should align us to what the others raid subsystem (md
and dm) do in these cases.
Reading the man page of mdadm, to me it seems that an array is
constructed even without some disks; the only requirement is the disks
have to be valid (i.e. not out of sync)

> Leaving it on all the time?  I
> don't think this is a great long term solution, unless you are actively
> monitoring the system to make sure there are no failures.

Anyway mdadm has the "monitor" mode, which reports this kind of error.
>From mdadm man page:
"Follow or Monitor
              Monitor one or more md devices and act on any state
              changes.  This is only meaningful for RAID1,
              4, 5, 6, 10 or multipath arrays, as only these have
              interesting state.  RAID0  or  Linear  never
              have missing, spare, or failed drives, so there is
              nothing to monitor.
"

Best regards
GB



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
