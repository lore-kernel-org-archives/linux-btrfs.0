Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:50160 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966633AbaFQWVV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 18:21:21 -0400
Received: by mail-ie0-f170.google.com with SMTP id tr6so3281ieb.29
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 15:21:20 -0700 (PDT)
Date: Tue, 17 Jun 2014 15:21:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH v4] lib: add size unit t/p/e to memparse
In-Reply-To: <1402623746-1171-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1406171520510.517@chino.kir.corp.google.com>
References: <1402623746-1171-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 13 Jun 2014, Gui Hecheng wrote:

> For modern filesystems such as btrfs, t/p/e size level operations
> are common.
> add size unit t/p/e parsing to memparse
> 
> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>

Sorry, didn't do this before.  Good luck with the simple_strto*() work!
