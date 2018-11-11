Return-Path: <SRS0=L0dM=NW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F094C43441
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EB4E20871
	for <linux-btrfs@archiver.kernel.org>; Sun, 11 Nov 2018 14:38:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HU5yo1Sa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EB4E20871
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbeKLA0v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 11 Nov 2018 19:26:51 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33608 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbeKLA0v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Nov 2018 19:26:51 -0500
Received: by mail-pl1-f193.google.com with SMTP id w22-v6so3075912plk.0;
        Sun, 11 Nov 2018 06:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wKO8N9kud+dP84v+Lf4AE+9n+QcM8V9UzO4KS7EyofI=;
        b=HU5yo1SaQgZZJXXbqIthDcWbUXEQ9MHGa0Z9gAC7Xjos/rkZHePQCqBnqDUta3W0w7
         W+aeKzS06Nqm5A8LNYVzaNZ3BdFf7tBL/iN3bgEgjD4bM+P3ESfszvchJdaJ6kkDFqaT
         iKoRMQL4ZpByO2DhlqHyEZ5uTD8dV2Tx0twzocvoKCMbeHxSzUSmtvhdZIu5zgVFc/29
         j3gICncJ5Sx8BXl49mzHnvCcTI7y9lV4SmNCM+vDagicM+RcwcT4opw9a0as0xlZ/qWs
         BUGCBeR3AMOatcSKK3FgETgJTD0mm6MR7qeSs0gGx1oDeE1b+YzfOFMhMZdwQ19XWGW7
         HRYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wKO8N9kud+dP84v+Lf4AE+9n+QcM8V9UzO4KS7EyofI=;
        b=sJHALSG3aFihf6CcpPIIW1czJkPeCWA6s6e2WdhJ1J/VmejkBkJU2bfhrObL95TWgq
         1MFFo1BSwWPJp/0q3as8CpqU7xmPfFl/m3mjpzF+rlN29qhv58XX6ZhyplEmRvI+3MFR
         dWbnNCAd8g+NOmPU7YbFhFNldPjJ6uMQI2gr79ROyGVz2BM7fOi3jxjBYD7Slu/N1PrU
         MCl159aefNVGQP17U7atvCr9+Y6gxEWCEBe1Wp8UN5j4ctQz2JbjCE4MN56pwAFstxNC
         P9FvBOVWaLUuQnC7MH7+Ts9lJfORdLzlnmuWqad5SMTAa1QDl82yelDti95RDRS/iVKJ
         BItg==
X-Gm-Message-State: AGRZ1gJJx0H69Cfd8CZSps5VOxq0pjtwZj24UP3LUi6o3sEfCiOOukNH
        P1dqoAy70RaWQsMLVIK49po=
X-Google-Smtp-Source: AJdET5eAROBosGJwUZC2UoBQb3cKeudydem8bY2mlomdmMX8+M5dCKK/BDLyAP3Rwx9h0MidOR/F/g==
X-Received: by 2002:a17:902:ab81:: with SMTP id f1-v6mr16566146plr.103.1541947087165;
        Sun, 11 Nov 2018 06:38:07 -0800 (PST)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id p69-v6sm6407688pfi.85.2018.11.11.06.38.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 11 Nov 2018 06:38:06 -0800 (PST)
Date:   Sun, 11 Nov 2018 22:37:59 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     dsterba@suse.cz
Cc:     Omar Sandoval <osandov@osandov.com>, fstests@vger.kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] fstests: test Btrfs swapfile support
Message-ID: <20181111143759.GA3889@desktop>
References: <cover.1541193856.git.osandov@fb.com>
 <20181104160931.GE12788@desktop>
 <20181106130630.GA24115@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106130630.GA24115@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 06, 2018 at 02:06:30PM +0100, David Sterba wrote:
> On Mon, Nov 05, 2018 at 12:09:31AM +0800, Eryu Guan wrote:
> > On Fri, Nov 02, 2018 at 02:29:35PM -0700, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > 
> > > This series fixes a couple of generic swapfile tests and adds some
> > > Btrfs-specific swapfile tests. Btrfs swapfile support is scheduled for
> > > 4.21 [1].
> > > 
> > > 1: https://www.spinics.net/lists/linux-btrfs/msg83454.html
> > > 
> > > Thanks!
> > 
> > Thanks for the fixes and new tests!
> > 
> > > 
> > > Omar Sandoval (7):
> > >   generic/{472,496,497}: fix $seeqres typo
> > >   generic/{472,496}: fix swap file creation on Btrfs
> > 
> > I've merged above two patches, they're two obvious bug fixes.
> > 
> > >   btrfs: test swap file activation restrictions
> > >   btrfs: test invalid operations on a swap file
> > >   btrfs: test swap files on multiple devices
> > >   btrfs: test device add/remove/replace with an active swap file
> > >   btrfs: test balance and resize with an active swap file
> > 
> > These tests look fine to me, but it'd be really great if btrfs folks
> > could help review above tests and provide Reviewed-by tags.
> 
> All look good to me,
> 
> Reviewed-by: David Sterba <dsterba@suse.com>

Thanks a lot for the review!

> 
> A few nits I saw:
> 
> - the command names should not be shortened, ie. 'btrfs subvolume
>   snapshot' instead of 'btrfs subvol snap'
> - the test description (eg. 3/7 and 4/7) could mention which case is
>   tested, eg. swapfile with compression or COW or snapshot
> - 4/7 has typo 'nowcow' in a comment

I've addressed these nits on commit.

Thanks,
Eryu
