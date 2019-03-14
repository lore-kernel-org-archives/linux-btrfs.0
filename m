Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3F86C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 18:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA9302184C
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 18:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfCNS7C (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 14:59:02 -0400
Received: from mailgw-01.dd24.net ([193.46.215.41]:34599 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbfCNS7C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 14:59:02 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-01.dd24.net (Postfix) with ESMTP id 61D3760152;
        Thu, 14 Mar 2019 18:59:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-01.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.35])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
        with ESMTP id xAFxcjotqzRK; Thu, 14 Mar 2019 18:58:58 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-82-31.dynamic.mnet-online.de [82.135.82.31])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Thu, 14 Mar 2019 18:58:58 +0000 (UTC)
Message-ID: <6c388ca5944d8e679e66d2d889e594f6fc3ef68b.camel@scientia.net>
Subject: Re: Reproducer for "compressed data + hole data corruption bug,
 2018 edition" still works on 4.20.7
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Thu, 14 Mar 2019 19:58:56 +0100
In-Reply-To: <b701dc28-a703-7e7c-2ced-aad07e70850a@gmail.com>
References: <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
         <20190212165916.GA23918@hungrycats.org>
         <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
         <20190212181328.GB23918@hungrycats.org>
         <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
         <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
         <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com>
         <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
         <20190215054031.GC9995@hungrycats.org>
         <f9fddae4bc3d59e539b7bc56ae75a5f04a165682.camel@scientia.net>
         <20190307200712.GG23918@hungrycats.org>
         <b701dc28-a703-7e7c-2ced-aad07e70850a@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, 2019-03-08 at 07:20 -0500, Austin S. Hemmelgarn wrote:
> On 2019-03-07 15:07, Zygo Blaxell wrote:
> > Legacy POSIX doesn't have the hole-punching concept, so legacy
> > tools won't do it; however, people add features to GNU tools all
> > the
> > time, so it's hard to be 100% sure without downloading the code and
> > reading/auditing/scanning it.  I'm 99% sure cp and tar are OK.
> > 
> They are, the only things they do with sparse files are creating new 
> ones from scratch using the standard seek then write method.  The
> same 
> is true of a vast majority of applications as well.

Thanks for your confirmation.


>   The stuff most 
> people would have to worry about largely comes down to:
> 
> * VM software.  Some hypervisors such as QEMU can be configured to 
> translate discard commands issued against the emulated block devices
> to 
> fallocate calls to punch holes in the VM disk image file (and QEMU
> can 
> be configured to translate block writes of null bytes to this too), 
> though I know of none that do this by default.
> * Database software.  This is what stuff like punching holes
> originated 
> for, so it's obviously a potential source of this issue.
> * FUSE filesystem drivers.  Most of them that support the required 
> fallocate flag to punch holes pass it down directly.  Some make use
> of 
> it themselves too.
> * Userspace distributed storage systems.  Stuff like Ceph or
> Gluster. 
> Same arguments as above for FUSE filesystem drivers.

These do at least not affect me personally, though only because I
didn't use compress, where I use qemu (which I have configured to pass
on the TRIMs).


> > 'btrfs' (the command-line utility) doesn't do these operations as
> > far
> > as I can tell.  The kernel only does these when requested by
> > applications.
> The receive command will issue clone operations if the sent
> subvolume 
> requires it to get the correct block layout, so there is a 'regular' 
> BTRFS operation that can in theory set things up such that the
> required 
> patterns are more likely to happen.

As long as snapshoting itself doesn't create the issue, I should be
still safe at least on my master disks (which were always only the
source or send/receive), which I'll now compare to the backup disks


Thanks,
Chris.

