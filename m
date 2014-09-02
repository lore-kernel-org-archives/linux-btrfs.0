Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61681 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIBMW5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 08:22:57 -0400
Received: by mail-pa0-f45.google.com with SMTP id bj1so14506872pad.4
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 05:22:56 -0700 (PDT)
Date: Tue, 2 Sep 2014 20:22:53 +0800
From: Eryu Guan <guaneryu@gmail.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: canonicalize dm device name before
 update kernel
Message-ID: <20140902122253.GD3013@dhcp-13-216.nay.redhat.com>
References: <1408016420-29221-1-git-send-email-guaneryu@gmail.com>
 <1408016420-29221-2-git-send-email-guaneryu@gmail.com>
 <20140902113234.GE5888@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140902113234.GE5888@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 02, 2014 at 01:32:34PM +0200, David Sterba wrote:
> On Thu, Aug 14, 2014 at 07:40:20PM +0800, Eryu Guan wrote:
> > [root@hp-dl388eg8-01 btrfs-progs]# btrfs fi show
> > Label: none  uuid: 1aba7da5-ce2b-4af0-a716-db732abc60b2
> >         Total devices 1 FS bytes used 384.00KiB
> >         devid    1 size 15.00GiB used 2.04GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv1
> > 
> > Label: none  uuid: 26ff4f12-f6d9-4cbc-aae2-57febeefde37
> >         Total devices 2 FS bytes used 112.00KiB
> >         devid    1 size 15.00GiB used 2.03GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv2
> >         devid    2 size 15.00GiB used 2.01GiB path /dev/mapper/rhel_hp--dl388eg8--01-testlv3
> > 
> > Btrfs v3.14.2
> 
> The commit b276e4bc50b6ca99056a45315ea859c68d58fc1b
> "canonicalize pathnames for device commands" supposedly fixes the same
> problem, added in 3.16. Can you please test that it works in your case
> as well? Thanks.

Yes, confirmed v3.16 fixes the issue, the device name didn't change
after btrfsck and btrfs device scan -d

Thanks,
Eryu
