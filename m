Return-Path: <SRS0=UnVx=XZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D52C35280
	for <linux-btrfs@archiver.kernel.org>; Mon, 30 Sep 2019 13:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7F9321855
	for <linux-btrfs@archiver.kernel.org>; Mon, 30 Sep 2019 13:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569850750;
	bh=hISo5FprdgrNyDcqOhLwulTy4rRMPNAHrPi+MwWttnA=;
	h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:List-ID:
	 From;
	b=qZmlRnZ9oUD0M7O3DO0uodbjuPh12oIXsdS8IsVS/HwQUjrTtHIaRBYsRzymfjPRw
	 gQSqyHJZ82gQ2fLAxzBtsJo0qJpjFXVVXmsXx8+KxR4DGY1/eWJQ7dlIFjP/1t8bj/
	 kZkMR9IIRIqaBskRUt/1HgdgimgqlOsMcsN8JXMk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbfI3NjK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 30 Sep 2019 09:39:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbfI3NjJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Sep 2019 09:39:09 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A221216F4;
        Mon, 30 Sep 2019 13:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569850749;
        bh=hISo5FprdgrNyDcqOhLwulTy4rRMPNAHrPi+MwWttnA=;
        h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:From;
        b=e9hv3kaOnD8isplJxPj3GUSlUPi5gfjuDLjqZyOHHLt5upjJv4ZIfX6TN23V19Js/
         tIXAadUG+U04/gjAyS+W+a4LFNCb53UUlkwnnu/i69G3ehqNMySOpAA4Ls5nauncmF
         hnNAQEsHVyLhRqcmRJoaN9V12fKaIhNrN89r0sng=
Date:   Mon, 30 Sep 2019 13:39:08 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Filipe Manana <fdmanana@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix memory leak due to concurrent append writes with fiemap
In-Reply-To: <20190930092025.31118-1-fdmanana@kernel.org>
References: <20190930092025.31118-1-fdmanana@kernel.org>
Message-Id: <20190930133909.0A221216F4@mail.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.16+

The bot has tested the following trees: v5.3.1, v5.2.17, v4.19.75.

v5.3.1: Build OK!
v5.2.17: Build OK!
v4.19.75: Failed to apply! Possible dependencies:
    7073017aeb98 ("btrfs: use offset_in_page instead of open-coding it")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
