Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58855 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2JSP3B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 11:29:01 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so810877iea.19
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Oct 2012 08:29:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121018132850.GA22010@shiny>
References: <CAK0PdAk3+wPR_MerCNFgCvCC01c1RJ31=Z=G9=hT5eyYfn=iNg@mail.gmail.com>
 <20121018132850.GA22010@shiny>
From: Marguerite Su <i@marguerite.su>
Date: Fri, 19 Oct 2012 23:28:40 +0800
Message-ID: <CAK0PdAkbtT=PynBi0KjEsDBGy4U1RhBmWf5uQRQYQ3Z-M__nvg@mail.gmail.com>
Subject: Re: initramfs take a long time to load[135s]
To: Chris Mason <chris.mason@fusionio.com>, Marguerite Su <i@marguerite.su>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 18, 2012 at 9:28 PM, Chris Mason <chris.mason@fusionio.com> wrote:
> If it isn't the free space cache, it'll be a fragmentation problem.  The
> easiest way to tell the difference is to get a few sysrq-w snapshots
> during the boot.

Hi, Chris,

with some help from openSUSE community, I learnt what's sysrq
snapshots(alt+printscreen+w in tty1)...

and here's my log:

http://paste.opensuse.org/31094916

can you help look through this?

Many thanks!

Marguerite
