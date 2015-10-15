Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:35505 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbbJOTE5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 15:04:57 -0400
Received: by igbkq10 with SMTP id kq10so1797953igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 12:04:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_mGHBzdevkaj8DHh=2Hkan8CVHmHrTak53UheaBH9pwLA@mail.gmail.com>
References: <2402569.dCkKzGyGNU@hoefnix>
	<CAC=t97Awr6-pWGAXEMaRfFnPGKJiPyRH2g39oN+0WzhNYFrBNg@mail.gmail.com>
	<561EBC3D.8060004@bouton.name>
	<CAC=t97COVc4kQ+A-jSVr3ujGb-0WGNh2qCcohBvLFw=YtnObhA@mail.gmail.com>
	<CAGfcS_nid0dz2V+H=gAb-diRxwfj4sdYgCp6hR+5wucCwQHAWw@mail.gmail.com>
	<CAJCQCtR2-q3NUcDi6bfQUTzChu6wEbozvYEB_eNuK8toMf7KQQ@mail.gmail.com>
	<CAGfcS_mGHBzdevkaj8DHh=2Hkan8CVHmHrTak53UheaBH9pwLA@mail.gmail.com>
Date: Thu, 15 Oct 2015 13:04:56 -0600
Message-ID: <CAJCQCtQND1svQxRheLxSGMyf6iJLp8tpfZXW=pc+5-xHYsL00w@mail.gmail.com>
Subject: Re: RAID6 stable enough for production?
From: Chris Murphy <lists@colorremedies.com>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 15, 2015 at 10:40 AM, Rich Freeman
<r-btrfs@thefreemanclan.net> wrote:
> On Wed, Oct 14, 2015 at 9:47 PM, Chris Murphy <lists@colorremedies.com> wrote:
>>
>> For that matter, now that GlusterFS has checksums and snapshots...
>
> Interesting - I haven't kept up with that.  Does it actually do
> end-to-end checksums?  That is, compute the checksum at the time of
> storage, store the checksum in the metadata somehow, and ensure the
> checksum matches when data is retrieved?

http://www.gluster.org/community/documentation/index.php/Features/BitRot

It could be argued that since checksums are computed after writing, that
SDC has already happened by the time the checksum is computed and written
(I also don't know if the metadata itself is checksummed so the checksum
could be wrong maybe and we don't know that?).

But yes it's stored checksum. It can be enabled to check on read/open but
by default it only does verification with scrubs. And the checksums are per
file, and are SHA256 based. So it's different than Btrfs, and it's passive.
But it's there.


-- 
Chris Murphy
