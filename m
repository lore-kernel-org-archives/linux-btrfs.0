Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ninthfloor.org ([109.74.194.224]:52418 "EHLO
	mail.ninthfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbJCMl0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Oct 2015 08:41:26 -0400
Received: from [192.168.1.2] (net-93-150-174-81.cust.dsl.teletu.it [93.150.174.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: pl)
	by mail.ninthfloor.org (Postfix) with ESMTPSA id 9C6D41C101
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2015 12:41:24 +0000 (UTC)
Subject: Re: btrfs send -c fails saying "parent determination failed"
To: linux-btrfs@vger.kernel.org
References: <560B0E9B.7020500@ninthfloor.org>
From: Paride Legovini <pl@ninthfloor.org>
Message-ID: <560FCCF3.9070008@ninthfloor.org>
Date: Sat, 3 Oct 2015 14:41:23 +0200
MIME-Version: 1.0
In-Reply-To: <560B0E9B.7020500@ninthfloor.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-09-30 00:20, Paride Legovini wrote:
> Hi,
> 
> btrfs send -c stopped working for me several months ago.
[...]

Hi again, my previous email didn't get any reply, maybe it was too long.
I try to summarize:

btrfs send -c | btrfs receive

always fails for me with "parent determination failed" even if the UUIDs
are correct, and indeed btrfs send -p works fine on the same subvols.

My setup is quite standard (more details in the original email), so I'm
prone to think that the problem is with btrfs-progs.

I'll be happy to provide any information that could help to find where
the problem lies. If there is no interest in this I'll live with -p, but
with the uncomfortable feeling that a bug may be hiding somewhere...

Paride

