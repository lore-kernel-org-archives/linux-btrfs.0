Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55595 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932068AbaAaCTC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 21:19:02 -0500
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: lost with degraded RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CABgvyo_Tn-u7Lfo4NPeWyiiSFj2ZFG9MM2z3CAD9f3hjfLM44g@mail.gmail.com>
Date: Thu, 30 Jan 2014 19:19:02 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <94FF8D2A-709B-4EBC-A7D1-4760A82AA91E@colorremedies.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com> <CABgvyo_Tn-u7Lfo4NPeWyiiSFj2ZFG9MM2z3CAD9f3hjfLM44g@mail.gmail.com>
To: =?iso-8859-1?Q?Johan_Kr=F6ckel?= <johan.kroeckel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 30, 2014, at 4:53 AM, Johan Kröckel <johan.kroeckel@gmail.com> wrote:

> http://www.spinics.net/lists/linux-btrfs/msg20164.html

and

> Syslog says: "Jan 30 12:44:02 fortknox kernel: [756677.795661] Btrfs:
> too many missing devices, writeable mount is not allowed"


By the way, the cited patch says "Btrfs: too many missing devices, writeable remount is not allowed"

The patch says "remount" but your error says "mount". I'm not sure you have the right patch.


Chris Murphy

