Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0628C433DB
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Mar 2021 22:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 542C6619A3
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Mar 2021 22:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCVWZO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 18:25:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:54306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230292AbhCVWZD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Mar 2021 18:25:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2FF89AF44;
        Mon, 22 Mar 2021 22:25:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9C790DA7AE; Mon, 22 Mar 2021 23:22:57 +0100 (CET)
Date:   Mon, 22 Mar 2021 23:22:57 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Forrest Aldrich <forrie@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: APFS and BTRFS
Message-ID: <20210322222257.GC7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Forrest Aldrich <forrie@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <7ead4392-f4c2-2a5b-c104-ae8be585d49e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ead4392-f4c2-2a5b-c104-ae8be585d49e@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Mar 20, 2021 at 11:22:18AM -0400, Forrest Aldrich wrote:
> I have a really large (3+ TB) volume I am copying to a BTRFS volume 
> (both over USB) which is painfully slow.  In fact, it will probably take 
> days to complete.   My goal is to use BTRFS on that larger USB volume 
> (it's an 18TB drive)....
> 
> I don't suppose there is a way to convert APFS to BTRFS :)   I know, but 
> I thought I would ask as it seems like others may have a similar query.

Convert relies on libraries providing the API to access the source
filesystems, I don't see anything like that for APFS so it would have to
be written from scratch. The linux-apfs project does not seem to be
active, last update 2 years ago. If it's just days of copying, I think
it's the better and safer option.
