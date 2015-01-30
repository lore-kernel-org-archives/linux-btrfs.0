Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:58074 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754373AbbA3WGo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 17:06:44 -0500
Message-ID: <54CC006F.2070404@arcor.de>
Date: Fri, 30 Jan 2015 23:06:39 +0100
From: Ochi <ochi@arcor.de>
MIME-Version: 1.0
To: bjornar.ness@gmail.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send multiple subvolumes
References: <CAJO99T=O8ts=GXXi33BR4BPkDgFu6WXWEqFFcUBBTBoNQdNhgg@mail.gmail.com>
In-Reply-To: <CAJO99T=O8ts=GXXi33BR4BPkDgFu6WXWEqFFcUBBTBoNQdNhgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

just wanted to say that I'm having the very same issue with kernel 
3.18.4, btrfs-progs 3.18.1 (with or without -e option) - even with 
completely fresh and/or empty snapshots. I'm just starting to experiment 
with send/receive, so I don't know whether I have a fundamentally wrong 
idea what it should do, but it seems to me like a quite standard case. 
Any news of this?

Best,
Sebastian
