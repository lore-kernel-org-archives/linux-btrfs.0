Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34275 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751463AbcJAJ0h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Oct 2016 05:26:37 -0400
MIME-Version: 1.0
In-Reply-To: <20160929142945.GC5531@suse.cz>
References: <cover.1474580472.git.osandov@fb.com> <20160925075524.GA3870@yogzotot>
 <20160926175000.GF16983@twin.jikos.cz> <20160929122148.GA22109@yogzotot>
 <57ED0EAA.7070206@applied-asynchrony.com> <CADxRZqwp4DPy8xcz7W=NOvvx0QnZ1jCvWRSMo1OMrxhiDrSorA@mail.gmail.com>
 <20160929142945.GC5531@suse.cz>
From: Anatoly Pugachev <matorola@gmail.com>
Date: Sat, 1 Oct 2016 12:26:35 +0300
Message-ID: <CADxRZqwZ6ymxL4x9455HFH95px=bjuqKKfBrO9BO7y1VBkvrYw@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Btrfs: free space tree and sanity test fixes
To: dsterba@suse.cz, Anatoly Pugachev <matorola@gmail.com>,
        =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
        Omar Sandoval <osandov@osandov.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>, bo.li.liu@oracle.com,
        fstests@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 29, 2016 at 5:29 PM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Sep 29, 2016 at 04:02:35PM +0300, Anatoly Pugachev wrote:
>> > Try to add https://patchwork.kernel.org/patch/9332707/ aka
>> > "Btrfs: improve check_node to avoid reading corrupted nodes" which should return
>> > -EIO and prevent the BUG().
>>
>> Guys,
>>
>> I was wrong with "Btrfs: remove unnecessary btrfs_mark_buffer_dirty in
>> split_leaf" , because I've used patch from email
>> https://marc.info/?l=linux-btrfs&m=147319873029152&w=2 which patches
>> fs/btrfs/ctree.c , but forgot to apply kdave git kernel commit
>> 1ba98d086fe3a14d6a31f2f66dbab70c45d00f63 "Btrfs: detect corruption
>> when non-root leaf has zero item"
>>
>> :-/
>>
>> Should I remake all the tests?
>
> It would be much appreciated, as we probably won't get any other sparc64
> testing. Thanks.

David,

just tried to apply 1ba98d086fe3a14d6a31f2f66dbab70c45d00f63 "Btrfs:
detect corruption when non-root leaf has zero item"
from your btrfs development kernel tree, and patch command said that
it already applied...

mator@ttip:~/linux-2.6$ git remote -v
origin  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
(fetch)
origin  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
(push)
mator@ttip:~/linux-2.6$ git show -s --oneline
1ba98d086fe3a14d6a31f2f66dbab70c45d00f63
1ba98d0 Btrfs: detect corruption when non-root leaf has zero item

So my tests was correct and included all the needed patches?!

Sorry for the mess. :-/

I'm going to check patch suggested by Holger Hoffstätte ,
https://patchwork.kernel.org/patch/9332707/ ...
