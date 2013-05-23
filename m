Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:52969 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab3EWNLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 May 2013 09:11:21 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id DFDF97C065C
	for <linux-btrfs@vger.kernel.org>; Thu, 23 May 2013 07:11:20 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <knl3ke$n7t$1@ger.gmane.org>
In-Reply-To: <knl3ke$n7t$1@ger.gmane.org>
Message-ID: <20130523131118.4907.45217@localhost.localdomain>
Subject: Re: raid6: rmw writes all the time?
Date: Thu, 23 May 2013 09:11:18 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Bernd Schubert (2013-05-23 08:55:47)
> Hi all,
> 
> we got a new test system here and I just also tested btrfs raid6 on 
> that. Write performance is slightly lower than hw-raid (LSI megasas) and 
> md-raid6, but it probably would be much better than any of these two, if 
> it wouldn't read all the during the writes. Is this a known issue? This 
> is with linux-3.9.2.

Hi Bernd,

Any time you do a write smaller than a full stripe, we'll have to do a
read/modify/write cycle to satisfy it.  This is true of md raid6 and the
hw-raid as well, but their reads don't show up in vmstat (try iostat
instead).

So the bigger question is where are your small writes coming from.  If
they are metadata, you can use raid1 for the metadata.

-chris

