Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:32776 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752798AbdEHTa1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 15:30:27 -0400
Received: by mail-yw0-f173.google.com with SMTP id 203so34486512ywe.0
        for <linux-btrfs@vger.kernel.org>; Mon, 08 May 2017 12:30:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPktuGuQHoaVELgyLtEzt63ccQYhoDWrNH49KmWeExmutHHJ=Q@mail.gmail.com>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <706980A2-DC62-45AA-B169-8A9D6E474D87@seangreenslade.com> <CAPktuGuyUBQF1=LKvmpZiS7vMSsu=LCfqA9PFa7ObK9ih=LoXg@mail.gmail.com>
 <20170508112617.7e33bed6@ad> <A9D2210F-3DC4-45BC-AA07-D4527279D40E@seangreenslade.com>
 <4aedf23f-2bc4-ce18-d5b0-13fa51496feb@gmail.com> <20170508170106.GA1699@fox>
 <CAPktuGtS-K9ZvXf_3G5UkS2Xrj-cWx+DaqrFDOu-Hi9r1HqUKw@mail.gmail.com>
 <20170508190257.GB1699@fox> <CAPktuGuQHoaVELgyLtEzt63ccQYhoDWrNH49KmWeExmutHHJ=Q@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 8 May 2017 13:30:25 -0600
Message-ID: <CAJCQCtQZ3Ww+sNXbJ3W_+U4_6SaOD-6Ue0-VGEapXb3hd-GfUQ@mail.gmail.com>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
To: Alexandru Guzu <alexguzu@gmail.com>
Cc: Sean Greenslade <sean@seangreenslade.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Sanidhya Solanki <lkml.page@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 8, 2017 at 1:15 PM, Alexandru Guzu <alexguzu@gmail.com> wrote:
> Also I was unable to find a way to send-receive a snapshot to the root
> subvolume of a different disk. Is this possible?


btrfs send /mnt/brick1/root.20170508 | btrfs receive /mnt/brick2

You need to snapshot it again to make it a read-write snapshot, and
then move the contents wherever you want, if you do not want to boot a
subvolume directly; and rather boot from the top level subvolume.

Each subvolume is a separate fs tree, so you need to have the top
level mounted if you want to do an efficient move which is really a cp
--reflink followed by rm, behind the scenes. I find it easy to just
boot subvolumes rather than booting from the top level (subvolume id
5, a.k.a. id 0), using rootflags=subvol=<nameofsubvol>.


-- 
Chris Murphy
