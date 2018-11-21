Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F341DC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 02:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAE7021104
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 02:44:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=etsukata-com.20150623.gappssmtp.com header.i=@etsukata-com.20150623.gappssmtp.com header.b="gzL7tHpQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BAE7021104
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=etsukata.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbeKUNQf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 08:16:35 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43416 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbeKUNQf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 08:16:35 -0500
Received: by mail-pl1-f194.google.com with SMTP id gn14so3199845plb.10
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 18:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H/VYLi6U4iBE4eE2CcKKa7D9aRHjN0CLWuRfVxyf9i8=;
        b=gzL7tHpQppPG6H2q6XJAekkauuxuemA3cqF44dCo6WHLkk2+LyxJvAhUsTtq3xNsLc
         /qioC1tOg6QniVxdcLVuJdGX10qWCad8pNj1OdZhZyuITpGGXXdS0Xn8h91Kz4YyofTL
         kE08oGzcexOSTjoJUDdLuQoy53LtvEIBgUgFh3qMhc0pSEiFAGs5eu78afigpBBWtJD2
         OICQkZcUNpnHITn3DbbDIK+AwCUG6GrGItnxn6L08ag25QTS6uE0uPrnxi+o2yRq81ak
         6zg+wXpdy6PX6+7caxkQJpN1qWeMOuQC7kKsdIE//tTq57SFE7E4Lv7o0joJJuE6iGuF
         ZHaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H/VYLi6U4iBE4eE2CcKKa7D9aRHjN0CLWuRfVxyf9i8=;
        b=eyAx6kWtzuNRxPMT2I3aOpHEnQ4qXpU9iODwve6JGGoQb+bNm8YvWE68xjTM1EeWJi
         3nc6Cgl+Y3r59DTqiC9lRTyfibObRQMbvEP9JwSjzmnekNkDvu4HMR4cck1meMr2awhw
         EEsCxiFyA3PCrl2/cB9SJc7iaPVyBoFzfYzdibhQtYY8fGYvaWw9dMn3EjVZnVY7fe3F
         FM7Z9oWWCkuQd8LHP5Q880mkGBOidX7uMoIwCQDezKXbGLsBZzIbItN/3nZPq70mLrb5
         91+2gkz2VSO65kjc9qJsWFpsYpqANt/XU9cQo9NknuDQk4+2b7NLxCc0uFAu770pnjKV
         OtxQ==
X-Gm-Message-State: AA+aEWbuS2lxPEBIvp21BreG1+iVFTPHQEJKdoTWjoaN9uyazC1LIAN6
        LQz+XtgdKwJrH9yHZQP0GarkXA==
X-Google-Smtp-Source: AFSGD/VtX4VsaOh0ScdtJ7EuZP2uGVoUU4W1SYpsS2c6Ge7+MDAz+PmhTQkU02evyhqKpL0SFw784Q==
X-Received: by 2002:a17:902:a411:: with SMTP id p17mr4828581plq.292.1542768253159;
        Tue, 20 Nov 2018 18:44:13 -0800 (PST)
Received: from fedora.fout.local (fs76eecbcd.tkyc008.ap.nuro.jp. [118.238.203.205])
        by smtp.gmail.com with ESMTPSA id l63-v6sm46356677pfb.75.2018.11.20.18.44.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 20 Nov 2018 18:44:12 -0800 (PST)
From:   Eiichi Tsukata <devel@etsukata.com>
To:     andi@firstfloor.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
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
Cc:     Eiichi Tsukata <devel@etsukata.com>
Subject: [PATCH v1 0/4] fs: fix race between llseek SEEK_END and write
Date:   Wed, 21 Nov 2018 11:43:56 +0900
Message-Id: <20181121024400.4346-1-devel@etsukata.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Some file systems (including ext4, xfs, ramfs ...) have the following
problem as I've described in the commit message of the 1/4 patch.

  The commit ef3d0fd27e90 ("vfs: do (nearly) lockless generic_file_llseek")
  removed almost all locks in llseek() including SEEK_END. It based on the
  idea that write() updates size atomically. But in fact, write() can be
  divided into two or more parts in generic_perform_write() when pos
  straddles over the PAGE_SIZE, which results in updating size multiple
  times in one write(). It means that llseek() can see the size being
  updated during write().

  This race changes behavior of some applications. 'tail' is one of those
  applications. It reads range [pos, pos_end] where pos_end is obtained
  via llseek() SEEK_END. Sometimes, a read line could be broken.

  reproducer:

    $ while true; do echo 123456 >> out; done
    $ while true; do tail out | grep -v 123456 ; done

  example output(take 30 secs):

    12345
    1
    1234
    1
    12
    1234

Note: Some file systems which indivisually implements llseek() and hold
      inode mutex lock in it are not affected. ex:) btrfs, ocfs2

Patch 1: re-implements inode lock for SEEK_END in generic_file_llseek()
Patch 2 to 4: implement inode lock for SEEK_END in each file systems

Eiichi Tsukata (4):
  vfs: fix race between llseek SEEK_END and write
  ext4: fix race between llseek SEEK_END and write
  f2fs: fix race between llseek SEEK_END and write
  overlayfs: fix race between llseek SEEK_END and write

 fs/btrfs/file.c     |  2 +-
 fs/ext4/file.c      | 10 ++++++++++
 fs/f2fs/file.c      |  6 +-----
 fs/fuse/file.c      |  5 +++--
 fs/gfs2/file.c      |  3 ++-
 fs/overlayfs/file.c | 23 ++++++++++++++++++++---
 fs/read_write.c     | 37 ++++++++++++++++++++++++++++++++++---
 include/linux/fs.h  |  2 ++
 8 files changed, 73 insertions(+), 15 deletions(-)

-- 
2.19.1

