Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97860C433FE
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Oct 2022 15:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiJTPiU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Oct 2022 11:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiJTPiS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Oct 2022 11:38:18 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FDF1B90C0
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Oct 2022 08:38:17 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id o2so115609qkk.10
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Oct 2022 08:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KA2IurPv6tIbAcy77QmfbnF3BRGMjHyFykgD5yoGl3M=;
        b=HtVyXEdyuQEKIEr25c72ot/NDiqBjjxHd8HSoqkFhasvJM/L7i2NW+g7C0yhmBRAAe
         fUya6UBHBAd8MPeUDvmLuG7csu6MQ/CYitEdmUaHrjKOm6ef7vNqTwgItlc/ukw5O+Bo
         3RA2qa5wm5XTwuPnncr9bo4tpdfom2Gb2VM08GWvxCM3TI/CeWSWsfbunRo4jU2Wm6gt
         XrW5Bhm5R0vaDKDvGG5q9kLpELuxauxLQZkVKtFB02MSZyhxUH8IM6lPjBjHseto9lmU
         BvwgrkWYhGWb56hDYvzVgLYsYlR42DO5hTOQR0by/txSTR63ljHtLVy/i43pdQm76RTY
         p/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KA2IurPv6tIbAcy77QmfbnF3BRGMjHyFykgD5yoGl3M=;
        b=DBOOXbVR5MkLHNgr0kIwiy7HEmShWJx1D3WCqbU6BS6S/8HF+vGfGJWC2OkOYV7fZo
         RJn+Znj0ZJzvzQXY8Jtw+GlA5Wc9x4nqFHm7rrbd9JYzybXMPxDj48F6fbqqZ/qbwJlY
         dxjZgK701/ssswenbYRbKojgL7AsM9K5C0c/cllm/SuW2+NwyOecEhajU0qiO2kWpVzX
         gDDK4elsArctz4AfMmSYfIJMsbERGx2ALIM2Qf/DTJ0CgcLkDOqnu/Eu4o35ik3ZkEh9
         kP9fzZSu6eiCUqicBwLJGLVmoM3Yi1lz0+4wZbwgWIXdVHUnBzADMjMwxeaEgvdgWqWU
         5xdA==
X-Gm-Message-State: ACrzQf1tqHVOPvbNmY7c5lfwclBVMabd4CA3lvbhA4B2NbO0X3ByrG97
        o5qtZC8nn8wCq+DAh8j+PqCryQ==
X-Google-Smtp-Source: AMsMyM4I1RDQqelri1SCPrmDm166kkeKKS5ulUGr1s7zJK4ynFIE4YWEz5liRNmVZ8eQ4FUNf9CfMQ==
X-Received: by 2002:a05:620a:1aa4:b0:6ee:ccaa:41bb with SMTP id bl36-20020a05620a1aa400b006eeccaa41bbmr9493728qkb.349.1666280296476;
        Thu, 20 Oct 2022 08:38:16 -0700 (PDT)
Received: from localhost (cpe-174-109-170-245.nc.res.rr.com. [174.109.170.245])
        by smtp.gmail.com with ESMTPSA id c1-20020ac87d81000000b0039a8b075248sm6472754qtd.14.2022.10.20.08.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 08:38:16 -0700 (PDT)
Date:   Thu, 20 Oct 2022 11:38:15 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [RFC v3 11/11] btrfs: add tracepoints for ordered stripes
Message-ID: <Y1FrZ3QUQTQDH/sS@localhost.localdomain>
References: <cover.1666007330.git.johannes.thumshirn@wdc.com>
 <f90279e15449e36f822db47d9759817fa9e72e56.1666007330.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f90279e15449e36f822db47d9759817fa9e72e56.1666007330.git.johannes.thumshirn@wdc.com>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 17, 2022 at 04:55:29AM -0700, Johannes Thumshirn wrote:
> Add tracepoints to check the lifetime of btrfs_ordered_stripe entries.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
