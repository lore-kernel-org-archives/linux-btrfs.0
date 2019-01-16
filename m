Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EF3C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28D642086D
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:34:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="e/eR+7kP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfAPBeM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 20:34:12 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:41858 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbfAPBeM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 20:34:12 -0500
Received: by mail-yw1-f68.google.com with SMTP id f65so1867867ywc.8
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 17:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=KMd9Yiv47TcMVQtOfdj8FHbAK+hUDOn6zgaUvuTBO6M=;
        b=e/eR+7kPpj7TpL/cv683cVRKHhSvp/M65ZS9Q8r/AOpJGvahNgs8VVOA6TXH1Dxes4
         kKz4+oPdU7FftLwN/Il/IcdfsCEQAKo1suNVyXS3Kkqw8etiPj/Du6hA2XcHNrBMpZxZ
         Mb7QrdcOX7cxv5QxetYdpZNyB2bJpZ+A4xiZPToW8I1Go0rY8F5WhS4SQD0GwQRijM+P
         qDGqnJL9T6TKSrX4AuRLF1tnyF+sCQaORBcErUTpHkRTHmGzBMRvDlRgANp1KiCn44jb
         hzMVNcmw1ewSUI7HiihEIVNDNqwCaD8Bb0BWqIL7eCLo/GdMU6voDH0RbwyxjWbAiv+h
         Md2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=KMd9Yiv47TcMVQtOfdj8FHbAK+hUDOn6zgaUvuTBO6M=;
        b=eusS/0CuOZAn8g3V3w15LSBr4mLrK5KekK+Tqn2n+rJ5+uov9sAC0cwQbv5Aw4lpIK
         M05C+1VYfdugkYATn0iv23QdylasnQLndphFEOgzbh7stm/oQEut+vjJYcip6v2nDJdz
         fLugKiwdCInT+HAnFnK86KBLbMdkkf8JXjnqJdcRqTUlsey4+ln3BUebGggG0EAxd/j4
         1ntwM3Y8MemtQ7FDtdH+0Gu4D1Nonps76j5pDFlmpgCmgrGi2o/9ImkRDmM4DKkAA3am
         RjS3zYIvRx4Phzue3kOaxEHcVH07TQnrXEOEjBmX5basPPFp4TjA81cBL2Ib2eAaHOF1
         xDzQ==
X-Gm-Message-State: AJcUukcW27aQLcaQw6rsfYf/bdkQpDn7JE2AwZUugrdz2eVhrNFRepSE
        lOR0CP1j6gs1iPwumddAS2qsSw==
X-Google-Smtp-Source: ALg8bN6DOyOGZa1191GXblGHMrgBreinpgz6RQFvan48/Ty5ESomUfVsG4wNNYHlm18qEm4mo6OHFA==
X-Received: by 2002:a81:5d7:: with SMTP id 206mr5871822ywf.360.1547602451253;
        Tue, 15 Jan 2019 17:34:11 -0800 (PST)
Received: from localhost ([2620:10d:c091:180::1:e59b])
        by smtp.gmail.com with ESMTPSA id e124sm1835630ywf.17.2019.01.15.17.34.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 17:34:10 -0800 (PST)
Date:   Tue, 15 Jan 2019 20:34:09 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
Message-ID: <20190116013408.adq7rny5n3p2sa2q@macbook-pro-91.dhcp.thefacebook.com>
References: <20190115081604.785-1-wqu@suse.com>
 <20190115172625.pgblt26vzmdnsv5w@macbook-pro-91.dhcp.thefacebook.com>
 <40fa6d23-00e0-666e-60f5-1505e157aacc@suse.de>
 <adf8aa97-2638-26f7-1cb2-813ef5a342c9@gmx.com>
 <20190116011556.5qzmvu5m7ub6fm7m@macbook-pro-91.dhcp.thefacebook.com>
 <3f0a8149-2e07-73a8-0cdd-46528f03915a@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f0a8149-2e07-73a8-0cdd-46528f03915a@gmx.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 16, 2019 at 09:29:29AM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/1/16 上午9:15, Josef Bacik wrote:
> > On Wed, Jan 16, 2019 at 09:07:26AM +0800, Qu Wenruo wrote:
> >>
> >>
> >> On 2019/1/16 上午8:31, Qu Wenruo wrote:
> >>>
> >>>
> >>> On 2019/1/16 上午1:26, Josef Bacik wrote:
> >>>> On Tue, Jan 15, 2019 at 04:15:57PM +0800, Qu Wenruo wrote:
> >>>>> This patchset can be fetched from github:
> >>>>> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree
> >>>>>
> >>>>> Which is based on v5.0-rc1.
> >>>>>
> >>>>
> >>>> I've been testing these patches hoping to get rid of the qgroup deadlock that
> >>>> these patches are supposed to fix, but instead they make the box completely
> >>>> unusable with 100% cpu usage for minutes at a time at every transaction commit.
> >>>
> >>> I'm afraid it's related to the v5.0-rc1 base, not the patchset itself.
> >>>
> >>> Just try to balance metadata with 16 snapshots, you'll see btrfs bumping
> >>> its generation like crazy, no matter if quota is enabled or not.
> >>>
> >>> And since btrfs is committing transaction like crazy, no wonder it will
> >>> do tons of qgroup accounting.
> >>>
> >>> My bisect leads to commit 64403612b73a94bc7b02cf8ca126e3b8ced6e921
> >>> btrfs: rework btrfs_check_space_for_delayed_refs.
> >>
> >> Furthermore, you could try this RFC test case to see the problem.
> >> https://patchwork.kernel.org/patch/10761715/
> >>
> >> It would only take around 100s for v4.20 but over 500 for v5.0-rc1 with
> >> tons of unnecessary transaction committed for nothing, no quota enabled.
> >>
> >> So I'm afraid that commit is blocking my qgroup patchset.
> >>
> > 
> > I've fixed the balance problem, it took 2 seconds to figure out, I'm just
> > waiting on xfstests to finish running.
> > 
> > And your patch making things worse has nothing to do with that problem.  Our
> > test doesn't run balance, so the issue you reported has nothing to do with the
> > fact that your patch makes our boxes unusable with qgroups on.
> > 
> > The problem is with your deadlock avoidence patch we're now making a lot more
> > dirty extents to run in the critical section of the transaction commit.  Also
> > because we're no longer pre-fetching the old roots, we're doing the old roots
> > and new roots lookup inside the critical section, so now each dirty extent takes
> > 2x as long.  With my basic test it was taking 5 minutes to do the qgroup
> > accounting, which keeps the box from booting essentially.
> > 
> > Without your patch it's still awful because btrfs-cleaner just sits there at
> > 100% while deleting snapshots, but at least it's not making the whole system
> > stop running while it does all that work in the transaction commit.
> > 
> > And if you had done the proper root cause analysis you would have noticed that
> > we're taking tree locks in the find_parent_nodes() case when we're searching the
> > commit root, something we shouldn't be doing.  So all that really needs to be
> > done is to check if (!path->skip_locking) btrfs_tree_read_lock(eb); in those
> > cases and the deadlock goes away.  Because no matter what we shouldn't be taking
> > locks when we're not given a trans in the backref lookup code.
> 
> That indeed looks much better than my current solution.
> 
> Although I'm not 100% sure for cases like tree blocks shared between
> commit and current root (tree block not modified yet).

Doesn't matter, the block can't be modified so we don't need the locking,  If
the current root needs to change it then it cow's it and messes with the new eb,
not the one attached to the commit root.

> 
> I'll definitely invest more time to try to fix this bug.
> 

Don't worry about it, I'm already running the patch through my tests, I'll send
them in the morning when the tests are finished.  Thanks,

Josef
