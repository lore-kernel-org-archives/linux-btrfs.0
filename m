Return-Path: <SRS0=snfn=3D=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 945C5C33CB1
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Jan 2020 11:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7127A24676
	for <linux-btrfs@archiver.kernel.org>; Tue, 14 Jan 2020 11:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgANLlB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 06:41:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:33414 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbgANLlB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Jan 2020 06:41:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 18693ACBD;
        Tue, 14 Jan 2020 11:41:00 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6F094DA730; Tue, 14 Jan 2020 12:40:47 +0100 (CET)
Date:   Tue, 14 Jan 2020 12:40:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 00/16] btrfs-progs: global verbose and quiet option
Message-ID: <20200114114047.GC3929@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <1574678357-22222-1-git-send-email-anand.jain@oracle.com>
 <8a2bac99-5c07-2aa9-fe3b-e09f2ad16213@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a2bac99-5c07-2aa9-fe3b-e09f2ad16213@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 14, 2020 at 02:14:24PM +0800, Anand Jain wrote:
>   I wonder if could this be integrated?

Yes, when I get to it through the pile of other patches.
