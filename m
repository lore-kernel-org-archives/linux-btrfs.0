Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55701 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758157Ab3EWM4C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 May 2013 08:56:02 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UfV3n-0006Q4-O7
	for linux-btrfs@vger.kernel.org; Thu, 23 May 2013 14:55:59 +0200
Received: from tc-gate1.pci.uni-heidelberg.de ([129.206.21.241])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 May 2013 14:55:59 +0200
Received: from bernd.schubert by tc-gate1.pci.uni-heidelberg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 May 2013 14:55:59 +0200
To: linux-btrfs@vger.kernel.org
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: raid6: rmw writes all the time?
Date: Thu, 23 May 2013 14:55:47 +0200
Message-ID: <knl3ke$n7t$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

we got a new test system here and I just also tested btrfs raid6 on 
that. Write performance is slightly lower than hw-raid (LSI megasas) and 
md-raid6, but it probably would be much better than any of these two, if 
it wouldn't read all the during the writes. Is this a known issue? This 
is with linux-3.9.2.

Thanks,
Bernd

