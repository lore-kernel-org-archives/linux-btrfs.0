Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19486C07E9B
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Jul 2021 02:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F156561209
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Jul 2021 02:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239460AbhGTB0e (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 21:26:34 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:43672 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1350982AbhGTACm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Jul 2021 20:02:42 -0400
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 16K0h4IS017569
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 20:43:04 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C6E864202F5; Mon, 19 Jul 2021 20:43:03 -0400 (EDT)
Date:   Mon, 19 Jul 2021 20:43:03 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] fstests: allow running custom hooks
Message-ID: <YPYcFx6BI7lVH/S9@mit.edu>
References: <20210719071337.217501-1-wqu@suse.com>
 <YPWF5iqB0fOYZd9K@mit.edu>
 <8588de9d-b4e9-0d4a-4ea4-41a6673ddcd5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8588de9d-b4e9-0d4a-4ea4-41a6673ddcd5@gmx.com>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 20, 2021 at 06:06:00AM +0800, Qu Wenruo wrote:
> 
> I can enhance the next version to do that, but that also means any error
> inside the hook will bring down the whole test run.

I don't see why that would be?  We just have to sample the exit status
of the hook script, and if it matches a specific value, we skip the
test.  If the hook script crashes, the exit status will be some other
value, e.g., 128+<signal_number>, 127 if the script doesn't exist, 126
if the script exists but is not executable, etc.  So we just sample $?
and if it is, say, 83 (ascii 'S') we skip the test; otherwise, we run
the test.  How would an error inside the hook "bring down the whole
test run"?

Cheers,

						- Ted
