Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933033Ab2EQOnT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 10:43:19 -0400
Date: Thu, 17 May 2012 10:43:07 -0400
From: Josef Bacik <josef@redhat.com>
To: Martin Mailand <martin@tuxadero.com>
Cc: Josef Bacik <josef@redhat.com>,
        Christian Brunner <christian@brunner-muc.de>,
        Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: Re: Ceph on btrfs 3.4rc
Message-ID: <20120517144306.GA3011@dhcp231-144.rdu.redhat.com>
References: <Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net>
 <CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com>
 <20120510203523.GD2061@localhost.localdomain>
 <20120511133124.GB2089@localhost.localdomain>
 <4FAD5B7E.5040801@tuxadero.com>
 <20120511191623.GB3503@localhost.localdomain>
 <4FB11479.8060408@tuxadero.com>
 <20120514142048.GA3260@localhost.localdomain>
 <20120516192035.GA1910@localhost.localdomain>
 <4FB4D30C.7030301@tuxadero.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FB4D30C.7030301@tuxadero.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2012 at 12:29:32PM +0200, Martin Mailand wrote:
> Hi Josef,
> 
> somehow I still get the kernel Bug messages, I used your patch from
> the 16th against rc7.
> 

Was there anything above those messages?  There should have been a WARN_ON() or
something.  If not thats fine, I just need to know one way or the other so I can
figure out what to do next.  Thanks,

Josef
