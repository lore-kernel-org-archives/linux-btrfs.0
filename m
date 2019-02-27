Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2E0C4360F
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 21:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43B7120842
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 21:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551302703;
	bh=mBt9eEeLU2nxR5ZfeYekx0ewytLH0lcY/nVDD96UuXs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=eC+//JDerZj4j13HtdrVKL/k40/Z8nkXgm9ZUO2zcnzIqFEUoaXyTCPaPBAjB25mi
	 mm2M2k2IUV5rxrfwoa2R3mJTSo3xtbQAdI39Ps2eQ4JFXOPyf8gaVJ97NxrrYxYjOe
	 MzMMyeeyka3LlMraXHo7ttzCUhmYN7xAQVKzl99c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbfB0VY6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 16:24:58 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:43801 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729412AbfB0VY6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 16:24:58 -0500
Received: by mail-yw1-f67.google.com with SMTP id u200so9329995ywu.10;
        Wed, 27 Feb 2019 13:24:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hFSeXi7K4wx8nxYYeX38fshpDBEgh1RwV5lOASIiGcY=;
        b=dgRcrwEmfXBYoDzv0BpKbT8a8wLCtGQV2zlyFPykqUdPOasQ9NoFI52RUOcAqIJqS7
         5t8z4FIBs6ry6NgwlD9bYxj1CNEA6kbkTO1uNwrnH9kxCZEasVlswnlbyIYwywa82Z0e
         TTdZDdVNnPInzATF8KlJmhkCkph9U3mK3qsYgJPhfoWCtTNpNV4LkcZwNtVTnWVCeLd2
         GzWLMA3vwHOSHywR0l5r/emuJeswB2R5L8B++RM7EumyLKQ/gMkT7dGxB3U07zib+sjo
         34xLbNH4yeSBie/K5+ZPAOgrI5IkcXI+g5BZrdbVBGujDJ182zXx4TdURQiXrhDxl+HS
         s/rw==
X-Gm-Message-State: AHQUAuavP+G3mI6iMhhFe250xvwXJRBXFj42pjdE4IAdBVG42bSmjsRJ
        fMklxEGgozafbUF0rA3OK3I=
X-Google-Smtp-Source: AHgI3IYK6rhwwC9JKjcOgphxldNQGK/gxaJTcscJb5VM5eCqinXtP1F+J7fNs4OmJTkUxowyZqN3Mw==
X-Received: by 2002:a81:a00f:: with SMTP id x15mr3002495ywg.163.1551302697871;
        Wed, 27 Feb 2019 13:24:57 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:200::3:8416])
        by smtp.gmail.com with ESMTPSA id a190sm5881381ywg.76.2019.02.27.13.24.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Feb 2019 13:24:56 -0800 (PST)
Date:   Wed, 27 Feb 2019 16:24:54 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: zstd ensure reclaim timer is properly cleaned
 up
Message-ID: <20190227212454.GA38679@dennisz-mbp.dhcp.thefacebook.com>
References: <20190222195348.2728-1-dennis@kernel.org>
 <20190227164441.GY24609@twin.jikos.cz>
 <20190227182916.GA18373@dennisz-mbp.dhcp.thefacebook.com>
 <20190227183650.GC31119@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190227183650.GC31119@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 27, 2019 at 07:36:50PM +0100, David Sterba wrote:
> On Wed, Feb 27, 2019 at 01:29:16PM -0500, Dennis Zhou wrote:
> > > I've noticed while reading the code, why do you use the indirect call
> > > here? The wsm.ops points to btrfs_zstd_compress so free_workspace is
> > > always zstd_free_workspace.
> > > 
> > > The compiler is usually smart to replace such things by direct call if
> > > the type has not escaped, but this is not true for btrfs_compress_op so
> > > the indirect function call must be preserved.
> > 
> > I don't have a strong reason to use the indirect call here. It was just
> > to make it consistent for everyone to use the indirection. This at least
> > is in the cleanup path, so I don't think performance is that important?
> 
> It's not just that, the timer uses it too and there are indirect calls
> of the alloc_workspace callback. The indirection is not used by lzo nor
> zlib code, so I don't see what 'everyone' you mean. In the generic
> compression code it makes sense, I see that.
> 
> > But I don't feel strongly for or against calling zstd_free_workspace()
> > directly.
> 
> I feel strongly about not using the indirection when not necessary :)

Great :). I sent you a patch just now to remove the indirection [1].

[1] https://lore.kernel.org/linux-btrfs/20190227212128.38491-1-dennis@kernel.org

Thanks,
Dennis
