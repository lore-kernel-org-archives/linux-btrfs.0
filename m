Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:35931 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbbL2NYG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 08:24:06 -0500
Received: by mail-ig0-f195.google.com with SMTP id o2so2391735iga.3
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 05:24:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRTNgUFnjGyF6wBeiX2LzMjO8Avc8xGb9NAFLnvgGyM3Q@mail.gmail.com>
References: <20151226070004.461eebaf@natsu>
	<CAJCQCtRTNgUFnjGyF6wBeiX2LzMjO8Avc8xGb9NAFLnvgGyM3Q@mail.gmail.com>
Date: Tue, 29 Dec 2015 08:24:04 -0500
Message-ID: <CAGfcS_=B4CRcTTi5poFDjkkQG4T3bTZKctgLMO_sUXp-cib8qA@mail.gmail.com>
Subject: Re: Deadlock after upgrade to 4.1
From: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 25, 2015 at 11:34 PM, Chris Murphy <lists@colorremedies.com> wrote:
> I would then also try to reproduce with 4.2.8 or 4.3.3 because those
> have ~ 25% backports than made it to 4.1.15, so there's an off chance
> it's fixed there.

I take it that those backports are in the queue though?  I was
actually thinking about updating to 4.1 over the holidays but this
thread is making me think that btrfs isn't quite ready in 4.1 yet.
3.18.25 is about the best experience with btrfs I've had so far, and I
guess I don't really have any reason to update until raid5 is stable
(which seems a long way off).

--
Rich
