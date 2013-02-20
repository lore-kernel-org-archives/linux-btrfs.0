Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49029 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934612Ab3BTTTp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 14:19:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1U8FD0-0000zU-Ah
	for linux-btrfs@vger.kernel.org; Wed, 20 Feb 2013 20:20:02 +0100
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 20:20:02 +0100
Received: from eternaleye by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 20:20:02 +0100
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Hybrid Storage proposal
Date: Wed, 20 Feb 2013 11:19:26 -0800
Message-ID: <kg37js$5vc$1@ger.gmane.org>
References: <20130220164605.GA13504@uflip.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Matias Bjorling wrote:

> Here is a short proposal for the hybrid storage cache idea with
> introduction/motivation and a bird's eye view of an approach to implement
> a hybrid storage cache for btrfs. Please note that there is currently no
> available patches. We would like to get as much input before as possible
> before we start designing and implementing a solution.

Just to toss this out there, aside from the option of 'cache chunks' there 
is the option of using normal chunks, and instead place extents on chunks 
based on performance characteristics of the underlying device.

As an analogy, if the above proposal is closer to the 'bcache' approach of 
treating the SSD purely as a performance enhancer that does not contribute 
to capacity, performance-based allocation is closer to the 'btier' [1] 
approach in which the SSD does contribute to capacity, but has 'dibs' on 
performance-sensitive data.

[1] Btier sourceforge page: http://sourceforge.net/projects/tier/

Lessfs homepage, with btier info: http://www.lessfs.com/wordpress/

