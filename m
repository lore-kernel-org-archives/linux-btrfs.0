Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33406 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbbKXEbv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 23:31:51 -0500
Received: by lfaz4 with SMTP id z4so5873632lfa.0
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2015 20:31:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1448337754.14125.33.camel@scientia.net>
References: <1448337754.14125.33.camel@scientia.net>
Date: Tue, 24 Nov 2015 12:31:49 +0800
Message-ID: <CAP9B-QnjCum8dftQdG1Cx90btt0Jk+8aAq13f6qEoDL1TshyOw@mail.gmail.com>
Subject: Re: shall distros run btrfsck on boot?
From: Wang Shilong <wangshilong1991@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 24, 2015 at 12:02 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> Hey.
>
> Short question since that came up on debian-devel.
>
> Now that btrfs check get's more and more useful, are the developers
> going to recommend running it periodically on boot (of course that
> wouldn't work right now, as it would *always* check)?
>
> Plus... is btrfs check (without any arguments) non-desctructive, or are
> there corner-cases where it may lead to any changes on the devices?

As far as i know, 'btrfs check' did not repair anything in default.
only output errors if repair options not specified.

Regards,
Shilong
>
> Thanks,
> Chris.
