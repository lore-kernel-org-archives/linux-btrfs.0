Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36608 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbcI2NCi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Sep 2016 09:02:38 -0400
MIME-Version: 1.0
In-Reply-To: <57ED0EAA.7070206@applied-asynchrony.com>
References: <cover.1474580472.git.osandov@fb.com> <20160925075524.GA3870@yogzotot>
 <20160926175000.GF16983@twin.jikos.cz> <20160929122148.GA22109@yogzotot> <57ED0EAA.7070206@applied-asynchrony.com>
From: Anatoly Pugachev <matorola@gmail.com>
Date: Thu, 29 Sep 2016 16:02:35 +0300
Message-ID: <CADxRZqwp4DPy8xcz7W=NOvvx0QnZ1jCvWRSMo1OMrxhiDrSorA@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Btrfs: free space tree and sanity test fixes
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Cc: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, kernel-team@fb.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>, bo.li.liu@oracle.com,
        fstests@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 29, 2016 at 3:52 PM, Holger Hoffstätte
<holger@applied-asynchrony.com> wrote:
> On 09/29/16 14:21, Anatoly Pugachev wrote:
>>> ...
>>>
>>> This is fixed by patch
>>>
>>>   "Btrfs: remove unnecessary btrfs_mark_buffer_dirty in split_leaf"
>>>
>>> that's in the 4.9 queue. Other than that, the self-tests seem to pass,
>>> thanks for the test. Would be good if you can test with the mentioned
>>> patch included or without integrity checker. Thanks for testing.
>>
>> updated git kernel to v4.8-rc8-8-gae6dd8d , applied this
>> "Btrfs: free space tree and sanity test fixes" patchset and added/applied
>> "Btrfs: remove unnecessary btrfs_mark_buffer_dirty in split_leaf" :
>>
> (snip)
>> Sep 29 00:40:55 ttip kernel: BTRFS: device fsid 7bb81df9-0e2b-47f2-81ff-c08502d38da6 devid 1 transid 5 /dev/loop4
>> Sep 29 00:41:30 ttip kernel: BTRFS info (device loop4): disk space caching is enabled
>> Sep 29 00:41:30 ttip kernel: BTRFS info (device loop4): has skinny extents
>> Sep 29 00:41:30 ttip kernel: BTRFS info (device loop4): flagging fs with big metadata feature
>> Sep 29 00:41:30 ttip kernel: BTRFS info (device loop4): creating UUID tree
>> Sep 29 00:41:31 ttip kernel: BTRFS: device fsid d0ee7ca3-3be0-465f-857b-19e681181923 devid 1 transid 5 /dev/loop0
>> Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): enabling free space tree
>> Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): using free space tree
>> Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): has skinny extents
>> Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): flagging fs with big metadata feature
>> Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): creating free space tree
>> Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): setting 1 ro feature flag
>> Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): setting 2 ro feature flag
>> Sep 29 00:41:32 ttip kernel: BTRFS info (device loop0): creating UUID tree
>> Sep 29 00:41:32 ttip kernel: BTRFS critical (device loop4): corrupt leaf, non-root leaf's nritems is 0: block=29556736,root=1, slot=0
>> Sep 29 00:41:32 ttip kernel: BTRFS info (device loop4): leaf 29556736 total ptrs 0 free space 16283
>> Sep 29 00:41:32 ttip kernel: BTRFS: assertion failed: 0, file: fs/btrfs/disk-io.c, line: 4059kernel BUG at fs/btrfs/ctree.h:3369!
>
> Try to add https://patchwork.kernel.org/patch/9332707/ aka
> "Btrfs: improve check_node to avoid reading corrupted nodes" which should return
> -EIO and prevent the BUG().

Guys,

I was wrong with "Btrfs: remove unnecessary btrfs_mark_buffer_dirty in
split_leaf" , because I've used patch from email
https://marc.info/?l=linux-btrfs&m=147319873029152&w=2 which patches
fs/btrfs/ctree.c , but forgot to apply kdave git kernel commit
1ba98d086fe3a14d6a31f2f66dbab70c45d00f63 "Btrfs: detect corruption
when non-root leaf has zero item"

:-/

Should I remake all the tests?
