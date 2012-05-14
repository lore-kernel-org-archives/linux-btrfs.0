From: Josef Bacik <josef@redhat.com>
Subject: Re: Ceph on btrfs 3.4rc
Date: Mon, 14 May 2012 10:20:48 -0400
Message-ID: <20120514142048.GA3260@localhost.localdomain>
References: <CAJafhzSVZ3+1ApgJU=sQu6gM62BeWVGG4mqFPNYRHx79czYJtQ@mail.gmail.com>
 <20120424152141.GB3326@localhost.localdomain>
 <Pine.LNX.4.64.1204240922040.29159@cobra.newdream.net>
 <CAJafhzSgaQ3sx=Af0Ru0CiwQH37V5y8jgjoTo_8yozcjo9rpPA@mail.gmail.com>
 <20120510203523.GD2061@localhost.localdomain>
 <20120511133124.GB2089@localhost.localdomain>
 <4FAD5B7E.5040801@tuxadero.com>
 <20120511191623.GB3503@localhost.localdomain>
 <4FB11479.8060408@tuxadero.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Christian Brunner <christian@brunner-muc.de>,
	Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
To: Martin Mailand <martin@tuxadero.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FB11479.8060408@tuxadero.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2012 at 04:19:37PM +0200, Martin Mailand wrote:
> Hi Josef,
> 
> Am 11.05.2012 21:16, schrieb Josef Bacik:
> >Heh duh, sorry, try this one instead.  Thanks,
> 
> With this patch I got this Bug:

Yeah Christian reported the same thing on Friday.  I'm going to work on a patch
and actually run it here to make sure it doesn't blow up and then send it to the
list when I think I've got something that works.  Thanks,

Josef
