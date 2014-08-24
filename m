Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58213 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbaHXSI0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 14:08:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XLcDJ-0008PO-42
	for linux-btrfs@vger.kernel.org; Sun, 24 Aug 2014 20:08:25 +0200
Received: from pd953e32c.dip0.t-ipconnect.de ([217.83.227.44])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 20:08:25 +0200
Received: from holger.hoffstaette by pd953e32c.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 20:08:25 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: 6+ MiB/s constant usage on a btrfs volume with kernel 3.16
Date: Sun, 24 Aug 2014 18:08:12 +0000 (UTC)
Message-ID: <pan.2014.08.24.18.08.12@googlemail.com>
References: <CAGQ70evg4N0dU1-hycjQYbUDUwfnH_akTEcNTtAf=2rjtDU7NA@mail.gmail.com>
	<pan$36b2f$b7fa7666$7edd97f3$7ace6746@cox.net>
	<CAGQ70euehc2=Q9rRJ1zk7HzobDsbBg8QnVi=-2t3Zhn35xLRzA@mail.gmail.com>
	<441201408902401@web23m.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 24 Aug 2014 19:46:41 +0200, Flash ROM wrote:

>> Happens a 100% of the time here, annoyingly. As mentioned, 3.15 was
>> working for me, and still does. Multiple reboots and it happens
>> immediately on boot even before gdm comes up.
> Would be logical to do block-level I/O tracing to get idea WHAT is this
> IO, right?

Or you could just use proper tools for this:

iotop:
http://guichaz.free.fr/iotop/

iosnoop:
http://www.brendangregg.com/blog/2014-07-16/iosnoop-for-linux.html

Probably either a continuing balance or autodefrag vs. systemd's logging.

-h

