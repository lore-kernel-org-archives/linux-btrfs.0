Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932600AbcI2O3s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 10:29:48 -0400
Date: Thu, 29 Sep 2016 16:29:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Anatoly Pugachev <matorola@gmail.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
        <holger@applied-asynchrony.com>,
        Omar Sandoval <osandov@osandov.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>, bo.li.liu@oracle.com,
        fstests@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Btrfs: free space tree and sanity test fixes
Message-ID: <20160929142945.GC5531@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1474580472.git.osandov@fb.com>
 <20160925075524.GA3870@yogzotot>
 <20160926175000.GF16983@twin.jikos.cz>
 <20160929122148.GA22109@yogzotot>
 <57ED0EAA.7070206@applied-asynchrony.com>
 <CADxRZqwp4DPy8xcz7W=NOvvx0QnZ1jCvWRSMo1OMrxhiDrSorA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CADxRZqwp4DPy8xcz7W=NOvvx0QnZ1jCvWRSMo1OMrxhiDrSorA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 29, 2016 at 04:02:35PM +0300, Anatoly Pugachev wrote:
> > Try to add https://patchwork.kernel.org/patch/9332707/ aka
> > "Btrfs: improve check_node to avoid reading corrupted nodes" which should return
> > -EIO and prevent the BUG().
> 
> Guys,
> 
> I was wrong with "Btrfs: remove unnecessary btrfs_mark_buffer_dirty in
> split_leaf" , because I've used patch from email
> https://marc.info/?l=linux-btrfs&m=147319873029152&w=2 which patches
> fs/btrfs/ctree.c , but forgot to apply kdave git kernel commit
> 1ba98d086fe3a14d6a31f2f66dbab70c45d00f63 "Btrfs: detect corruption
> when non-root leaf has zero item"
> 
> :-/
> 
> Should I remake all the tests?

It would be much appreciated, as we probably won't get any other sparc64
testing. Thanks.
