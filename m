Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54034 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbbDQUgP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 16:36:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YjCzi-0003oA-Ro
	for linux-btrfs@vger.kernel.org; Fri, 17 Apr 2015 22:36:10 +0200
Received: from p4ff5858e.dip0.t-ipconnect.de ([79.245.133.142])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 22:36:10 +0200
Received: from holger.hoffstaette by p4ff5858e.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 22:36:10 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Background corrections don't show up in device stats, and have
 low syslog priority. How do I reliably find out about them?
Date: Fri, 17 Apr 2015 20:35:59 +0000 (UTC)
Message-ID: <pan.2015.04.17.20.35.59@googlemail.com>
References: <20150417194609.1192EA03BC@smtp.hushmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 17 Apr 2015 21:46:08 +0200, ivarun_ml wrote:

> But if I instead just read the file, then btrfs will still detect and
> correct the corruption, but the device stats are not updated, and the
> errors in the syslog have info-priority, making them much harder to
> notice. [..]

I don't know about the device stats, but at least the log level for
read errors was already fixed in a patch series:

http://www.spinics.net/lists/linux-btrfs/msg40556.html

This was merged into 4.0.

-h


