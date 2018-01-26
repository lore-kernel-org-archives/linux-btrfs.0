Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41279 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751257AbeAZWDc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 17:03:32 -0500
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: degraded permanent mount option
From: Christophe Yayon <cyayon@nbux.org>
In-Reply-To: <CAJCQCtR-ip1egtG9bMypWfvB=etoAV1JDP0SFdxHC0A=NG-t8g@mail.gmail.com>
Date: Fri, 26 Jan 2018 23:03:27 +0100
Cc: Christophe Yayon <cyayon-list@nbux.org>,
        "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <BF542664-8297-4BDC-AE30-330E880495C7@yayon.me>
References: <1516975360.4083556.1249069832.1B287A04@webmail.messagingengine.com> <CAJCQCtR-ip1egtG9bMypWfvB=etoAV1JDP0SFdxHC0A=NG-t8g@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Thanks for this complete answer.

I have to do some benchmark with mdadm raid and btrfs native raid...

Thanks

--
Christophe Yayon

> On 26 Jan 2018, at 22:54, Chris Murphy <lists@colorremedies.com> wrote:
> 
>> On Fri, Jan 26, 2018 at 7:02 AM, Christophe Yayon <cyayon-list@nbux.org> wrote:
>> 
>> Just a little question about "degraded" mount option. Is it a good idea to add this option (permanent) in fstab and grub rootflags for raid1/10 array ? Just to allow the system to boot again if a single hdd fail.
> 
> No because it's going to open a window where a delayed member drive
> will mean the volume is mounted degraded, which will happen silently.
> And current behavior in such a case, any new writes go to single
> chunks. Again it's silent. When the delayed drive appears, it's not
> going to be added, the volume is still treated as degraded. And even
> when you remount to bring them all together in a normal mount, Btrfs
> will not automatically sync the drives, so you will still have some
> single chunk writes on one drive not the other. So you have a window
> of time where there can be data loss if a real failure occurs, and you
> need degraded mounting. Further, right now Btrfs will only do one
> degraded rw mount, and you *must* fix that degradedness before it is
> umounted or else you will only ever be able to mount it again ro.
> There are unmerged patches to work around this, so you'd need to
> commit to building your own kernel. I can't see any way of reliably
> using Btrfs in production for the described use case otherwise. You
> can't depend on getting the delayed or replacement drive restored, and
> the volume made healthy again, because ostensibly the whole point of
> the setup is having good uptime and you won't have that assurance
> unless you carry these patches.
> 
> Also note that there are two kinds of degraded writes. a.) drive was
> missing at mount time, and volume is mounted degraded, for raid1
> volumes you get single chunks written; to sync once the missing drive
> appears you do a btrfs balance -dconvert=raid1,soft
> -mconvert=raid1,soft which should be fairly fast; b.) if the drive
> goes missing after a normal mount, Btrfs continues to write out raid1
> chunks; to sync once the missing drive appears you have to do a full
> scrub or balance of the entire volume there's no shortcut.
> 
> Anyway, for the described use case I think you're better off with
> mdadm or LVM raid1 or raid10, and then format with Btrfs and DUP
> metadata (default mkfs) in which case you get full error detection and
> metadata error detection and correction, as well as the uptime you
> want.
> 
> -- 
> Chris Murphy

