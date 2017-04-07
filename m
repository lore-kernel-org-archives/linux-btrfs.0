Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59172 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbdDGPIJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Apr 2017 11:08:09 -0400
Subject: Re: linux-next: Tree for Apr 7 (btrfs)
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
References: <20170407182732.455c5c90@canb.auug.org.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3f143e53-652b-8690-d71c-dae42ab14a09@infradead.org>
Date: Fri, 7 Apr 2017 08:08:06 -0700
MIME-Version: 1.0
In-Reply-To: <20170407182732.455c5c90@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/07/17 01:27, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20170406:
> 

on i386:

ERROR: "__udivdi3" [fs/btrfs/btrfs.ko] undefined!

Reported-by: Randy Dunlap <rdunlap@infradead.org>

-- 
~Randy
