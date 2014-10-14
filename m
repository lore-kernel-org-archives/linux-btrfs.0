Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailsec102.isp.belgacom.be ([195.238.20.98]:44154 "EHLO
	mailsec102.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755470AbaJNUSL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 16:18:11 -0400
Date: Tue, 14 Oct 2014 22:18:09 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Zach Brown <zab@zabbo.net>
Cc: Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Message-ID: <468850260.110326.1413317889395.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <20141014191542.GB6838@lenny.home.zabbo.net>
References: <1413308774-9985-1-git-send-email-fabf@skynet.be> <20141014191542.GB6838@lenny.home.zabbo.net>
Subject: Re: [RFC 1/1 linux-next] btrfs: don't opencode zero_user_segment
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> On 14 October 2014 at 21:15 Zach Brown <zab@zabbo.net> wrote:
>
>
> On Tue, Oct 14, 2014 at 07:46:14PM +0200, Fabian Frederick wrote:
> > use function defined in include/linux/highmem.h
> > Note that this reverts 2 last function call order
>
> And adds a BUG_ON(PAGE_CACHE_SIZE > PAGE_SIZE).  We can take bets on
> whether that will ever trigger.

There are 36 zero_user_segment with PAGE_CACHE_SIZE callsites.
Maybe we could add some specific function to avoid BUG_ON tests ?

Fabian
>
> - z
