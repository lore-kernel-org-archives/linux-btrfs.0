Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48112 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbcHEKRQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Aug 2016 06:17:16 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bVcBW-0000f9-Ga
	for linux-btrfs@vger.kernel.org; Fri, 05 Aug 2016 12:16:58 +0200
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: How to stress test raid6 on 122 disk array
Date: Fri, 05 Aug 2016 13:15:17 +0300
Message-ID: <m49k2fvmsi2.fsf@coffee.modeemi.fi>
References: <CAGQ70Ye3Ly0N5cZHe3_D0RX8yW6ZzcN7fVhoLnnXrPXjOKPa1Q@mail.gmail.com>
	<274e0a56-086f-23c4-7ae9-2b6cb68ec6c8@gmail.com>
	<CAJCQCtQAPXn714YL2R1V7q2fhn7QCsYHHceTimyFQ1TsMf-BQg@mail.gmail.com>
	<CAGQ70Yf3R4mfPJRZWvyBXivN9qy_9WOsrZhdpx--a_27Wy3sYQ@mail.gmail.com>
	<CAJCQCtTKsYxYH26E1a66--HiDRF3JXSdOSjLa1ira_1Ti6N+pw@mail.gmail.com>
	<CAGQ70YfvcujVWs-Hr-jLS5DED3ti5XK=fVhx6M8K7c85UVYDhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin <rc6encrypted@gmail.com> writes:

> The smallest disk of the 122 is 500GB. Is it possible to have btrfs
> see each disk as only e.g. 10GB? That way I can corrupt and resilver
> more disks over a month.

Well, at least you can easily partition the devices for that to happen.

However, I would also suggest that would it be more useful use of the
resource to run many arrays in parallel? Ie. one 6-device raid6, one
20-device raid6, and then perhaps use the rest of the devices for a very
large btrfs filesystem? Or if you have been using partitioning the large
btrfs volume can also be composed of all the 122 devices; in fact you
could even run multiple 122-device raid6s and use different kind of
testing on each. For performance testing you might only excert one of
the file systems at a time, though.

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

