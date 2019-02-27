Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C48F6C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 12:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 945E02087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 12:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbfB0MVU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 07:21:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:34038 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbfB0MVU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 07:21:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7AB2AAC96;
        Wed, 27 Feb 2019 12:21:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B408FDA83C; Wed, 27 Feb 2019 13:22:35 +0100 (CET)
Date:   Wed, 27 Feb 2019 13:22:35 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5.1 00/12] btrfs: Enhancement to tree block validation
Message-ID: <20190227122235.GE24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190218052753.24138-1-wqu@suse.com>
 <20190222151832.GG9874@twin.jikos.cz>
 <29397247-a244-ea7c-3c34-8e65642b927c@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <29397247-a244-ea7c-3c34-8e65642b927c@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 23, 2019 at 08:47:09AM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/2/22 下午11:18, David Sterba wrote:
> > On Mon, Feb 18, 2019 at 01:27:41PM +0800, Qu Wenruo wrote:
> >> v5.1:
> >> - Add "block=%llu " output for write/read time error line.
> >> - Also output read time error message for fsid/start/level check.
> > 
> > I see reports from tests btrfs/124 and btrfs/125,
> 
> That two tests are RAID1 reconstruction.
> It's known to trigger read error on missing devices.
> 
> Especially for bytenr mismatch, as all read from missing device will
> result 0 filled page.
> 
> I could change the read time error message to skip bytenr/csum mismatch
> to avoid such report.

Yeah the output needs some tuning. See the example below.
> 
> > [ 2860.001694] BTRFS info (device vdb): read error corrected: ino 0 off 32161792 (dev /dev/vdc sector 21856)                                                                                                   
> > [ 2860.007079] BTRFS info (device vdb): read error corrected: ino 0 off 32165888 (dev /dev/vdc sector 21864)                                                                                                   
> > [ 2860.012447] BTRFS info (device vdb): read error corrected: ino 0 off 32169984 (dev /dev/vdc sector 21872)                                                                                                   
> > [ 2860.017817] BTRFS info (device vdb): read error corrected: ino 0 off 32174080 (dev /dev/vdc sector 21880)                                                                                                   
> > [ 2860.023669] BTRFS error (device vdb): bad tree block start, want 32243712 have 0
> > [ 2860.027865] BTRFS error (device vdb): block=32243712 read time tree block corruption detected
> > [ 2860.032961] BTRFS info (device vdb): read error corrected: ino 0 off 32243712 (dev /dev/vdc sector 22016)                                                                                                   
> > [ 2860.037602] BTRFS info (device vdb): read error corrected: ino 0 off 32247808 (dev /dev/vdc sector 22024)                                                                                                   
> > [ 2860.042185] BTRFS info (device vdb): read error corrected: ino 0 off 32251904 (dev /dev/vdc sector 22032)                                                                                                   
> > [ 2860.046738] BTRFS info (device vdb): read error corrected: ino 0 off 32256000 (dev /dev/vdc sector 22040)                                                                                                   
> > [ 2860.089197] BTRFS info (device vdb): balance: start -d -m -s
> > [ 2860.092227] BTRFS info (device vdb): relocating block group 2479882240 flags data
> > [ 2860.098064] BTRFS error (device vdb): bad tree block start, want 31653888 have 0
> > [ 2860.102289] BTRFS error (device vdb): block=31653888 read time tree block corruption detected
> > [ 2860.107409] BTRFS info (device vdb): read error corrected: ino 0 off 31653888 (dev /dev/vdc sector 20864)                                                                                                   
> > [ 2860.111997] BTRFS info (device vdb): read error corrected: ino 0 off 31657984 (dev /dev/vdc sector 20872)                                                                                                   
> > [ 2860.166451] BTRFS error (device vdb): bad tree block start, want 31670272 have 0
> > [ 2860.167172] BTRFS error (device vdb): bad tree block start, want 31686656 have 0
> > [ 2860.167375] BTRFS error (device vdb): bad tree block start, want 31703040 have 0
> > [ 2860.167377] BTRFS error (device vdb): block=31703040 read time tree block corruption detected
> > [ 2860.167384] BTRFS error (device vdb): bad tree block start, want 31719424 have 0
> > [ 2860.167386] BTRFS error (device vdb): block=31719424 read time tree block corruption detected
> > [ 2860.167394] BTRFS error (device vdb): bad tree block start, want 31735808 have 0
> > [ 2860.167396] BTRFS error (device vdb): block=31735808 read time tree block corruption detected
> > [ 2860.170120] BTRFS error (device vdb): block=31670272 read time tree block corruption detected
> > [ 2860.174308] BTRFS error (device vdb): block=31686656 read time tree block corruption detected
> > [ 2860.205288] BTRFS error (device vdb): bad tree block start, want 31686656 have 0
> > [ 2860.208875] BTRFS error (device vdb): block=31686656 read time tree block corruption detected
> > [ 2860.244462] BTRFS error (device vdb): bad tree block start, want 31703040 have 0
> > [ 2860.248013] BTRFS error (device vdb): block=31703040 read time tree block corruption detected
> > [ 2860.284017] BTRFS error (device vdb): block=31719424 read time tree block corruption detected
> > [ 2860.315705] BTRFS error (device vdb): block=31735808 read time tree block corruption detected
> > [ 2860.336001] BTRFS error (device vdb): block=31752192 read time tree block corruption detected

Block 31752192 does not have any previous message about a specific error
(unlike the 'bad tree block' messages of other blocks). I don't think
it's good to print just the 'read time' message.

> > [ 2860.336054] BTRFS error (device vdb): block=31768576 read time tree block corruption detected
> > [ 2860.339786] BTRFS error (device vdb): block=31784960 read time tree block corruption detected
> > [ 2860.366693] BTRFS error (device vdb): block=31768576 read time tree block corruption detected
> > [ 2860.389495] BTRFS error (device vdb): block=31784960 read time tree block corruption detected
> > [ 2860.418551] BTRFS error (device vdb): block=31866880 read time tree block corruption detected
> > [ 2860.418713] BTRFS error (device vdb): block=31883264 read time tree block corruption detected
> > [ 2860.418721] BTRFS error (device vdb): block=31916032 read time tree block corruption detected
> > [ 2860.418736] BTRFS error (device vdb): block=31932416 read time tree block corruption detected
> > [ 2860.418744] BTRFS error (device vdb): block=31948800 read time tree block corruption detected
> > [ 2860.419721] BTRFS error (device vdb): block=31899648 read time tree block corruption detected
> > [ 2860.462401] BTRFS error (device vdb): block=31866880 read time tree block corruption detected
> > [ 2860.490821] BTRFS error (device vdb): block=31932416 read time tree block corruption detected
> > [ 2860.506718] BTRFS error (device vdb): block=31899648 read time tree block corruption detected
> > [ 2860.535013] BTRFS error (device vdb): block=31916032 read time tree block corruption detected
> > [ 2860.568602] BTRFS error (device vdb): block=31948800 read time tree block corruption detected
> > [ 2860.590434] BTRFS error (device vdb): block=31965184 read time tree block corruption detected
> > [ 2860.590532] BTRFS error (device vdb): block=31981568 read time tree block corruption detected
> > [ 2860.590677] BTRFS error (device vdb): block=31997952 read time tree block corruption detected
> > [ 2860.590688] BTRFS error (device vdb): block=32014336 read time tree block corruption detected
> > 
> > [ 2860.590697] BTRFS error (device vdb): block=32030720 read time tree block corruption detected
> > [ 2860.590705] BTRFS error (device vdb): block=32047104 read time tree block corruption detected
> > [ 2860.625834] BTRFS error (device vdb): block=31965184 read time tree block corruption detected
> > [ 2860.658723] BTRFS error (device vdb): block=31981568 read time tree block corruption detected
> > [ 2860.696644] BTRFS error (device vdb): block=32014336 read time tree block corruption detected
> > [ 2860.735014] BTRFS error (device vdb): block=32030720 read time tree block corruption detected
> > [ 2860.743240] BTRFS error (device vdb): block=32096256 read time tree block corruption detected
> > [ 2860.780296] BTRFS error (device vdb): block=32047104 read time tree block corruption detected
> > [ 2860.807073] BTRFS error (device vdb): block=32063488 read time tree block corruption detected
> > [ 2860.807173] BTRFS error (device vdb): block=32079872 read time tree block corruption detected
> > [ 2860.841582] BTRFS error (device vdb): block=32079872 read time tree block corruption detected

This long sequence of messages lacks details about what happen, and
there are duplicates (block 32079872). If this is caused by reads from
missing device, this can potentially flood the logs.
