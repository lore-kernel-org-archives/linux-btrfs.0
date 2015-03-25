Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36108 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbbCYBaw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 21:30:52 -0400
Received: by igbud6 with SMTP id ud6so88740224igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2015 18:30:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150323232212.GL31762@carfax.org.uk>
References: <meq6hm$lbh$1@ger.gmane.org>
	<20150323232212.GL31762@carfax.org.uk>
Date: Tue, 24 Mar 2015 21:30:52 -0400
Message-ID: <CAGfcS_=6iHH+4T6CH8ag6MSf2N5n37pE6USSOjDTv=BMmFHQaw@mail.gmail.com>
Subject: Re: btrfs dedup - available or experimental? Or yet to be?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Hugo Mills <hugo@carfax.org.uk>, Martin <m_btrfs@ml1.co.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 23, 2015 at 7:22 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Mar 23, 2015 at 11:10:46PM +0000, Martin wrote:
>> As titled:
>>
>>
>> Does btrfs have dedup (on raid1 multiple disks) that can be enabled?
>
>    The current state of play is on the wiki:
>
> https://btrfs.wiki.kernel.org/index.php/Deduplication
>

I hadn't realized that bedup was deprecated.

This seems unfortunate since it seemed to be a lot smarter about
detecting what has and hasn't already been scanned, and it also
supported defragmenting files while de-duplicating them.

I'll give duperemove a shot.   I just packaged it on Gentoo.

--
Rich
