Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36360 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387418AbeITSyJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 14:54:09 -0400
Date: Thu, 20 Sep 2018 15:10:39 +0200
From: David Sterba <dsterba@suse.cz>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jason Baron <jbaron@akamai.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 14/22] btrfs: implement btrfs_debug* in terms of helper
 macro
Message-ID: <20180920131039.GY5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180919220444.23190-1-linux@rasmusvillemoes.dk>
 <20180919220444.23190-15-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180919220444.23190-15-linux@rasmusvillemoes.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 20, 2018 at 12:04:36AM +0200, Rasmus Villemoes wrote:
> First, the btrfs_debug macros open-code (one possible definition of)
> DYNAMIC_DEBUG_BRANCH, so they don't benefit from the HAVE_JUMP_LABEL
> optimization.
> 
> Second, changes on x86-64 later in this series require that all struct
> _ddebug descriptors in a translation unit use distinct identifiers.
> 
> Using the new _dynamic_func_call_no_desc helper macro from
> dynamic_debug.h takes care of both of these.
> 
> Cc: linux-btrfs@vger.kernel.org
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Acked-by: David Sterba <dsterba@suse.com>

Per the cover letter, I assume you'll take it through your git tree.
