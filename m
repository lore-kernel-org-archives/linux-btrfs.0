Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52618 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbcFBF6w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jun 2016 01:58:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b8Lea-0003RR-3s
	for linux-btrfs@vger.kernel.org; Thu, 02 Jun 2016 07:58:48 +0200
Received: from 87-127-16-100.static.enta.net ([87.127.16.100])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jun 2016 07:58:48 +0200
Received: from 6401e46d by 87-127-16-100.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jun 2016 07:58:48 +0200
To: linux-btrfs@vger.kernel.org
From: al <6401e46d@opayq.com>
Subject: Re: Very quick embarrassing q: /var/lib permissions.
Date: Thu, 2 Jun 2016 05:58:35 +0000 (UTC)
Message-ID: <loom.20160602T074637-99@post.gmane.org>
References: <loom.20160531T234453-643@post.gmane.org> <d0551873-1579-66b1-08c5-d002e721612f@jp.fujitsu.com> <loom.20160602T031625-163@post.gmane.org> <b59606d4-c9ec-5dc5-3c04-2d3d52b13809@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Satoru Takeuchi <takeuchi_satoru <at> jp.fujitsu.com> writes:

> <snip>

Something is wrong with my setup or process. I'm still not getting progress
reports (any longer) on scrub status and I wanted to make sure it's not me
before I whinge again. :-D

I've just, with your help, ruled out permissions.
I next need to have a quick test at running scrub from the root (rather the
all-encompassing subvol).

Thank you again Satoru.

