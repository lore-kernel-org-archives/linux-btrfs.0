Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:49548 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaFCJiR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jun 2014 05:38:17 -0400
Received: by mail-vc0-f173.google.com with SMTP id ik5so3588709vcb.32
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jun 2014 02:38:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140512140917.GA6917@suse.cz>
References: <20140416171219.GC29256@twin.jikos.cz>
	<1397668577-846-1-git-send-email-dsterba@suse.cz>
	<534F24A0.5000304@cn.fujitsu.com>
	<20140418144801.GG29256@suse.cz>
	<536AE073.2070307@cn.fujitsu.com>
	<20140512140917.GA6917@suse.cz>
Date: Tue, 3 Jun 2014 10:38:16 +0100
Message-ID: <CALOYprVO555k34EhKN85j=HBcD3=Wp9PGus+Gqej__xi2AghTQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: doc: link btrfsck to btrfs-check
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12 May 2014 15:09, David Sterba <dsterba@suse.cz> wrote:
>
> Thanks, it was reported & fixed a few days ago, though it's not in the
> integration branch, lag is on my side.
>
> https://patchwork.kernel.org/patch/4115501/

Hi David,

I noticed this in another thread:

On 3 June 2014 10:14, David Sterba <dsterba@suse.cz> wrote:
> I've assembled a branch containing doc-only fixes, including this one,
> and asked Chris do do a 3.14.3 release.

Does this branch include this fix for this bug? According to
patchwork, it's status is still "under review", but it's been a month
and the bug slipped into the 3.14.2 release. I just want to make sure
it hasn't fallen out of the pile. :)

Cheers,


WorMzy
