Return-Path: <SRS0=AUj1=6E=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B0A8C54FD0
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FB332084D
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 Apr 2020 22:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgDTWB5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 18:01:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:38362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgDTWB5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Apr 2020 18:01:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6EF6FAEBB;
        Mon, 20 Apr 2020 22:01:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 531E7DA72D; Tue, 21 Apr 2020 00:01:13 +0200 (CEST)
Date:   Tue, 21 Apr 2020 00:01:12 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@gmail.com>
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: drop logs when we've aborted a transaction
Message-ID: <20200420220112.GF18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
References: <20200324144752.9541-1-josef@toxicpanda.com>
 <CAL3q7H6rrXEYgQ+yE97nOrYxEKarDci0qjs0hM8VtOMOF6=khw@mail.gmail.com>
 <CAL3q7H4sfdeagShohQUC_Mp2KBkkNqxwHCVgDto25dbRrkDqrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H4sfdeagShohQUC_Mp2KBkkNqxwHCVgDto25dbRrkDqrA@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 17, 2020 at 06:06:54PM +0100, Filipe Manana wrote:
> David, this is a regression introduced in 5.7-rc1, and it's very easy
> to hit with generic/475.
> Any reason this wasn't picked yet, despite having been posted several weeks ago?

No code or technical reason, now added to misc-next and queued for rc,
thanks.
