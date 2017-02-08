Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:36693 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751921AbdBHRDg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 12:03:36 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:38448)
        by azure.uno.uk.net with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
        (Exim 4.87)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cbTbT-0006zC-SE
        for linux-btrfs@vger.kernel.org; Wed, 08 Feb 2017 14:52:15 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cbTVy-00083C-FY
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Feb 2017 14:46:34 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22683.12104.679173.639568@tree.ty.sabi.co.uk>
Date: Wed, 8 Feb 2017 14:46:32 +0000
To: linux-btrfs@vger.kernel.org
Subject: Re: understanding disk space usage
In-Reply-To: <7912da41-d58a-d57f-47cd-508bc709a761@cn.fujitsu.com>
References: <CALg=eG_C-Xkw+TTHpNq9y_euza81TPTd+YN10_V=9WSprN0BPw@mail.gmail.com>
        <7912da41-d58a-d57f-47cd-508bc709a761@cn.fujitsu.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> My system is or seems to be running out of disk space but I
>> can't find out how or why. [ ... ]
>> Filesystem            Size  Used Avail Use% Mounted on
>> /dev/sda3              28G   26G  2.1G  93% /
[ ... ]
> So from chunk level, your fs is already full.  And balance
> won't success since there is no unallocated space at all.

To add to this, 28GiB is a bit too small for Btrfs, because at
that point chunk size is 1GiB. I have the habit of sizing
partitions to an exact number of GiB, and that means that most
of 1GiB will never be used by Btrfs because there is a small
amount of space allocated that is smaller than 1GiB and thus
there will be eventually just less than 1GiB unallocated.
Unfortunately the chunk size is not manually settable.

Example here from 'btrfs fi usage':

Overall:
    Device size:                  88.00GiB
    Device allocated:             86.06GiB
    Device unallocated:            1.94GiB
    Device missing:                  0.00B
    Used:                         80.11GiB
    Free (estimated):              6.26GiB      (min: 5.30GiB)

That means that I should 'btrfs balance' now, because of the
1.94GiB "unallocated", 0.94GiB will never be allocated, and that
leaves just 1GiB "unallocated" which is the minimum for running
'btrfs balance'. I have just done so and this is the result:

Overall:
    Device size:                  88.00GiB
    Device allocated:             82.03GiB
    Device unallocated:            5.97GiB
    Device missing:                  0.00B
    Used:                         80.11GiB
    Free (estimated):              6.26GiB      (min: 3.28GiB)

At some point I had decided to use 'mixedbg' allocation to
reduce this problem and hopefully improve locality, but that
means that metadata and data need to have the same profile, and
I really want metadata to be 'dup' because of checksumming,
and I don't want data to be 'dup' too.

> [ ... ] To proceed, add a larger device to current fs, and do
> a balance or just delete the 28G partition then btrfs will
> handle the rest well.

Usually for this I use a USB stick, with a 1-3GiB partition plus
a bit extra because of that extra bit of space.

https://btrfs.wiki.kernel.org/index.php/FAQ#How_much_free_space_do_I_have.3F
https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21
marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html

Unfortunately if it is a single device volume and metadata is
'dup' to remove the extra temporary device one has first to
convert the metadata to 'single' and then back to 'dup' after
removal.

There are also some additional reasons why space used (rather
than allocated) may be larger than expected, in special but not
wholly infrequent cases. My impression is that the Btrfs design
trades space for performance and reliability.
