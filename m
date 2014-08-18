Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailsec104.isp.belgacom.be ([195.238.20.100]:37240 "EHLO
	mailsec104.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbaHRQxK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Aug 2014 12:53:10 -0400
Date: Mon, 18 Aug 2014 18:53:08 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Zach Brown <zab@zabbo.net>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Message-ID: <749953430.240415.1408380788296.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20140805213214.GH18659@lenny.home.zabbo.net>
References: <1405451837-8235-1-git-send-email-fabf@skynet.be> <20140716172021.GA10833@lenny.home.zabbo.net> <1762701571.679094.1405622254558.open-xchange@webmail.nmp.skynet.be> <20140717190152.GB24196@lenny.home.zabbo.net> <20140802142449.15f4cfc2c2821e90e04e175e@skynet.be> <20140804183158.GA18659@lenny.home.zabbo.net> <2069847253.202465.1407230425329.open-xchange@webmail.nmp.skynet.be> <20140805213214.GH18659@lenny.home.zabbo.net>
Subject: Re: [PATCH 1/1] Btrfs: fix sparse warning
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> On 05 August 2014 at 23:32 Zach Brown <zab@zabbo.net> wrote:
>
>
> > > > Hello Zach,
> > > >
> > > >     Here's an untested patch which
> > >
> > > Try testing it.  It's easy with virtualization and xfstests.
> > >
> > > You'll find that sending to a file fails because each individual file
> > > write call that makes up a send starts at offset 0 -- at the start of
> > > the file.
> > >
> > > Getting this right means getting the semantics around updating the send
> > > descriptors f_pos right.  It requires having a bit of a think about send
> > > semantics and f_pos update locking.
> >
> > Thanks for those informations Zach,
> >
> > I've tried btrfs test scripts related to ioctl in xfstests (tests/btrfs/025,
> > 035, 052, 055)
> > but was not able to trigger that problem. Do I have to create another
> > script,
> > use some generic one
> > or maybe use big test/scratch devices ?
>
> No idea, sorry.  Maybe your patch is fine and I'm a dummy.  Maybe you
> didn't test the kernel you thought you were testing.  Maybe the test
> doesn't test what you changed.  You'll have to do some investigating to
> find out.

After checking both kernel and btrfs-progs, it seems file offset is only being
passed through TLV(see send.c/ send_write/
TLV_PUT_U64(BTRFS_SEND_A_FILE_OFFSET). Tell me if I'm wrong but when we do
'btrfs send backup  | btrfs receive backupvolume',
btrfs-progs calls btrfs_ioctl_send emitting several BTRFS_SEND_C_WRITE with
relevant BTRFS_SEND_A_FILE_OFFSET (growing by 48kb). At the other side of | ,
'btrfs receive' executes read_and_process_cmd which does TLV_GET before
s->ops->write. All btrfs interactions being done with | maybe we could simply
replace vfs_write stuff as you suggested and remove sctx->send_off ?

Regards,
Fabian 

>
> - z
