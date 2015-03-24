Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:33584 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363AbbCXQKR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 12:10:17 -0400
Received: by yhpt93 with SMTP id t93so86752166yhp.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2015 09:10:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150323211334.GA11155@ret.masoncoding.com>
References: <CAJCQCtSmjNVWZaqKr_NcOnpRbSn8mzfutz5jeTDrk=qAT-Z2Vw@mail.gmail.com>
	<20150323211334.GA11155@ret.masoncoding.com>
Date: Tue, 24 Mar 2015 10:10:16 -0600
Message-ID: <CAJCQCtRRtOoTUNAwyN56615y_uOyCLwXG13KWy=g1CCiDrH=BA@mail.gmail.com>
Subject: Re: kvm bug, guest I/O blk device errors when qcow2 backing file is
 on Btrfs
From: Chris Murphy <chris@colorremedies.com>
To: Chris Mason <clm@fb.com>, Chris Murphy <chris@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 23, 2015 at 3:13 PM, Chris Mason <clm@fb.com> wrote:
> On Mon, Mar 23, 2015 at 02:01:41PM -0600, Chris Murphy wrote:
>> I can't tell if this is a kvm virtio blk device regression, with
>> cache=none and cache=directsync, or if it's a Btrfs regression.
>>
>> The summary is that on a host using (Fedora) kernel 3.18.9, 3.19.2, or
>> any 4.0.0 kernel, with qcow2 on Btrfs, and either cache=none or
>> directsync, the guest Linux OS experiences many I/O blk device errors.
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=1204569
>>
>> If I put the qcow2 on XFS, the problem doesn't happen.
>>
>> If I keep the qcow2 on Btrfs, and change the cache= to writeback,
>> writethrough, or unsafe, the problem doesn't happen.
>>
>> It happens with either qcow2 compat 0.10 or 1.1. Raw files were not
>> tested. And block devices other than virtio were not tested.
>>
>> In the guest, all file systems experience this and complain, some more
>> than others. Btrfs is most tolerant mainly reporting write errors but
>> completes an OS installation; ext4 complains a lot but also completes
>> an OS installation; XFS complains and eventually gives up with a
>> hardware I/O error and the OS installation fails.
>>
>> I did this test maybe two years ago and this combination was safe at that time.
>
> The last time we tracked down a similar problem, Josef found it was only
> on windows guests.  Basically he tracked it down to buffers changing
> while in flight.  I'll take a look.

Looks like cache=none and directsync share O_DIRECT in common.

This patch suggests neither of those cache options should be used (for
different reasons).
https://github.com/libguestfs/libguestfs/commit/749e947bb0103f19feda0f29b6cbbf3cbfa350da

I stumbled on this testing GNOME Boxes which is using cache=none,
which it probably shouldn't, but nevertheless none and directsync also
shouldn't cause problems on Btrfs.


-- 
Chris Murphy
