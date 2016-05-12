Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35142 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbcELQRz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 12:17:55 -0400
Received: by mail-wm0-f42.google.com with SMTP id e201so265246458wme.0
        for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 09:17:54 -0700 (PDT)
From: Diego Calleja <diegocg@gmail.com>
To: Nikolaus Rath <Nikolaus@rath.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Input/output error on newly created file
Date: Thu, 12 May 2016 18:17:50 +0200
Message-ID: <58549996.M9MX6vESn9@archlinux>
In-Reply-To: <87eg971dqf.fsf@thinkpad.rath.org>
References: <8760uoqjlt.fsf@vostro.rath.org> <878tzilhf3.fsf@vostro.rath.org> <87eg971dqf.fsf@thinkpad.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El jueves, 12 de mayo de 2016 8:46:00 (CEST) Nikolaus Rath escribió:
> *ping*
> 
> Anyone any idea?

All I can say is that I've had the same problem in the past. In my
case, the problematic files where active torrents. The interesting
thing is that I was able to read them correctly up to a point, then
I would get the same error as you. No messages in dmesg. The amount
of data I was able to read from them was not random, it was
something multiple of 4K. After reboot the problems went away and
I wasn't able to reproduce it.

There has been reports of similiar issues in the past:
http://www.spinics.net/lists/linux-btrfs/msg52371.html
