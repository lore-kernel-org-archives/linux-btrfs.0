Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36006 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S945755AbcJaTqS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2016 15:46:18 -0400
Date: Mon, 31 Oct 2016 13:44:55 -0600
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@codemonkey.org.uk>, Jens Axboe <axboe@fb.com>,
        "Andy Lutomirski" <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161031194454.GA49877@clm-mbp.thefacebook.com>
References: <20161026224025.mou27kki4bslftli@codemonkey.org.uk>
 <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
 <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com>
 <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
 <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 31, 2016 at 12:35:16PM -0700, Linus Torvalds wrote:
>On Mon, Oct 31, 2016 at 11:55 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
>>
>> BUG: Bad page state in process kworker/u8:12  pfn:4e0e39
>> page:ffffea0013838e40 count:0 mapcount:0 mapping:ffff8804a20310e0 index:0x100c
>> flags: 0x400000000000000c(referenced|uptodate)
>> page dumped because: non-NULL mapping
>
>Hmm. So this seems to be btrfs-specific, right?
>
>I searched for all your "non-NULL mapping" cases, and they all seem to
>have basically the same call trace, with some work thread doing
>writeback and going through btrfs_writepages().
>
>Sounds like it's a race with either fallocate hole-punching or
>truncate. I'm not seeing it, but I suspect it's btrfs, since DaveJ
>clearly ran other filesystems too but I am not seeing this backtrace
>for anything else.

Agreed, I think this is a separate bug, almost certainly btrfs specific.  
I'll work with Dave on a better reproducer.

-chris
