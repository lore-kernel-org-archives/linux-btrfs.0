Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbbAIRly (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Jan 2015 12:41:54 -0500
Date: Fri, 9 Jan 2015 18:41:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Peter Wu <peter@lekensteyn.nl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Documentation: fix broken conversion
Message-ID: <20150109174152.GE3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1420467009-11738-1-git-send-email-peter@lekensteyn.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1420467009-11738-1-git-send-email-peter@lekensteyn.nl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 05, 2015 at 03:10:09PM +0100, Peter Wu wrote:
> In this patch, the sed expression is dropped and asciidoc is configured
> to recognize `<...>` as a unconstrained quoted string (such that
> `<attr>s` is correctly emphasized) and to avoid adding quotes in
> contexts where it is not needed.

Thanks, I like that very much.

> A remaining problem is that some texts (the one between brackets) do not
> add the emphasis for `<...>`. While this could be solved by replacing
> `[` and `]` with `&#91;` and `&#93;` using sed, it introduces formatting
> problems in btrfs-zero-log(8) because the context is ignored.

A minor issue, if this can be fixed by manually adjusting the page
source, then it's fine.
