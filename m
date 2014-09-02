Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37547 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaIBMzH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 08:55:07 -0400
Received: by mail-ig0-f178.google.com with SMTP id hn18so7147350igb.5
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Sep 2014 05:55:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140902012222.GA21405@infradead.org>
References: <CAEp=YLgzsLbmEfGB5YKVcHP4CQ-_z1yxnZ0tpo7gjKZ2e1ma5g@mail.gmail.com>
	<20140902000822.GA20473@dastard>
	<20140902012222.GA21405@infradead.org>
Date: Tue, 2 Sep 2014 08:55:07 -0400
Message-ID: <CAA8KC9Lgjf_FBXnKAaJtp6=NCWsoCFOobgi5b84BXfAcbgynJQ@mail.gmail.com>
Subject: Re: ext4 vs btrfs performance on SSD array
From: Zack Coffey <clickwir@gmail.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While I'm sure some of those settings were selected with good reason,
maybe there can be a few options (2 or 3) that have some basic
intelligence at creation to pick a more sane option.

Some checks to see if an option or two might be better suited for the
fs. Like the RAID5 stripe size. Leave the default as is, but maybe a
quick speed test to automatically choose from a handful of the most
common values. If they fail or nothing better is found, then apply the
default value just like it would now.


On Mon, Sep 1, 2014 at 9:22 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Sep 02, 2014 at 10:08:22AM +1000, Dave Chinner wrote:
>> Pretty obvious difference: avgrq-sz. btrfs is doing 512k IOs, ext4
>> and XFS are doing is doing 128k IOs because that's the default block
>> device readahead size.  'blockdev --setra 1024 /dev/sdd' before
>> mounting the filesystem will probably fix it.
>
> Btw, it's really getting time to make Linux storage fs work out the
> box.  There's way to many things that are stupid by default and we
> require everyone to fix up manually:
>
>  - the ridiculously low max_sectors default
>  - the very small max readahead size
>  - replacing cfq with deadline (or noop)
>  - the too small RAID5 stripe cache size
>
> and probably a few I forgot about.  It's time to make things perform
> well out of the box..
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
