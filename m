Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1221 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755455AbbFLQ04 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 12:26:56 -0400
Message-ID: <557B084C.1030007@fb.com>
Date: Fri, 12 Jun 2015 12:26:52 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: kernel crashes with btrfs and busy database IO - how to debug?
References: <ae9b9ca434c98509ca6c1ba6dbd84b63@admin.virtall.com>
In-Reply-To: <ae9b9ca434c98509ca6c1ba6dbd84b63@admin.virtall.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/11/2015 07:33 AM, Tomasz Chmielewski wrote:
> I have a server where I've installed a couple of LXC guests, btrfs - so
> easy to test things with snapshots. Or so it seems.
> 
> Unfortunately the box crashes when I put "too much IO load" - with too
> much load being these two running at the same time:
> 
> - quite busy MySQL database (doing up to 100% IO wait when running alone)
> - busy mongo database (doing up to 100% IO wait when running alone)
> 
> With both mongo and mysql running at the same time, it crashes after 1-2
> days (tried kernels 4.0.4, 4.0.5, 4.1-rc7 from Ubuntu "kernel-ppa"). It
> does not crash if I only run mongo, or only mysql. There is plenty of
> memory available (just around 2-4 GB used out of 32 GB) when it crashes.
> 
> As the box is only reachable remotely, I'm not able to catch a crash.
> Sometimes, I'm able to get a bit of it printed via remote SSH, like here:
> 
> [162276.341030] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000008

The 0x8 part is identical to your chattr +C crash, so its safe to assume
that we can focus on that on.  I'll see what I can find, but if you can
run with CONFIG_DEBUG_PAGEALLOC (it'll be slow) my guess is the suspect
will pop out pretty quickly.

-chris

