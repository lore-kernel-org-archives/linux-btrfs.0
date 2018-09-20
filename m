Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35838 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732302AbeITTzi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 15:55:38 -0400
Received: by mail-lf1-f67.google.com with SMTP id x20-v6so8485260lfg.2
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 07:11:57 -0700 (PDT)
Subject: Re: [PATCH 14/22] btrfs: implement btrfs_debug* in terms of helper
 macro
To: dsterba@suse.cz, Jason Baron <jbaron@akamai.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <20180919220444.23190-1-linux@rasmusvillemoes.dk>
 <20180919220444.23190-15-linux@rasmusvillemoes.dk>
 <20180920131039.GY5847@twin.jikos.cz>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <53ae56ab-2d98-4b74-1143-9959f5341205@rasmusvillemoes.dk>
Date: Thu, 20 Sep 2018 16:11:54 +0200
MIME-Version: 1.0
In-Reply-To: <20180920131039.GY5847@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-09-20 15:10, David Sterba wrote:
> On Thu, Sep 20, 2018 at 12:04:36AM +0200, Rasmus Villemoes wrote:
>> First, the btrfs_debug macros open-code (one possible definition of)
>> DYNAMIC_DEBUG_BRANCH, so they don't benefit from the HAVE_JUMP_LABEL
>> optimization.
>>
>> Second, changes on x86-64 later in this series require that all struct
>> _ddebug descriptors in a translation unit use distinct identifiers.
>>
>> Using the new _dynamic_func_call_no_desc helper macro from
>> dynamic_debug.h takes care of both of these.
>>
>> Cc: linux-btrfs@vger.kernel.org
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> 
> Acked-by: David Sterba <dsterba@suse.com>
> 
> Per the cover letter, I assume you'll take it through your git tree.

Thanks. I don't have a git tree feeding to -next myself, but these will
probably be routed through akpm or x86.

Rasmus
