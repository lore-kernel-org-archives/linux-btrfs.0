Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41EABC43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 09:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F318E20989
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 09:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KoD1Aprt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F318E20989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbeKUT50 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 14:57:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:54184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbeKUT5Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 14:57:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=p84vfnNyk96jU95Gxdp3t/FHiKW4InuBz1Vk1V8sLrI=; b=KoD1AprtS8paGKywSh1/+FLeh
        7Z2G2xmOWEnCcxat1bO+87kLkK7Crustsg8guLT6KbMp/4S7GyHZWx/haAagsK9RmjU+BuzGQvbUo
        eHuES7RpS7WThYdzdODUR/GYpAfT2PM9qGWEI7assHXUo//jIVlOEh4Ep5CCnrbWImhtYZALmY+A/
        QjpQmxwpInC8nhP8UCQbkDRbONIrTAFHMJGxKQ5b0w/W8k9B+wfSomk6plywiTUP2UC8tUNN5ra+9
        +wEWUnRKFpoOtUE91VmArJI8dWH0g6s8gl0nJMK2EfaSu1h3NtWNM7jH8xH+pMHfT7hx/CCzCDAk9
        YPFgerYbA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gPOj4-0004oM-Sz; Wed, 21 Nov 2018 09:23:14 +0000
Date:   Wed, 21 Nov 2018 01:23:14 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eiichi Tsukata <devel@etsukata.com>
Cc:     andi@firstfloor.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v1 3/4] f2fs: fix race between llseek SEEK_END and write
Message-ID: <20181121092314.GB10667@infradead.org>
References: <20181121024400.4346-1-devel@etsukata.com>
 <20181121024400.4346-4-devel@etsukata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121024400.4346-4-devel@etsukata.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 11:43:59AM +0900, Eiichi Tsukata wrote:
> This patch itself seems to be just a cleanup but with the
> commit b25bd1d9fd87 ("vfs: fix race between llseek SEEK_END and write")
> it fixes race.

Please move this patch to the beginning of the series and replace
the commit log with something like the one below.  Note that your
commit id is different from the one that will appear once applied
upstream, so the aboe isn't too helpful.

---
f2fs: use generic_file_llseek

f2fs always passes inode->i_sb->s_maxbytes to generic_file_llseek_size,
and thus should simply use generic_file_llseek.  For now this is a just
a cleanup, but it will allow f2fs to pick up a race fix in
generic_file_llseek for free.
