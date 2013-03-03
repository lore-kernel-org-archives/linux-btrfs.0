Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw11a-158.wadns.net ([196.220.39.158]:45169 "EHLO
	fw11a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753624Ab3CCQSR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 11:18:17 -0500
Message-ID: <513377BA.1080308@swiftspirit.co.za>
Date: Sun, 03 Mar 2013 18:18:02 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Vedant Kumar <vk@vedantk.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [btrfs] Periodic write spikes while idling, on btrfs root
References: <CABdGeLgO0ncKTx2Hs_KGoJ43vM2FjWE4+WQB_i3KdcHfrphEcg@mail.gmail.com>
In-Reply-To: <CABdGeLgO0ncKTx2Hs_KGoJ43vM2FjWE4+WQB_i3KdcHfrphEcg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/02/14 12:15 PM, Vedant Kumar wrote:
> Hello,
>
> I'm experiencing periodic write spikes while my system is idle.
>
> ...
>
> turned out to be some systemd log in
> /var/log/journal. I turned off journald and rebooted, but the write spike
> behavior remained.
>
> ...
>
> best,
> -vk
I believe btrfs syncs every 30 seconds (if anything's changed).

This sounds like systemd's journal is not actually disabled and that it 
is simply logging new information every few seconds and forcing it to be 
synced to disk. Have you tried following the journal as root to see what 
is being logged?
journalctl -f

Alternatively, as another measure to troubleshoot, in 
/etc/systemd/journald.conf, change the Storage= option either to "none" 
(which disables logging completely) or to a path inside a tmpfs, thereby 
eliminating btrfs' involvement.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

