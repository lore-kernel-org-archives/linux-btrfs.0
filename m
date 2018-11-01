Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D45CC0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 19:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E295205F4
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 19:03:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="Z6cxENfU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E295205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbeKBEH7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Nov 2018 00:07:59 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42421 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbeKBEH7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2018 00:07:59 -0400
Received: by mail-qk1-f196.google.com with SMTP id u68so9000695qkg.9
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 12:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PEwiYW+iPT3AETwkcCB/lZEO+Bs8G4ZrI9hfFEPuYEY=;
        b=Z6cxENfUhA5a9ZNq5yvnSj1IqJd0z9Wob1V+yhPLa7INrx8+tOXtu1oHKF8XTddqWE
         IC6YDL4xfCd//x1jdbmkl8AwaVDpJHpUeFDjZ5ANzbwz3kXdADY6FUq4FVUanx8w6f00
         V7OEgRifQv2eIU7pATfR3/tH21tHjpVA87BdDH36sn5RnGxRWMb4nKhbi/iQAMcuaqTr
         Wuft1ETNRpKRYU2y+dHemYacTWIFlEnJATPXCBFwpiCaIaUdjTjKUz9744Z+SwxUV8Y/
         0ZbSkuipCSJ3wJxSgckqP7sCooXP8vWGOZGhw0gqVSxlWP2gHDOJ1z90gDlGWGfUBYzY
         rhIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PEwiYW+iPT3AETwkcCB/lZEO+Bs8G4ZrI9hfFEPuYEY=;
        b=kt5syG42pk4ctxLFy3TSDNw/pzM0//K/QNwuFbVdNGQRB7LH6DfP5dQpD3wz50F5qd
         ejn9asjGX7CRXNbRzrjUurbhJUJ38SzstkCBQYL50T/TUbNaz8NrSMCBPqW4fUKGi3ih
         NV/CMwSWAKTli12e8+LrkNPdGk0q094bd5JO0P0hcQF81VYYQMSOrRdlJAk9YDhZzlnv
         4Qawp26tlvFbcMOHx12BzVsbnSnN+wwLvdsDG+8tw1cKEW1WrlXMvOhevV5eo07tp9By
         4/nA+hXfMQNT99AgR50H7jg4L291Ax25kA9SyCGsB5O80h5OogJVU89D4nhybW+HNfyV
         h9/Q==
X-Gm-Message-State: AGRZ1gI3qJU2Vc9VhxB1nIf6fbb4OjnYIl19O3Y5GokrDvas3IfV0C1W
        RJC7F45b4dBFnDh/s53f6kGHDQ==
X-Google-Smtp-Source: AJdET5e9s+/s/7pG8YYTpQoMLNKNeNPMEohkHGqqiWfKS3lfGSA4bMhdzqRuHPeAeLimUveOXqMwSQ==
X-Received: by 2002:aed:2de3:: with SMTP id i90-v6mr8219293qtd.173.1541099025505;
        Thu, 01 Nov 2018 12:03:45 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::1:c8f8])
        by smtp.gmail.com with ESMTPSA id l123-v6sm6039727qkd.95.2018.11.01.12.03.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Nov 2018 12:03:44 -0700 (PDT)
Date:   Thu, 1 Nov 2018 15:03:43 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/8] btrfs: Remove extent_io_ops::writepage_end_io_hook
Message-ID: <20181101190342.bywvhkrihf3y57ah@macbook-pro-91.dhcp.thefacebook.com>
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
 <1541074194-22227-4-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541074194-22227-4-git-send-email-nborisov@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 01, 2018 at 02:09:48PM +0200, Nikolay Borisov wrote:
> This callback is ony ever called for data page writeout so
> there is no need to actually abstract it via extent_io_ops. Lets just
> export it, remove the definition of the callback and call it directly
> in the functions that invoke the callback. Also rename the function to
> btrfs_writepage_endio_finish_ordered since what it really does is
> account finished io in the ordered extent data structures.
> No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Could send another cleanup patch to remove the struct extent_state *state from
the arg list as well.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
