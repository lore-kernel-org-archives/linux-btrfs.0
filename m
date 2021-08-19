Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A893C4338F
	for <linux-btrfs@archiver.kernel.org>; Thu, 19 Aug 2021 10:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A66C61029
	for <linux-btrfs@archiver.kernel.org>; Thu, 19 Aug 2021 10:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbhHSKjF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 19 Aug 2021 06:39:05 -0400
Received: from mail.nic.cz ([217.31.204.67]:42394 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237863AbhHSKjF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Aug 2021 06:39:05 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Aug 2021 06:39:05 EDT
Received: from thinkpad (unknown [172.20.6.87])
        by mail.nic.cz (Postfix) with ESMTPSA id CF331140ADF;
        Thu, 19 Aug 2021 12:31:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1629369074; bh=MhcOVXUzYEbZLi3RqvH+H6lowtYKkw1bTPgZBx1+/+A=;
        h=Date:From:To;
        b=l7eZUUDut9Zj1FJ/lB6cTv+HvpmV04Yw+XbW6K5JewoweS+wIAOdLNI/45tdUQo9Z
         6iHJMCIUHtfxkrqxHrCxWmmxX26pvreb3rcEoBiGJmMPBmy91bonXYBFUInqHZCjk6
         hqkBnS/Q9RE68nn8okcsm72PagFF00A9u7831sy0=
Date:   Thu, 19 Aug 2021 12:31:13 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
To:     Simon Glass <sjg@chromium.org>
Cc:     U-Boot Mailing List <u-boot@lists.denx.de>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/11] btrfs: Suppress the message about missing
 filesystem
Message-ID: <20210819123113.152871a5@thinkpad>
In-Reply-To: <20210818214022.4.I3eb71025472bbb050bcf9a0a192dde1b6c07fa7f@changeid>
References: <20210819034033.1617201-1-sjg@chromium.org>
        <20210818214022.4.I3eb71025472bbb050bcf9a0a192dde1b6c07fa7f@changeid>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 18 Aug 2021 21:40:26 -0600
Simon Glass <sjg@chromium.org> wrote:

> This message comes up a lot when scanning filesystems. It suggests to the
> user that there is some sort of error, but in fact there is no reason to
> expect that a particular partition has a btrfs filesystem. Other
> filesystems don't print this error.
>=20
> Turn it into a debug message.
>=20
> Signed-off-by: Simon Glass <sjg@chromium.org>

Reviewed-by: Marek Beh=C3=BAn <marek.behun@nic.cz>

This must have been introduced after btrfs was reimplemented from the
btrfs-progs sources. I remember that I sent a patch fixing this same
issue for the previous implementation (or was it another filesystem?).

Marek
