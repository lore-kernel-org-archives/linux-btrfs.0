Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37491 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbaGHUTZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jul 2014 16:19:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X4brD-0008RC-B2
	for linux-btrfs@vger.kernel.org; Tue, 08 Jul 2014 22:19:19 +0200
Received: from p5b005923.dip0.t-ipconnect.de ([91.0.89.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jul 2014 22:19:19 +0200
Received: from holger.hoffstaette by p5b005923.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jul 2014 22:19:19 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: btrfs and mount in gentoo linux
Date: Tue, 8 Jul 2014 20:19:04 +0000 (UTC)
Message-ID: <pan.2014.07.08.20.19.04@googlemail.com>
References: <53BC4172.8080300@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Tue, 08 Jul 2014 21:07:30 +0200, Stefan G. Weichinger wrote:

> I am a happy btrfs-user with gentoo linux for some time now and noticed
> that the command "mount" does not show me which subvolid is mounted where.

Interestingly I just found that this came up in Fedora some time ago:
https://bugzilla.redhat.com/show_bug.cgi?id=743118

findmnt seems to do the trick, so the underlying functionality in
libmnt seems to work. Maybe Debian's mount does something differently?

Holger

