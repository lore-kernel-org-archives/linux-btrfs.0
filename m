Return-Path: <SRS0=X8W1=NL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA46C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 09:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79EF520821
	for <linux-btrfs@archiver.kernel.org>; Wed, 31 Oct 2018 09:22:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=philpotter-co-uk.20150623.gappssmtp.com header.i=@philpotter-co-uk.20150623.gappssmtp.com header.b="veD8XXq8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79EF520821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=philpotter.co.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbeJaSTx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 31 Oct 2018 14:19:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54913 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727773AbeJaSTx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Oct 2018 14:19:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id r63-v6so14370771wma.4
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2018 02:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Afq139OT4q2fWw6k8adwLxc6tAXuLy8btF2dPL18C2k=;
        b=veD8XXq8VnLUUI5NYZtKDDCTpEOI2cYbVzPV4o+qqDVk8CHK6ULbC1DZqwzkCiNytI
         qs7IJ428+POfbTQ9cOyGNrLA9d4Yhf254ht2rz+NAnRf9otKC7uPVRgl86tkqUkdy6CJ
         rneGJmnhZD6qoeDeXTyGwqnhk81rrMOz9fBn2D6hkYZ3597ASp/ld17+VDQI+/IKWMdq
         2Zrt9J8EB81HDcx17XZ2sxKclVMZbWQWMlE8FdJKfvsOkoUWXWHDBlAOi6vB98J2VENf
         tG5wghWokWHNAOS88nkNIwz3xOuJqaWL3KtwUD832Xr0gXnlsFVDk+rb63LJgSBkwUFt
         LkNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Afq139OT4q2fWw6k8adwLxc6tAXuLy8btF2dPL18C2k=;
        b=Ucp/p559ZFSNLvzRqUVx1llME7ZUVHndqkHyjavs2gDA0LFT49IHvKcszGqACQACk/
         jAaAkGUJZwFZf31awjRiK/F7u7JbpKblafm6wrxcF+6I2AQOl28O7LE/vmy4r+kVaF6+
         827jzLDdGW/6B4y35kQToqwncMoQ6tFqmTS3GCJ9q9nVrU8ZKDo70jDqfrLoAdNwR7vx
         7S7/XVVqKHJQb7fz1exbsHozO4bdKpU00CY0uCKtMKOK2wpJz8V1H0XFbiJ7F6yCkY8V
         AHL9QaBiN4t+2VCrMXFevWYiDF54iqtTzq0ctAn5LRU8gq/ll4mcxC7/9c6kmx3+q6jN
         6RXQ==
X-Gm-Message-State: AGRZ1gIcePCwi1plnLPLlHt1qwmrqbVaq87qJLK2G5A35XJy272r9lD7
        4SRoL54Uyu2weujTKDLF6uBz+w==
X-Google-Smtp-Source: AJdET5d5j6Sj5RmW6w0Z8Tv9eZ0yjgD/x2uMBaZBcrfoioGGr3zEwocTensvfJzHv75zg5LCUWIqyw==
X-Received: by 2002:a1c:1804:: with SMTP id 4-v6mr1568058wmy.29.1540977753751;
        Wed, 31 Oct 2018 02:22:33 -0700 (PDT)
Received: from pathfinder (62-64-249-96.dynamic.dsl.as9105.com. [62.64.249.96])
        by smtp.gmail.com with ESMTPSA id 125-v6sm12104706wmy.32.2018.10.31.02.22.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 31 Oct 2018 02:22:33 -0700 (PDT)
Date:   Wed, 31 Oct 2018 09:22:31 +0000
From:   Phillip Potter <phil@philpotter.co.uk>
To:     David Sterba <dsterba@suse.cz>
Cc:     clm@fb.com, amir73il@gmail.com, viro@zeniv.linux.org.uk,
        jbacik@fb.com, dsterba@suse.com, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC][PATCH v3 10/10] btrfs: use common file type conversion
Message-ID: <20181031092231.GC19486@pathfinder>
References: <20181027005331.GA9924@pathfinder>
 <20181027005348.GA9996@pathfinder>
 <20181030190317.GH9136@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030190317.GH9136@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 30, 2018 at 08:03:17PM +0100, David Sterba wrote:
> On Sat, Oct 27, 2018 at 01:53:48AM +0100, Phillip Potter wrote:
> > Deduplicate the btrfs file type conversion implementation - file systems
> > that use the same file types as defined by POSIX do not need to define
> > their own versions and can use the common helper functions decared in
> > fs_types.h and implemented in fs_types.c
> > 
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> 
> Acked-by: David Sterba <dsterba@suse.com>

Dear David,

Thanks for this - are you happy for me to move the compile-time tests as per
Amir's suggestion?

Regards,
Phil
