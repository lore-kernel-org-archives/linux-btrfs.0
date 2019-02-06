Return-Path: <SRS0=hiUa=QN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4531DC169C4
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 16:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1629E20821
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Feb 2019 16:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549471896;
	bh=BgDvxrz5bhbb5BvXsaDThEcuS23Bq22puoxAED0igWA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NC9jQtxReFnhdKt8v0Rj9n1qldl+olkEMVV8vmwwIZyQlPqZlxiGDcVzctHc99blm
	 7xkmjdorxPhBLyytMstPKWnNRKZcP4XgjhLXVWLB6Exp7X9d/Q7BSxtjB1UVjha0u0
	 lnKjhY1QbdtFG2I2Va2umEy00FaGJ4XvtNc16Gy4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731429AbfBFQva (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Feb 2019 11:51:30 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38384 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbfBFQva (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Feb 2019 11:51:30 -0500
Received: by mail-yw1-f68.google.com with SMTP id d190so3405415ywb.5;
        Wed, 06 Feb 2019 08:51:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=USacBrj2u4EhLgSqyuB7qP8mekNzXh+/fRWY15jDSas=;
        b=KroIbaTobChKWgksHaNjY2Trwws5HSdEYpKil0cDVNZV28aPCAYb7d4aSpWnMnXkes
         wr6q2F21zfD/q+8ivz67MDIoTGboUGtZ94AApmpKxY3tIpd7mjY9SjKS75zaz4RPkNra
         qmFzbPt/S1yhN1MeMmZzDiGr00YlxdRWRelXRI3u0nlbETNXlZ1AW7T6zwxeeZWgOzPK
         xTo2jTrlrP/pUTIYNhuTe/J5tljj0GZoUoTV9jziiHis4qFnLc/vgtE0Je777Iu61bSx
         dcsLVEP/Z4EjLcavM88ZaS3m28z3R+f9+WsblWnXpMFOp2HvQAFa7GIsesevpbBvscKT
         pORA==
X-Gm-Message-State: AHQUAuYvGHwfo/2I5W+tl1mApT8dyF71fR+Asr6RNp6yvCzJIx3I4voG
        n+mKNNQzFwq8Pl7PwXtrJDQ=
X-Google-Smtp-Source: AHgI3IYiHSiBf6A3ZrHqgQNeA6dU3l9dBRSZyYMNyIVoS1qSSD00caRbrySWKObDR9NdoxUKIA0Oyg==
X-Received: by 2002:a81:5886:: with SMTP id m128mr8155598ywb.254.1549471889615;
        Wed, 06 Feb 2019 08:51:29 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:200::6:c448])
        by smtp.gmail.com with ESMTPSA id l7sm2618565ywk.24.2019.02.06.08.51.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 08:51:28 -0800 (PST)
Date:   Wed, 6 Feb 2019 11:51:26 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] btrfs: add zstd compression level support
Message-ID: <20190206165126.GA73810@dennisz-mbp.dhcp.thefacebook.com>
References: <20190205145753.GR2900@twin.jikos.cz>
 <20190205160302.GA89375@dennisz-mbp>
 <20190205162733.GT2900@suse.cz>
 <20190205163012.GB89375@dennisz-mbp>
 <20190205165113.GU2900@suse.cz>
 <20190205170749.GV2900@suse.cz>
 <20190205182748.GY2900@twin.jikos.cz>
 <20190205183027.GA17870@dennisz-mbp.dhcp.thefacebook.com>
 <20190205204848.GA39186@dennisz-mbp.dhcp.thefacebook.com>
 <20190206151551.GB2900@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190206151551.GB2900@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 06, 2019 at 04:15:52PM +0100, David Sterba wrote:
> On Tue, Feb 05, 2019 at 03:48:48PM -0500, Dennis Zhou wrote:
> > > Ok great! I'm going to add a v2 for 0012 to add taking the spin_lock
> > > just to be safe in cleanup. I should have that ready in a few minutes.
> > > 
> > 
> > Before I run v3, are there any other concerns (pending the changes I
> > made to address the mentioned make sense)?
> 
> You don't needs to do full v3 resend, either new version of the
> individual patches or incremental changes that can be squashed to the
> patch. I'm about to move the patchset from topic branch to misc-next so
> incrementals work better now as there aren't big updates expected.

Ok great! I just sent a v2 of 0009 and v3 of 00012 which include the
changes for warning on incorrect input and level out of bounds. I did
forget to take out the "Re:" though.. whoops.

Thanks,
Dennis
