Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49202 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933555Ab3BMKeA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 05:34:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1U5ZfN-0005EP-OQ
	for linux-btrfs@vger.kernel.org; Wed, 13 Feb 2013 11:34:17 +0100
Received: from p5086a491.dip.t-dialin.net ([80.134.164.145])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 11:34:17 +0100
Received: from holger.hoffstaette by p5086a491.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 11:34:17 +0100
To: linux-btrfs@vger.kernel.org
From: "Holger Hoffstaette" <holger.hoffstaette@googlemail.com>
Subject: User feedback: raise the default leaf size to 16k
Date: Wed, 13 Feb 2013 11:33:45 +0100
Message-ID: <pan.2013.02.13.10.33.45.439956@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

after using btrfs with 3.7.x and default settings without any problems so
far (knock on wood!) I had to redo a 1TB filesystem and this time decided
to try two small changes:

- raise the leaf size to 16k
- use single metadata profile

After restoring the contents (~300GB, mix of large and small files) the
difference in behaviour on a single disk is *very* noticeable.
Therefore I want to suggest changing the default values accordingly. IMHO
the new behaviour - maybe including the single metadata redundancy - is
much more in line with behaviour that people expect out of the box. I
believe many cases where users report degrading performance over time can
be attributed to this. Whether single metadata is too much of a risk I
cannot judge, but please at least raise the default leaf size.

Just my 0.01€ of user feedback :)

thanks
Holger


