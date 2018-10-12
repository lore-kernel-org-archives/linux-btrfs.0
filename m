Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12682C6783C
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 13:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE26620868
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 13:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="vedcxUw8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE26620868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbeJLV0V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 17:26:21 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34945 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728616AbeJLV0V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 17:26:21 -0400
Received: by mail-qt1-f193.google.com with SMTP id d21-v6so1493427qtq.2
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 06:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+YDFm86I53We35517xMri5tBbWlJdaa22wLvl8dAgFE=;
        b=vedcxUw8aoZrenoJfv1XT4XCQrk58b86OL6pAa743xSUdK0V3ki+6nGv29Jp0zhm7u
         yHljBEGFOHh6rEyuCx72Mmxlcrf/vaGqvI7KADb02J0mOLlBFDgIhlBzS3Cmyl3etYv0
         m4QfI/bmEtD1EfRva0zynzySAHgcAapKsw/ZdipCXeB+xpoSjTRehFyad/5nAABIjKgF
         YZjMQWF8QWUMnIz/JXMJw0pW0k3DtXtZwrwAAehXSfeYtY5jy9+8GjodtR0PuLGwUpL0
         mat9WNoLqjRcxmdWsVvXx5IiON19JwLEDOp8o319sjk5ASppNurs0X4QtDdk3ei9uRHz
         WM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+YDFm86I53We35517xMri5tBbWlJdaa22wLvl8dAgFE=;
        b=lklDGxlP4OYPC60AoTHL0S9hVu37p7SwfrN7p2Ywb2mOjiU0mXBANZi7R8txpa1y8v
         znmkE3/6MqUvzHrdMjhCPRImvoyWtfki/WQ0DeFsz7eR4rKrSMVaN1cojK1K7bRhO51D
         TUf6BxcWtaT0oTaEyL9BwP/sRRRgHH9SocoXR1SAkT5VpM0WNEfA9CcRrwbORBdklOpG
         OobJqN/8LinQOlbh0C3TKkHFIlV9x3FNZuSm3aViDcJGFnbIfwbHcaAAwbVn/INz16mj
         AUQRDCZ1WaCetEE94NBnoIODUmOVTpjPIb85wF8mZ1lhJkbK4Ph6ie5oQJGnxW1lQpqW
         Q1Jw==
X-Gm-Message-State: ABuFfog90Qb68asy+RyiKuacLptDQHMTjG8iOsdllEI5Ngl+6K8o3qWj
        4NPa8kXISEhNLKGCz3XlzNd0zA==
X-Google-Smtp-Source: ACcGV62lz0bcStV+SKpS1qZyDJuYBb1biikGtQGDgGmGjPkl9K2F8KZMv6PaAQOGSbK4S/jWsa6OaQ==
X-Received: by 2002:a0c:f443:: with SMTP id h3mr6026528qvm.5.1539352427748;
        Fri, 12 Oct 2018 06:53:47 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id o185-v6sm616269qke.34.2018.10.12.06.53.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 06:53:46 -0700 (PDT)
Date:   Fri, 12 Oct 2018 09:53:45 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 3/4] btrfs: Refactor unclustered extent allocation
 into find_free_extent_unclustered()
Message-ID: <20181012135344.3ymef6ahx2gy5mvk@destiny>
References: <20181012061819.19482-1-wqu@suse.com>
 <20181012061819.19482-4-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012061819.19482-4-wqu@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 02:18:18PM +0800, Qu Wenruo wrote:
> This patch will extract unclsutered extent allocation code into
> find_free_extent_unclustered().
> 
> And this helper function will use return value to indicate what to do
> next.
> 
> This should make find_free_extent() a little easier to read.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
