Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:38618 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752951AbdFRL40 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Jun 2017 07:56:26 -0400
Received: from tux.wizards.de (p4FF5805F.dip0.t-ipconnect.de [79.245.128.95])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 67DC041602C8
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Jun 2017 13:56:25 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id D55A111C09CB
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Jun 2017 13:56:24 +0200 (CEST)
Subject: Re: [PATCH v3] btrfs: fiemap: Cache and merge fiemap extent before
 submit it to user
References: <20170407024315.30685-1-quwenruo@cn.fujitsu.com>
 <20170616123352.GF25451@twin.jikos.cz>
 <92aae99b-2c1a-2c66-1291-a0ef73c58b16@gmx.com>
 <20170617083058.7z67mw4622oa7ajo@angband.pl>
 <48fbf1c1-6b7b-a886-2355-bac5ec3f79ba@gmx.com>
 <20170617212451.w7i3xqjv4rie57dw@angband.pl>
 <2d08d805-9e8e-38b1-b1cd-b8ae31db058a@gmx.com>
 <5c63eef9-ff8e-6374-6a19-7e52f14dd18a@gmx.com>
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <6ceac7e1-09e6-55c2-6f3c-f0f9fda2615c@applied-asynchrony.com>
Date: Sun, 18 Jun 2017 13:56:24 +0200
MIME-Version: 1.0
In-Reply-To: <5c63eef9-ff8e-6374-6a19-7e52f14dd18a@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/18/17 13:23, Qu Wenruo wrote:
> Well, still no good news.
> 
> I created file extents which returns 0x2008 and the last extent with 0x9.
> But still failed to reproduce the error message.
> 
> BTW, I noticed that your output is a little strange.
> Normally we should have "offset=%llu phys=%llu len=%llu and flags=0x%x".
> 
> But your output seems a little out of shape.
> And further more, the len (if it's correct) is not aligned even to 512 bytes.
> 
> Seems something went wrong totally.

That seems to be a mail decoding/display problem at your side.
Adam's original mail contained:

  offset=0 phys=2435798867968 len=131072 flags=0x2008

So length looks fine.

-h
