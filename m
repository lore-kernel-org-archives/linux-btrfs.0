Return-Path: <SRS0=xGl5=7Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78708C433E0
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Jun 2020 11:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CDCF20760
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Jun 2020 11:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgFKLUr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Jun 2020 07:20:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:33392 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbgFKLUk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jun 2020 07:20:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D03B7AAC3;
        Thu, 11 Jun 2020 11:20:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 94094DA82A; Thu, 11 Jun 2020 13:20:32 +0200 (CEST)
Date:   Thu, 11 Jun 2020 13:20:32 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Greed Rong <greedrong@gmail.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: BTRFS: Transaction aborted (error -24)
Message-ID: <20200611112031.GM27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Greed Rong <greedrong@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <CA+UqX+NTrZ6boGnWHhSeZmEY5J76CTqmYjO2S+=tHJX7nb9DPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+UqX+NTrZ6boGnWHhSeZmEY5J76CTqmYjO2S+=tHJX7nb9DPw@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jun 11, 2020 at 06:29:34PM +0800, Greed Rong wrote:
> Hi,
> I have got this error several times. Are there any suggestions to avoid this?
> 
> # dmesg
> [7142286.563596] ------------[ cut here ]------------
> [7142286.564499] BTRFS: Transaction aborted (error -24)

EMFILE          24      /* Too many open files */

you can increase the open file limit but it's strange that this happens,
first time I see this.

>      5.0.10-050010-generic #201904270832

5.0.10 is quite old, but that shouldn't affect it.

