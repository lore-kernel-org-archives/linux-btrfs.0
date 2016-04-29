Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48391 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbcD2Pf6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 11:35:58 -0400
Subject: Re: linux-next: Tree for Apr 29 (btrfs)
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
References: <20160429171354.3b98c8f3@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <57237F5B.7040709@infradead.org>
Date: Fri, 29 Apr 2016 08:35:55 -0700
MIME-Version: 1.0
In-Reply-To: <20160429171354.3b98c8f3@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/29/16 00:13, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20160428:
> 

on i386:

fs/built-in.o: In function `scrub_raid56_parity':
scrub.c:(.text+0x2d06fb): undefined reference to `__udivdi3'


-- 
~Randy
