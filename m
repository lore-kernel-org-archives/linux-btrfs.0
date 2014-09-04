Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48846 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbaIDRcP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Sep 2014 13:32:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XPatJ-0000MA-1Q
	for linux-btrfs@vger.kernel.org; Thu, 04 Sep 2014 19:32:13 +0200
Received: from pd953e3b4.dip0.t-ipconnect.de ([217.83.227.180])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Sep 2014 19:32:13 +0200
Received: from holger.hoffstaette by pd953e3b4.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Sep 2014 19:32:13 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Btrfs stable updates for v3.16
Date: Thu, 4 Sep 2014 17:31:59 +0000 (UTC)
Message-ID: <pan.2014.09.04.17.31.59@googlemail.com>
References: <54077F27.1040603@fb.com>
	<pan.2014.09.03.23.36.00@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(removed stable@ for now)

Just to follow up on this -

On Wed, 03 Sep 2014 23:36:00 +0000, Holger Hoffstätte wrote:

> [on backporting both:
>  8d875f95da43c6a8f18f77869f2ef26e9594fecc and
>  f6dc45c7a93a011dff6eb9b2ffda59c390c7705a to 3.14]
>
> ...and I guess nobody will complain about slightly better performance
> either.

So "slightly" is an understatement: rename/replace/truncate without full
immediate flushing - as done by rsync's copy+rename - is now indeed
*much* faster, to the point that backups with many small files finish
in a fraction of the time. Wonderful!

Please do get this into the next 3.14 cycle, I'll gladly help and test.

Thanks!

Holger

