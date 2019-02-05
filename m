Return-Path: <SRS0=OwrN=QM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90C6C282CB
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 18:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80E6320811
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 Feb 2019 18:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549391437;
	bh=yYjW6TQ5bJLSKPJOTmzOFHIb/oS+I16wQZ83MT6EGFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=sj6yq9LpYrels5lIJSNynaRxBFvhNLwkl9ayufC//BMDQlMPEOzaDLuEyGlkkmNeg
	 W/kTQpi6ufe/i9YVp9cwhEQ+8ZTuFAmcnvvUXk2s0EDC0wOUXscuioq+TNUXUY/bAk
	 RXaOqJbwC+vGW1jtcW1qgt7LoFclyLO4OZNkDzl0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730072AbfBESab (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 Feb 2019 13:30:31 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:33391 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728993AbfBESab (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2019 13:30:31 -0500
Received: by mail-yb1-f195.google.com with SMTP id w2so1057695ybi.0;
        Tue, 05 Feb 2019 10:30:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0SFVmRLIZxL5TJiVJ0QAhaofKWJxJlmq2qAwUZhCAyg=;
        b=pScmnnBENlLx+fvHAGYG6/3HB2+zakCP40RrGgFwPngXc27u3eEDmr9uCDRzhmka9a
         hlkTKRjDosZ+0k2uMI9pGnTHUt2nl3ktfwPSdVTOB/fsw6dRWu3uU1oBs4AOl0H9DKYd
         LZfgjR2LBGfiAc4MyVnZGagiEsgQG2tkoZ50i2e/ngIW6iDSuyjCaG0HfVp+FMmmM1iy
         fa6aWBSJrU0Z8o3CPrU6mt4DxMRXW2nWhEoo9JDSPS/ZnCj0wuCsbu/HpVdynJ97qFoW
         8ogEqrEv6mBmA7Q6cBV44uUbTx7vX8js1feGNMf16h5J16F2CMc3qTOHLwXj8MpZ+ehS
         UJgg==
X-Gm-Message-State: AHQUAuaOn4dCRMwYS86kpGu4fB/4ts1QZwLU+mKXR20BNxYVlQzQz5iE
        NpMj4mgAlxmIhzGNl8Q7/O8=
X-Google-Smtp-Source: AHgI3IaFbRD0uRXtsX2E5I9hRdQgFdQIlDwsjbX/a4kZj4UWPbFM8Y+LuGaevhAF/L7iubPor1CGgg==
X-Received: by 2002:a25:1682:: with SMTP id 124mr5157764ybw.346.1549391430677;
        Tue, 05 Feb 2019 10:30:30 -0800 (PST)
Received: from dennisz-mbp.dhcp.thefacebook.com ([2620:10d:c091:200::6:6d9d])
        by smtp.gmail.com with ESMTPSA id q10sm1476241ywb.18.2019.02.05.10.30.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Feb 2019 10:30:29 -0800 (PST)
Date:   Tue, 5 Feb 2019 13:30:27 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] btrfs: add zstd compression level support
Message-ID: <20190205183027.GA17870@dennisz-mbp.dhcp.thefacebook.com>
References: <20190204202008.51652-1-dennis@kernel.org>
 <20190205145753.GR2900@twin.jikos.cz>
 <20190205160302.GA89375@dennisz-mbp>
 <20190205162733.GT2900@suse.cz>
 <20190205163012.GB89375@dennisz-mbp>
 <20190205165113.GU2900@suse.cz>
 <20190205170749.GV2900@suse.cz>
 <20190205182748.GY2900@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205182748.GY2900@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Feb 05, 2019 at 07:27:49PM +0100, David Sterba wrote:
> On Tue, Feb 05, 2019 at 06:07:49PM +0100, David Sterba wrote:
> > On Tue, Feb 05, 2019 at 05:51:13PM +0100, David Sterba wrote:
> > > On Tue, Feb 05, 2019 at 11:30:12AM -0500, Dennis Zhou wrote:
> > > > > > > Something is wrong, the patchset on top of 5.0-rc5 hangs in test
> > > > > > > btrfs/007, without a stacktrace. V1 was fine and I double checked that
> > > > > > > rc5 itself is fine.
> > > > > > 
> > > > > > Hmmm, well that's awkward. I ran xfstests and that test passed on my
> > > > > > machine. I'll figure out the delta and submit a v3. Thanks David!
> > > > > 
> > > > > It failed on a VM and 2 other physical machines, so it's not somethig
> > > > > related to the testing setup.
> > > > 
> > > > Oh, I wasn't alluding to that. I'm more that sure it's my fault
> > > > somewhere along the line.
> > > 
> > > Hang on, it's probably caused by fstests, as fssum is busy waiting
> > > somewhere, so it's not even kernel code.
> > > 
> > > fstests a4235f29f780b15d9e87c0f2446a53b9e69c5e2d -- ok
> > > fstests 6d17c9076fe9d97d2411e5909e6b255e5e721fc3 (master) -- hangs
> > 
> > Git bisect points to
> > 
> > commit 04b405fa1f8d0cacde489f3d1c8771dfe7a34dc0
> > Author: Zorro Lang <zlang@redhat.com>
> > Date:   Wed Jan 23 15:34:55 2019 +0800
> > 
> >     common/dump: disable splice from FSSTRESS_AVOID
> 
> So with this commit reverted, test btrfs/007 does not hang anymore.

Ok great! I'm going to add a v2 for 0012 to add taking the spin_lock
just to be safe in cleanup. I should have that ready in a few minutes.

Thanks,
Dennis
