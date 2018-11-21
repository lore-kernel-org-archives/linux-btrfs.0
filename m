Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CD7C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 04:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8759221104
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 04:55:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8759221104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ZenIV.linux.org.uk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbeKUP16 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 10:27:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38634 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbeKUP15 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 10:27:57 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gPKXB-0006yZ-5J; Wed, 21 Nov 2018 04:54:41 +0000
Date:   Wed, 21 Nov 2018 04:54:41 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     Eiichi Tsukata <devel@etsukata.com>
Cc:     andi@firstfloor.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v1 0/4] fs: fix race between llseek SEEK_END and write
Message-ID: <20181121045440.GM32577@ZenIV.linux.org.uk>
References: <20181121024400.4346-1-devel@etsukata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121024400.4346-1-devel@etsukata.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 11:43:56AM +0900, Eiichi Tsukata wrote:
> Some file systems (including ext4, xfs, ramfs ...) have the following
> problem as I've described in the commit message of the 1/4 patch.
> 
>   The commit ef3d0fd27e90 ("vfs: do (nearly) lockless generic_file_llseek")
>   removed almost all locks in llseek() including SEEK_END. It based on the
>   idea that write() updates size atomically. But in fact, write() can be
>   divided into two or more parts in generic_perform_write() when pos
>   straddles over the PAGE_SIZE, which results in updating size multiple
>   times in one write(). It means that llseek() can see the size being
>   updated during write().

And?  Who has ever promised anything that insane?  write(2) can take an arbitrary
amount of time; another process doing lseek() on independently opened descriptor
is *not* going to wait for that (e.g. page-in of the buffer being written, which
just happens to be mmapped from a file on NFS over RFC1149 link).
