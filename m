Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37043 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbbIQSqf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 14:46:35 -0400
Received: by wicfx3 with SMTP id fx3so2992003wic.0
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2015 11:46:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55FAFEB8.6030404@menke.ac>
References: <55F88ECC.1040604@menke.ac>
	<pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net>
	<55FAFEB8.6030404@menke.ac>
Date: Thu, 17 Sep 2015 19:46:34 +0100
Message-ID: <CAMU1PDiQS+STMe63Ee2G-GoU0M-Hqp1vweeEDzRadpLQWrcpgg@mail.gmail.com>
Subject: Re: BTRFS as image store for KVM?
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Gert Menke <gert@menke.ac>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 17 September 2015 at 18:56, Gert Menke <gert@menke.ac> wrote:
> MD+LVM is very close to what I want, but md has no way to cope with silent
> data corruption. So if I'd want to use a guest filesystem that has no
> checksums either, I'm out of luck.
> I'm honestly a bit confused here - isn't checksumming one of the most
> obvious things to want in a software RAID setup? Is it a feature that might
> appear in the future? Maybe I should talk to the md guys...
...
> Any comments on that? Am I missing something?

How about using file integrity checking tools for cases when the chosen
storage stack doesn't provided data checksumming.
E.g.
aide - http://aide.sourceforge.net/
cfv - http://cfv.sourceforge.net/
tripwire - http://sourceforge.net/projects/tripwire/

Don't use them, just providing options.

Mike
