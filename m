Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758892AbcCVMAV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 08:00:21 -0400
Date: Tue, 22 Mar 2016 20:00:14 +0800
From: Eryu Guan <eguan@redhat.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2] fstests: test fsync on overlayfs merged directory
Message-ID: <20160322120014.GJ11419@eguan.usersys.redhat.com>
References: <1458581952-18638-1-git-send-email-fdmanana@kernel.org>
 <1458582625-22039-1-git-send-email-fdmanana@kernel.org>
 <20160322030023.GF11419@eguan.usersys.redhat.com>
 <CAL3q7H6z1Ut2MQh5dRv0ALwWnuiw0n1i_OJpbz=MVh=p3GTJXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6z1Ut2MQh5dRv0ALwWnuiw0n1i_OJpbz=MVh=p3GTJXw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 22, 2016 at 11:07:06AM +0000, Filipe Manana wrote:
> On Tue, Mar 22, 2016 at 3:00 AM, Eryu Guan <eguan@redhat.com> wrote:
...
> >> +
> >> +# real QA test starts here
> >> +_supported_fs generic
> >
> > The supported fs should be "overlay"? overlay/001 has the same issue
> > though.
> 
> Yeah, I copied it from 001. And that's a question I made myself but
> forgot later to investigate. Since you authored test 001, can you
> confirm if it's a mistake or is it really supposed to be 'overlay'?

It's my mistake in overlay/001, it should be overlay.

Thanks,
Eryu
