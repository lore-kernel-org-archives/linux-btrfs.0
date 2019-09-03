Return-Path: <SRS0=cRuQ=W6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3302C3A5A2
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Sep 2019 08:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 834632053B
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Sep 2019 08:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfICIX0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 04:23:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40920 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbfICIX0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Sep 2019 04:23:26 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 268E5308FEDF;
        Tue,  3 Sep 2019 08:23:26 +0000 (UTC)
Received: from localhost (unknown [10.43.2.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C32E55D9E1;
        Tue,  3 Sep 2019 08:23:25 +0000 (UTC)
Date:   Tue, 3 Sep 2019 10:23:23 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: print procentage of used space
Message-ID: <20190903082322.GA3298@redhat.com>
References: <1567070045-10592-1-git-send-email-sgruszka@redhat.com>
 <20190902183919.GZ2752@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902183919.GZ2752@twin.jikos.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 03 Sep 2019 08:23:26 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Sep 02, 2019 at 08:39:19PM +0200, David Sterba wrote:
> On Thu, Aug 29, 2019 at 11:14:05AM +0200, Stanislaw Gruszka wrote:
> > This patch adds -p option for 'fi df' and 'fi show' commands to print
> > procentate of used space. Output with the option will look like on
> > example below:
> > 
> > Data, single: total=43.99GiB, used=37.25GiB (84.7%)
> > System, single: total=4.00MiB, used=12.00KiB (0.3%)
> > Metadata, single: total=1.01GiB, used=511.23MiB (49.5%)
> > GlobalReserve, single: total=92.50MiB, used=0.00B (0.0%)
> > 
> > I considered to change the prints by default without extra option,
> > but not sure if that would not break existing scripts that could parse
> > the output.
> 
> Would it be sufficient for your usecase to print the % values in the
> 'btrfs fi usage' command?
>
> After the summary, the's listing of the chunks with the same values and
> slightly different format:
> 
>   Data,single: Size:296.00GiB, Used:166.99GiB
> 
>   Metadata,single: Size:5.00GiB, Used:2.74GiB
> 
>   System,single: Size:32.00MiB, Used:48.00KiB
> 
> 
> For reference, this is from 'fi df':
> 
>   Data, single: total=296.00GiB, used=166.99GiB
>   System, single: total=32.00MiB, used=48.00KiB
>   Metadata, single: total=5.00GiB, used=2.74GiB
>   GlobalReserve, single: total=368.48MiB, used=0.00B
> 
> I'd rather not extend the output of 'fi df' as this was supposed to be a
> debugging tool and 'fi usage' is gives better and more complete
> overview, so the % seem more logical to be put there.

It would be sufficient for me to print percentage in 'fi usage' command.
I assume without extra -p option, just change the default output ?

What you think about adding percentage option to 'fi show'? It's not
super needed, but I somehow got use to have that information from
standard df tool.

Stanislaw
