Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:51534 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbdFRNm2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Jun 2017 09:42:28 -0400
Date: Sun, 18 Jun 2017 15:42:19 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: Re: [PATCH v3] btrfs: fiemap: Cache and merge fiemap extent before
 submit it to user
Message-ID: <20170618134219.bnivsrpd4ai2nrxs@angband.pl>
References: <20170407024315.30685-1-quwenruo@cn.fujitsu.com>
 <20170616123352.GF25451@twin.jikos.cz>
 <92aae99b-2c1a-2c66-1291-a0ef73c58b16@gmx.com>
 <20170617083058.7z67mw4622oa7ajo@angband.pl>
 <48fbf1c1-6b7b-a886-2355-bac5ec3f79ba@gmx.com>
 <20170617212451.w7i3xqjv4rie57dw@angband.pl>
 <2d08d805-9e8e-38b1-b1cd-b8ae31db058a@gmx.com>
 <5c63eef9-ff8e-6374-6a19-7e52f14dd18a@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5c63eef9-ff8e-6374-6a19-7e52f14dd18a@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 18, 2017 at 07:23:00PM +0800, Qu Wenruo wrote:
> > > [   39.726215] BTRFS warning (device sda1): unhandled fiemap cache
> > > detected: offset=phys$35798867968 len1072 flags=0x2008

> > > [  151.882586] BTRFS warning (device sda1): unhandled fiemap cache
> > > detected: offset=phys$35798867968 len1072 flags=0x2008


> I created file extents which returns 0x2008 and the last extent with 0x9.
> But still failed to reproduce the error message.
> 
> BTW, I noticed that your output is a little strange.
> Normally we should have "offset=%llu phys=%llu len=%llu and flags=0x%x".
> 
> But your output seems a little out of shape.
> And further more, the len (if it's correct) is not aligned even to 512
> bytes.

[24031.309852] BTRFS warning (device sda1): unhandled fiemap cache detected: offset=0 phys=2012381351936 len=131072 flags=0x2008

Eh?  All the numbers in my mails not only match that printf format but also
are nice round numbers; len being always 128KB (not in just what I posted,
also in all other occurences).

But, in your replies there's '$'blahblab and 0x13"1072".

> Seems something went wrong totally.

Perhaps there's some mail client borkage?  I see it ok in my Sent mbox but
it could have been corrupted in transit or on your side.

Here's my current dmesg: http://sprunge.us/ajag


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
