Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloudserver094114.home.pl ([79.96.170.134]:49026 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbeITNuC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 09:50:02 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jason Baron <jbaron@akamai.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-btrfs@vger.kernel.org,
        linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 00/22] various dynamic_debug patches
Date: Thu, 20 Sep 2018 10:05:00 +0200
Message-ID: <4563778.42gAD4asSf@aspire.rjw.lan>
In-Reply-To: <20180919220444.23190-1-linux@rasmusvillemoes.dk>
References: <20180919220444.23190-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, September 20, 2018 12:04:22 AM CEST Rasmus Villemoes wrote:
> This started as an experiment to see how hard it would be to change
> the four pointers in struct _ddebug into relative offsets, a la
> CONFIG_GENERIC_BUG_RELATIVE_POINTERS, thus saving 16 bytes per
> pr_debug site (and thus exactly making up for the extra space used by
> the introduction of jump labels in 9049fc74). I stumbled on a few
> things that are probably worth fixing regardless of whether the latter
> half of this series is deemed worthwhile.
> 
> Patch relationships: 1-2, 3-4, 5-6 and 15-16 can be applied
> individually, though 2, 4 and 6 probably makes most sense in the
> context of the final goal of the series.

OK, I can take the [15-16/22] separately.

Thanks,
Rafael
