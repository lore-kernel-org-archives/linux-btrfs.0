Return-Path: <SRS0=K7fm=6X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A875C28CBC
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 May 2020 19:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20E34214D8
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 May 2020 19:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgEITfg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 May 2020 15:35:36 -0400
Received: from bang.steev.me.uk ([81.2.120.65]:53129 "EHLO smtp.steev.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727938AbgEITff (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 May 2020 15:35:35 -0400
X-Greylist: delayed 1126 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 May 2020 15:35:35 EDT
Received: from smtp.steev.me.uk ([2001:8b0:162c:10::25] helo=webmail.steev.me.uk)
        by smtp.steev.me.uk with esmtp (Exim 4.92.3)
        id 1jXUxs-008xaM-Uj
        for linux-btrfs@vger.kernel.org; Sat, 09 May 2020 20:16:48 +0100
MIME-Version: 1.0
Date:   Sat, 09 May 2020 20:16:48 +0100
From:   Steven Davies <steev@steev.me.uk>
To:     linux-btrfs@vger.kernel.org
Subject: Re: Exploring referenced extents
In-Reply-To: <c9a53b726880c5d7dc8092c2078e23a5@steev.me.uk>
References: <c9a53b726880c5d7dc8092c2078e23a5@steev.me.uk>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <84c4e558cca691ad6066651466f7d332@steev.me.uk>
X-Sender: steev@steev.me.uk
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2020-05-09 12:11, Steven Davies wrote:
> For curiosity I'm trying to write a tool which will show me the size
> of data extents belonging to which files in a snapshot are exclusive
> to that snapshot as a way to show how much space would be freed if the
> snapshot were to be deleted, and which files in the snapshot are
> taking up the most space.
> 
> I'm working with Hans van Kranenburg's python-btrfs python library but
> my knowledge of the filesystem structures isn't good enough to allow
> me to figure out which bits of data I need to be able to achieve this.
> I'd be grateful if anyone could help me along with this.

Apologies for the spam, I've got most of it figured out now. The only 
thing remaining is to remove the double-counting of extents referenced 
by multiple files in the same subvolume. The code is here: 
https://github.com/daviessm/btrfs-snapshots-diff/blob/master/btrfs-subvol-size.py

-- 
Steven Davies
