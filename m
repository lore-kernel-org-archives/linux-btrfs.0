Return-Path: <SRS0=JEJz=MP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C9FC64EBC
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Oct 2018 09:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94CC620835
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Oct 2018 09:28:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94CC620835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rjwysocki.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbeJCQQR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Oct 2018 12:16:17 -0400
Received: from cloudserver094114.home.pl ([79.96.170.134]:62756 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbeJCQQR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2018 12:16:17 -0400
Received: from 79.184.253.194.ipv4.supernova.orange.pl (79.184.253.194) (HELO aspire.rjw.lan)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.148)
 id efea987198ef30d2; Wed, 3 Oct 2018 11:28:41 +0200
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Jason Baron <jbaron@akamai.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 00/22] various dynamic_debug patches
Date:   Wed, 03 Oct 2018 11:25:40 +0200
Message-ID: <2308315.5DVx2N1Pa0@aspire.rjw.lan>
In-Reply-To: <4563778.42gAD4asSf@aspire.rjw.lan>
References: <20180919220444.23190-1-linux@rasmusvillemoes.dk> <4563778.42gAD4asSf@aspire.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thursday, September 20, 2018 10:05:00 AM CEST Rafael J. Wysocki wrote:
> On Thursday, September 20, 2018 12:04:22 AM CEST Rasmus Villemoes wrote:
> > This started as an experiment to see how hard it would be to change
> > the four pointers in struct _ddebug into relative offsets, a la
> > CONFIG_GENERIC_BUG_RELATIVE_POINTERS, thus saving 16 bytes per
> > pr_debug site (and thus exactly making up for the extra space used by
> > the introduction of jump labels in 9049fc74). I stumbled on a few
> > things that are probably worth fixing regardless of whether the latter
> > half of this series is deemed worthwhile.
> > 
> > Patch relationships: 1-2, 3-4, 5-6 and 15-16 can be applied
> > individually, though 2, 4 and 6 probably makes most sense in the
> > context of the final goal of the series.
> 
> OK, I can take the [15-16/22] separately.

And they have been applied now.

Thanks,
Rafael

