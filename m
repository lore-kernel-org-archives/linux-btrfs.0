Return-Path: <SRS0=0mr7=TG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C2EC04A6B
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 May 2019 11:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA79A2087F
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 May 2019 11:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfEFLb2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 6 May 2019 07:31:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:37766 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726063AbfEFLb1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 May 2019 07:31:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D59CCAF35;
        Mon,  6 May 2019 11:31:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9B90DDA885; Mon,  6 May 2019 13:32:26 +0200 (CEST)
Date:   Mon, 6 May 2019 13:32:26 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Maksim Fomin <maxim@fomin.one>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Hibernation into swap file
Message-ID: <20190506113226.GL20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Maksim Fomin <maxim@fomin.one>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <aeo6MlQ5-4Bg33XbJZWCvdhKuo0Cgca_eNE4xv7rqzCzgvyxG-cobpf8R3bGdh6VT2LLPcXlZu69EyL_rV8K7gRLQ4HtYIyXnWCWb3zR6UM=@fomin.one>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeo6MlQ5-4Bg33XbJZWCvdhKuo0Cgca_eNE4xv7rqzCzgvyxG-cobpf8R3bGdh6VT2LLPcXlZu69EyL_rV8K7gRLQ4HtYIyXnWCWb3zR6UM=@fomin.one>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

On Sun, May 05, 2019 at 07:50:09AM +0000, Maksim Fomin wrote:
> Good day.
> 
> Since 5.0 btrfs supports swap files. Does it support hibernation into a swap file?
> 
> With kernel version 5.0.10 (archlinux) and btrfs-progs 4.20.2 (unlikely to be relevant, but still) when I try to hibernate with systemctl or by directly manipulating '/sys/power/resume' and '/sys/power/resume_offset', the kernel logs:
> 
> PM: Cannot find swap device, try swapon -a
> PM: Cannot get swap writer
> 
> After digging into this issue I suspect that currently btrfs does not support hibernation into swap file (or does it?). Furthermore, I suspect that kernel mechanism of accessing swap file via 'resume_offset' is unreliable in btrfs case because it is more likely (comparing to other fs) to move files across filesystem which invalidates swap file offset, so the whole idea is dubious. So,
> 
> 1) does btrfs supports hibernation into swap file?
> 2) is there mechanism to lock swap file?

for the reference https://bugzilla.kernel.org/show_bug.cgi?id=202803
and https://github.com/systemd/systemd/issues/11939
