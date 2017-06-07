Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:55392 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751444AbdFGNsv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Jun 2017 09:48:51 -0400
Date: Wed, 7 Jun 2017 18:48:48 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Adam Borowski <kilobyte@angband.pl>
Cc: "Stefan G. Weichinger" <lists@xunil.at>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: getting rid of "csum failed" on a hw raid
Message-ID: <20170607184848.6218c92f@natsu>
In-Reply-To: <20170607130902.q3stj6wj52duvmr2@angband.pl>
References: <5693147c-befc-da58-cb20-6af31e9aa9cb@xunil.at>
        <CAGqmi76XY0+sYZb3XaDs3rHKzZa=t2kzaGCE+uq_K4vz7PK5_A@mail.gmail.com>
        <b8195f2f-adf8-4eb6-2d48-ac6bb5f182fd@xunil.at>
        <CAGqmi77URH-XTW7fCB+NqzcSb-Y+LvwuvQep+CRJ6_ENgRtWRQ@mail.gmail.com>
        <20170607130902.q3stj6wj52duvmr2@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 7 Jun 2017 15:09:02 +0200
Adam Borowski <kilobyte@angband.pl> wrote:

> On Wed, Jun 07, 2017 at 01:10:26PM +0300, Timofey Titovets wrote:
> > 2017-06-07 13:05 GMT+03:00 Stefan G. Weichinger <lists@xunil.at>:
> > > Am 2017-06-07 um 11:37 schrieb Timofey Titovets:
> > >
> > >> btrfs scrub start /mnt_path do this trick
> > >>
> > >> After, you can find info with paths in dmesg
> > >
> > > thank you, I think I have the file, it's a qemu-img-file.
> > > I try cp-ing it to another fs first, but assume this will fail, right?
> > 
> > Yes, because btrfs will return -EIO
> > So try dd_rescue
> 
> Or even plain dd conv=noerror.  Both will do a faithful analogue of a
> physical disk with a silent data corruption on the affected sectors.

Yeah, except "plain dd conv=noerror" will produce a useless corrupted image,
because it will be shifted forward by the number of unreadable bytes after the
first error.

You also need the "sync" flag in there.
https://superuser.com/questions/622541/what-does-dd-conv-sync-noerror-do
http://www.debianadmin.com/recover-data-from-a-dead-hard-drive-using-dd.html
https://wiki.archlinux.org/index.php/disk_cloning
Or just stick with dd_rescue and not try to correct people's perfectly good
suggestions with completely wrong and harmful ones.

-- 
With respect,
Roman
