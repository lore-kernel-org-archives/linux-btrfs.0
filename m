Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B69AC46475
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 16:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12C9A20827
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 16:36:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="n5BNVpjL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12C9A20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387537AbeKFB5R (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 20:57:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387444AbeKFB5Q (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 20:57:16 -0500
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19A5B2085A
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Nov 2018 16:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541435807;
        bh=gNYB8+c63sYA64q0+EzVC6mcf9l/DWBCclvTEMSZ2Sk=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=n5BNVpjLmtmlZNH4CJSg3NaJrkC+oDUwm7QSlZ3tluXEE9/LssyFqm86u/4CaIeat
         9CXwgeBEpen7vh1sb9uZaGdwDuCh1I/mm8a7VCNEOguv78V5KuzTCrq/nc9Q/KncJB
         AP5x4uzQ8K7IKHcXXp+iqx5u27coTUgORPxz75AY=
Received: by mail-vs1-f49.google.com with SMTP id g68so2145685vsd.11
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Nov 2018 08:36:47 -0800 (PST)
X-Gm-Message-State: AGRZ1gK6djXrOeYZLrgXtHKFs0lyomdo80h1Wg6k+dhsxQUUT32mEHEI
        hLPPt4P4eRPix1p+eiynLSHE2CuofcrEog/LF+c=
X-Google-Smtp-Source: AJdET5fTFM3P2nYaXsCIn0eB7Bi/B/nroZHJFfJpyNSe2CTIUylMQjoBVSTtlM0MkMC2OPgjNPa+msBhZBa01vvtGaA=
X-Received: by 2002:a67:8a88:: with SMTP id m130mr9619896vsd.206.1541435805900;
 Mon, 05 Nov 2018 08:36:45 -0800 (PST)
MIME-Version: 1.0
References: <20181022090946.1150-1-fdmanana@kernel.org> <20181024091303.20324-1-fdmanana@kernel.org>
 <20181024113717.fcz4klha7isb7r56@MacBook-Pro-91.local> <CAL3q7H5_1T9doxVu-GRCU9-uZVi5q=yw+K+YVqK-As+fJbT6nQ@mail.gmail.com>
 <20181024123959.icp7ssu5sjhqg6c3@MacBook-Pro-91.local> <CAL3q7H7dZm8s2Ey185Xw=bsjG6fZBeEWjQu+He2kQ5JYMPCHWg@mail.gmail.com>
 <20181105162849.GA9136@twin.jikos.cz> <CAL3q7H45e7B9acpDnx-R5hNxu+033Tfx4yD_ynZ_cY3hPfLryg@mail.gmail.com>
 <20181105163418.GB9136@twin.jikos.cz>
In-Reply-To: <20181105163418.GB9136@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 5 Nov 2018 16:36:34 +0000
X-Gmail-Original-Message-ID: <CAL3q7H4P+1FSwuboPjh+FZxz0fVHX9y73WPpQsHEU5jD5O84Lw@mail.gmail.com>
Message-ID: <CAL3q7H4P+1FSwuboPjh+FZxz0fVHX9y73WPpQsHEU5jD5O84Lw@mail.gmail.com>
Subject: Re: [PATCH v4] Btrfs: fix deadlock on tree root leaf when finding
 free extent
To:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 5, 2018 at 4:34 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Mon, Nov 05, 2018 at 04:30:35PM +0000, Filipe Manana wrote:
> > On Mon, Nov 5, 2018 at 4:29 PM David Sterba <dsterba@suse.cz> wrote:
> > >
> > > On Wed, Oct 24, 2018 at 01:48:40PM +0100, Filipe Manana wrote:
> > > > > Ah ok makes sense.  Well in that case lets just make btrfs_read_locked_inode()
> > > > > take a path, and allocate it in btrfs_iget, that'll remove the ugly
> > > > >
> > > > > if (path != in_path)
> > > >
> > > > You mean the following on top of v4:
> > > >
> > > > https://friendpaste.com/6XrGXb5p0RSJGixUFYouHg
> > > >
> > > > Not much different, just saves one such if statement. I'm ok with that.
> > >
> > > Now in misc-next with v4 and the friendpaste incremental as
> > >
> > > https://github.com/kdave/btrfs-devel/commit/efcfd6c87d28b3aa9bcba52d7c1e1fc79a2dad69
> >
> > Please don't add the incremental. It's buggy. It was meant to figure
> > out what Josef was saying. That's why I haven't sent a V5.
>
> Ok dropped, I'll will wait for a proper patch.

It's V4, the last sent version. Just forget the incremental.
Thanks.
