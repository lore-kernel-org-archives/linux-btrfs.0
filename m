Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 189-19-234-109.dsl.telesp.net.br ([189.19.234.109]:55207 "EHLO
	anthem.async.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752333AbbCFV5O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Mar 2015 16:57:14 -0500
Date: Fri, 6 Mar 2015 18:44:30 -0300
From: Christian Robottom Reis <kiko@canonical.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org, yangds.fnst@cn.fujitsu.com
Subject: Re: Quota limit question
Message-ID: <20150306214430.GC16722@async.com.br>
References: <20141217011537.GA1114@anthem.async.com.br>
 <20141223203601.GB30477@async.com.br>
 <pan$2d7ff$776cb5c$1da18373$20ae4371@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <pan$2d7ff$776cb5c$1da18373$20ae4371@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just as a follow-up, I upgraded btrfs-tools and the kernel again. I
currently have a filesystem which reports 1G exclusive use:

root@riff# btrfs qg show -r -e /var -p -c
qgroupid         rfer         excl     max_rfer     max_excl parent child 
--------         ----         ----     --------     -------- ------ ----- 
0/261         1.52GiB      1.01GiB        0.00B    100.00GiB ---     ---  

This filesystem reports over quota, and removing the quota fixes that:

root@riff# touch x
touch: cannot touch ‘x’: Disk quota exceeded
root@riff# btrfs qg limit -e
none 261 /var
root@riff# touch x
root@riff# 

So at the moment quotas are pretty much unusable in kernel 3.18.6/tools
3.18.2, at least for my use case, and that's a bit surprising since
there isn't anything very interesting about it (other than it contains a
bunch of lxc-cloned rootfs).

I've proactively added Yang who has submitted a few patches on quota
checking recently just to let me know if he thinks that this should be
fixed with a trunk kernel, or if he'd like to investigate or consider
this further. Thanks!

On Wed, Dec 24, 2014 at 03:52:41AM +0000, Duncan wrote:
> Christian Robottom Reis posted on Tue, 23 Dec 2014 18:36:02 -0200 as
> excerpted:
> 
> > On Tue, Dec 16, 2014 at 11:15:37PM -0200, Christian Robottom Reis wrote:
> >>     # btrfs qgroup limit 2000m 0/261 . && touch x touch: cannot touch
> >>     ‘x’: Disk quota exceeded
> >> 
> >> The strange thing is that it doesn't seem to be actually out of space:
> >> 
> >>     # btrfs qgroup show -p -r -e /var | grep 261
> >>     0/261    1111810048  391114752   2097152000  0          ---
> > 
> > Replying to myself as I had not yet been subscribed in time to receive a
> > reply; I just upgraded to 3.18.1 and am seeing the same issue on the
> > same subvolume (and on no others).
> 
> Looking at the thread here on gmane.org (list2news and list2web gateway), 
> it appears my reply was the only reply in any case, and it was general as 
> I don't run quotas myself.
> 
> Basically I suggested upgrading, as the quota code as some rather huge 
> bugs in it (quotas could go seriously negative!) with the old versions 
> you were running.  But you've upgraded at least the kernel now (userspace 
> you didn't say).
> 
> Here's a link to the thread on the gmane web interface for completeness, 
> but the above about covers my reply, as I said the only one until your 
> thread bump and my reply here, so there's not much new there unless 
> someone posts further followups to this thread...
> 
> 
> http://comments.gmane.org/gmane.comp.file-systems.btrfs/41491
> 
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
-- 
Christian Robottom Reis   | [+1] 612 888 4935    | http://launchpad.net/~kiko
Canonical VP Hyperscale   | [+55 16] 9 9112 6430
