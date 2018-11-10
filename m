Return-Path: <SRS0=TwUB=NV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D76BC43441
	for <linux-btrfs@archiver.kernel.org>; Sat, 10 Nov 2018 06:07:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE1C12081C
	for <linux-btrfs@archiver.kernel.org>; Sat, 10 Nov 2018 06:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="H5ADuD9n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE1C12081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbeKJPuy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 10 Nov 2018 10:50:54 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:43705 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728644AbeKJPux (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Nov 2018 10:50:53 -0500
Received: by mail-io1-f67.google.com with SMTP id t81-v6so2835193iod.10
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Nov 2018 22:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=nokgp88TzuL8Bhg2thLsYSGqBeY3wXXOtI3MTRJ1Ku0=;
        b=H5ADuD9njTaumasM4KA50HP7s5MoLsEiMocQP2Eet6qa+KIe4UDn9JICh4mdfzHGZZ
         6Jv6YRk/RgrRGlZNJ8KRQdrLJIDpzEQnYa5E9NpU2gtCoESYrTI7iAluRzcmkGQfvdtJ
         frNxBpR+so1g8MhN3uhdbCLXUaiASpL7r9VTUyLHJl+gUrKTBDRV7bwYoBptjHQdbEzq
         v8cT6KMjB88KPeA3LnKCqhbSdQksSxbWnR4vY03bXTxCXuDY3S6XW8qlZNIp0KFJwM4e
         mFJ6GRNDtAhLXlsE6XchmnrqKWTAaovHBX24je9Qa9bQSW7KN1SG+TQw7iY7w4jiD9eH
         0vOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=nokgp88TzuL8Bhg2thLsYSGqBeY3wXXOtI3MTRJ1Ku0=;
        b=XvXaS1yfVDIY1pLTcKRwJ5wKPvbkP6MunfWL73M5BKmS/9zQa4C1/dxBysg+II+w+Q
         zgGlJykwJwOJGQLqkydEhsayWWwMa7xzwq9Aw7jJ8SvZqFp6xlN5LCq9eA+Af0v+PJav
         DU3wSIfTJHjjirERf/43SYjQO6zv3F36GiThu12HybYAq9QUJ8ShWpxvEPdUa2LQDrcd
         rBti7I2xSphB12t000ONdD4c6rqLm4lUJ/Mc4/gWUJZKn0zDyZdd47jHsDLIEH6R2CGv
         2BJhC5TRyyzbRhe9CYj8LFxKqEq8D3FmFsRkEgve8Z6fSC3Lpte5nZFgpKoXX6QjVoH+
         wVbg==
X-Gm-Message-State: AGRZ1gJL3umz7ubvKOE7lBkfbkcqLMzVpZeGWZbCSTAOEdutUcispzUk
        2E8iQl8T0v4sOqh9L7oynVN3pg4Tgvs=
X-Google-Smtp-Source: AJdET5chCEBF5V2X16FiVjUjctLlynHmnnWpF0rVFDPU57oUrEL7k4tIofc2lnHMoIx8DrILEoNKow==
X-Received: by 2002:a6b:bf86:: with SMTP id p128-v6mr9377022iof.49.1541823163178;
        Fri, 09 Nov 2018 20:12:43 -0800 (PST)
Received: from vader ([2620:10d:c090:180::1:7deb])
        by smtp.gmail.com with ESMTPSA id t70-v6sm1570114itb.30.2018.11.09.20.12.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 20:12:42 -0800 (PST)
Date:   Fri, 9 Nov 2018 20:12:39 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v9 0/6] Btrfs: implement swap file support
Message-ID: <20181110041239.GB23447@vader>
References: <cover.1538072009.git.osandov@fb.com>
 <20181106095451.GG9136@twin.jikos.cz>
 <20181107144937.GE24115@twin.jikos.cz>
 <aec6451b-1198-7888-9dbc-0d6576d1ea4e@suse.com>
 <20181107152810.GF24115@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181107152810.GF24115@twin.jikos.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 07, 2018 at 04:28:10PM +0100, David Sterba wrote:
> On Wed, Nov 07, 2018 at 05:07:00PM +0200, Nikolay Borisov wrote:
> > 
> > 
> > On 7.11.18 г. 16:49 ч., David Sterba wrote:
> > > On Tue, Nov 06, 2018 at 10:54:51AM +0100, David Sterba wrote:
> > >> On Thu, Sep 27, 2018 at 11:17:32AM -0700, Omar Sandoval wrote:
> > >>> From: Omar Sandoval <osandov@fb.com>
> > >>> This series implements swap file support for Btrfs.
> > >>>
> > >>> Changes from v8 [1]:
> > >>>
> > >>> - Fixed a bug in btrfs_swap_activate() which would cause us to miss some
> > >>>   file extents if they were merged into one extent map entry.
> > >>> - Fixed build for !CONFIG_SWAP.
> > >>> - Changed all error messages to KERN_WARN.
> > >>> - Unindented long error messages.
> > >>>
> > >>> I've Cc'd Jon and Al on patch 3 this time, so hopefully we can get an
> > >>> ack for that one, too.
> > >>>
> > >>> Thanks!
> > >>>
> > >>> 1: https://www.spinics.net/lists/linux-btrfs/msg82267.html
> > >>>
> > >>> Omar Sandoval (6):
> > >>>   mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
> > >>>   mm: export add_swap_extent()
> > >>>   vfs: update swap_{,de}activate documentation
> > >>>   Btrfs: prevent ioctls from interfering with a swap file
> > >>>   Btrfs: rename get_chunk_map() and make it non-static
> > >>>   Btrfs: support swap files
> > >>
> > >> fstest generic/472 reports an assertion failure. This is on the updated fstests
> > >> git (70c4067285b0bc076), though it should not matter:
> > >>
> > >> [16597.002190] assertion failed: IS_ALIGNED(start, fs_info->sectorsize) && IS_ALIGNED(end + 1, fs_info->sectorsize), file: fs/btrfs/file-item.c, line: 319
> > > 
> > > I have to revert the patch for now as it kills the testing machines.
> > 
> > The reason is that the isize is not aligned to a sectorsize. Ie it
> > should be:
> > 
> > +       u64 isize = ALIGN_DOWN(i_size_read(inode), fs_info->sectorsize);
> > 
> > With this fixlet generic/472 succeeds.
> 
> Thanks for the fix, I'll fold it in.

Thanks, Nikolay, I missed that. I don't think i_size_read() is
necessary, though, since the inode is locked.
