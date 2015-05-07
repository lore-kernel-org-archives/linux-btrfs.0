Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:32769 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbbEGTGh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 May 2015 15:06:37 -0400
Received: by igbpi8 with SMTP id pi8so17286965igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 07 May 2015 12:06:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150426111943.GZ18187@carfax.org.uk>
References: <1430043165-20641-1-git-send-email-lauri.vosandi@gmail.com>
	<20150426111943.GZ18187@carfax.org.uk>
Date: Thu, 7 May 2015 22:06:37 +0300
Message-ID: <CAJ1pDqRz=ZuhCDvnAZUX7uxiU=7Uo8cHf-dqAgHRc62LC5HN8A@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: receive explicit parent support
From: lauri <lauri.vosandi@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Lauri_V=F5sandi?= <lauri.vosandi@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Even if the UUID stuff gets fixed there will be plenty of machines
which are unable to adapt the new approach due to conflicting
received_uuid values and having the option to specify -p would help
them to work around the issue to adapt to new received_uuid scheme
