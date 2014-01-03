Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32304 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754048AbaACUga convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 15:36:30 -0500
From: Chris Mason <clm@fb.com>
To: "marc@merlins.org" <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "hugo@carfax.org.uk" <hugo@carfax.org.uk>,
        "lists@colorremedies.com" <lists@colorremedies.com>
Subject: Re: Is anyone using btrfs send/receive for backups instead of rsync?
Date: Fri, 3 Jan 2014 20:35:59 +0000
Message-ID: <1388781398.23513.0.camel@ret.masoncoding.com>
References: <20131228171943.GE19863@merlins.org>
	 <20131228173730.GA7234@carfax.org.uk> <20131228180758.GF19863@merlins.org>
	 <20131228182023.GG19863@merlins.org>
	 <1388419531.11341.6.camel@ret.masoncoding.com>
	 <20131230161729.GQ19863@merlins.org>
	 <1388420830.11341.12.camel@ret.masoncoding.com>
	 <20131230171039.GC26054@merlins.org>
	 <95A29B65-87F9-4B73-9715-2BBC10833A64@colorremedies.com>
	 <20131230175740.GS19863@merlins.org> <20140103201543.GF10021@merlins.org>
In-Reply-To: <20140103201543.GF10021@merlins.org>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-01-03 at 12:15 -0800, Marc MERLIN wrote:
+AD4- On Mon, Dec 30, 2013 at 09:57:40AM -0800, Marc MERLIN wrote:
+AD4- +AD4- On Mon, Dec 30, 2013 at 10:48:10AM -0700, Chris Murphy wrote:
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- On Dec 30, 2013, at 10:10 AM, Marc MERLIN +ADw-marc+AEA-merlins.org+AD4- wrote:
+AD4- +AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- +AD4- If one day, it could at least work on a subvolume level (only sync a
+AD4- +AD4- +AD4- +AD4- subvolume), then it would be more useful to me. Maybe later+ICY-
+AD4- +AD4- +AD4- 
+AD4- +AD4- +AD4- Maybe I'm missing something, but btrfs send/receive only work on a subvolume level.
+AD4- +AD4- 
+AD4- +AD4- Never mind, I seem to be the one being dense. I mis-read that you needed
+AD4- +AD4- to create the filesystem with btrfs receive.
+AD4- +AD4- Indeed, it's on a subvolume level, so it's actually fine since it does
+AD4- +AD4- allow over provisionning afterall.
+AD4- 
+AD4- Mmmh, but I just realized that on my laptop, I do boot the btrfs copy
+AD4- (currently done with rsync) from time to time (i.e. emergency boot from
+AD4- the HD the SSD was copied to).
+AD4- If I do that, it'll change the filesystem that was created with btrfs
+AD4- receive and break it, preventing further updates, correct?
+AD4- 
+AD4- If so, can I get around that by making a boot snapshot after each copy
+AD4- and mount that snapshot for emergency boot instead of the main volume?

Yes that will work.

-chris

