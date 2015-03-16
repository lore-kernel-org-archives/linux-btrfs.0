Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbbCPFdn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 01:33:43 -0400
Date: Mon, 16 Mar 2015 13:33:37 +0800
From: Eryu Guan <eguan@redhat.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstest: btrfs: add a test for quota number when deleting
 a subvol.
Message-ID: <20150316053337.GA23302@dhcp-13-216.nay.redhat.com>
References: <54EEB798.1070105@cn.fujitsu.com>
 <1425381210-13661-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <20150306050600.GQ16974@dhcp-13-216.nay.redhat.com>
 <550664EC.7090705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <550664EC.7090705@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 16, 2015 at 01:06:52PM +0800, Dongsheng Yang wrote:
> Hi Guan,  sorry for the late.
> 
> On 03/06/2015 01:06 PM, Eryu Guan wrote:
> >On Tue, Mar 03, 2015 at 07:13:30PM +0800, Dongsheng Yang wrote:
> >>This regression is introduced by two commits:
> >>
> >>e339a6b0 (Btrfs: __btrfs_mod_ref should always use no_quota)
> >>1152651a (btrfs: qgroup: account shared subtrees during snapshot delete)

[snip]

> >>+_cleanup()
> >>+{
> >>+    cd /
> >>+    rm -f $tmp.*
> >Better to use a tab not 4 spaces, maybe "new" should be updated too (in
> >another patch)
> 
> Thanx, will send another patch for "./new".

Just FYI, I've already sent out the fix, please see

http://www.spinics.net/lists/fstests/msg01073.html

Thanks,
Eryu Guan
