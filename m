Return-Path: <SRS0=byT/=MO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A378C43143
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 18:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EB122064E
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Oct 2018 18:28:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1EB122064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fieldses.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbeJCBMn convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Oct 2018 21:12:43 -0400
Received: from fieldses.org ([173.255.197.46]:56426 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbeJCBMm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Oct 2018 21:12:42 -0400
Received: by fieldses.org (Postfix, from userid 2815)
        id 5CCB41C9E; Tue,  2 Oct 2018 14:28:00 -0400 (EDT)
Date:   Tue, 2 Oct 2018 14:28:00 -0400
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Joshi <joshiiitr@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: cross-fs copy support
Message-ID: <20181002182800.GA8364@fieldses.org>
References: <CA+1E3rLXPwzfO3ro49ZVg7RfpYon5YDB6Y_zqu60ivpgn4wenw@mail.gmail.com>
 <2a92fff4-d005-835a-3bd7-a328b008857f@gmx.com>
 <df92a795-3f2e-751a-8504-030015fba6d9@sandeen.net>
 <FE6394EC-5CB0-4A16-AAC6-97F465A4E50C@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <FE6394EC-5CB0-4A16-AAC6-97F465A4E50C@dilger.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
From:   bfields@fieldses.org (J. Bruce Fields)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 01, 2018 at 01:51:09PM -0600, Andreas Dilger wrote:
> On Oct 1, 2018, at 9:49 AM, Eric Sandeen <sandeen@sandeen.net> wrote:
> > Yes, I would expect there to be problems with his modified kernel
> > for a filesystem that supports clone_file_range, because
> > vfs_copy_file_range() will clone if possible, and this should fail across
> > filesystems.
> > 
> > In general, though, I don't know for sure why we don't fall back to
> > do_splice_direct() across filesystems, although the filesystems that
> > implement their own ->copy_file_range ops may have their own,
> > further restrictions within their implementations.
> > 
> > This call /is/ documented in the manpage as only being valid for
> > files on the same filesystem, though:
> > http://man7.org/linux/man-pages/man2/copy_file_range.2.html
> 
> There was a patch to allow cross-mount copy for NFS, but it hasn't landed
> yet.

I thought Christoph Hellwig vetoed it partly because he thought NFS
server-to-server copy is too complicated.  Which perhaps it is, but I
suspect we'll do it anyway because the benefit seems obvious.

--b.
