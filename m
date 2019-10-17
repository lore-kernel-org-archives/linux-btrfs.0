Return-Path: <SRS0=AqV7=YK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A01FA372A
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Oct 2019 12:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 729E72082C
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Oct 2019 12:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405888AbfJQMbk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Oct 2019 08:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbfJQMbk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Oct 2019 08:31:40 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F44B2067B;
        Thu, 17 Oct 2019 12:31:38 +0000 (UTC)
Date:   Thu, 17 Oct 2019 08:31:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] tools/lib/traceevent, perf tools: Handle %pU format
 correctly
Message-ID: <20191017083137.1984af24@gandalf.local.home>
In-Reply-To: <20191017115423.GH2751@twin.jikos.cz>
References: <20191017022800.31866-1-wqu@suse.com>
        <20191017115209.GG2751@twin.jikos.cz>
        <20191017115423.GH2751@twin.jikos.cz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 17 Oct 2019 13:54:23 +0200
David Sterba <dsterba@suse.cz> wrote:

> > So if there's an interest for very compact printing loop, something like
> > this produces the same output:
> > 
> > 	for (i = 0; i < 8; i++) {
> > 		printf("%02X", buf[i]);
> > 		printf("%02X", buf[i]);  
> 
> Ok, test-before-post failure, this should be
> 
> 		printf("%02X", buf[2 * i]);
> 	        printf("%02X", buf[2 * i + 1]);
> 
> > 		if (1 <= i && i <= 4)
> > 			putchar('-');
> > 	}  

I'm fine if you want to post a v3 with this update.

-- Steve
