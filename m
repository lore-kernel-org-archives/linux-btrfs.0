Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:32839 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbbIGSBX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Sep 2015 14:01:23 -0400
Received: by ykei199 with SMTP id i199so87450097yke.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2015 11:01:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRyN0zQXgCfdqB8af_S=sCWpkZTP6M9+Yb4mxOB-crBrA@mail.gmail.com>
References: <loom.20150904T230705-944@post.gmane.org>
	<20150904211738.GB23944@carfax.org.uk>
	<CAEyaVk+U5dFt79d_yd+LAujQLRsy8o7_VfPS+==uRPa_2f-oVg@mail.gmail.com>
	<20150905104253.GD23944@carfax.org.uk>
	<CAJCQCtRyN0zQXgCfdqB8af_S=sCWpkZTP6M9+Yb4mxOB-crBrA@mail.gmail.com>
Date: Mon, 7 Sep 2015 12:01:22 -0600
Message-ID: <CAJCQCtQ3k3q3_KVfEB9M9DTMMWcj6eaQnGe+1SEwuE-98mh8Lw@mail.gmail.com>
Subject: Re: unable to mount multi disk volume with recovery mode
From: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 7, 2015 at 11:58 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Sat, Sep 5, 2015 at 4:42 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>> On Sat, Sep 05, 2015 at 12:13:30PM +0200, Ivan Petrovic wrote:
>
>>> So you're saying that I can't make first and third partition to work
>>> with it's data? Maybe I'll try with btrfs-restore, do you think it can
>>> rescue this 2 drives?
>>
>>    Unlikely. Like I said, if the FS was using single storage for
>> everything, a random 33% of the filesystem has gone away. There's
>> probably not enough of it left to make anything coherent.
>
> With single profile for everything, is metadata and data guaranteed to
> be co-located on the same device? If not, then there's no way for this
> to be recovered. If they are, then I think recovery would depend on
> the system chunk always being device-n mirrored, which we don't have.

Sorry. In single device failure, raid1 system chunk is possible and
might help. But to be able to recover data from any surviving drive
(n-1 failures) would mean each device has a copy of the system chunk,
in addition to guaranteed co-location of data and metadata chunks.


-- 
Chris Murphy
