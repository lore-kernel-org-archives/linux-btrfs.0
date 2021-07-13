Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 224A6C11F67
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Jul 2021 14:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01EA861279
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Jul 2021 13:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbhGMOCs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 10:02:48 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:55724 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236696AbhGMOCs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jul 2021 10:02:48 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3IYf-000J4f-K1; Tue, 13 Jul 2021 13:34:45 +0000
Date:   Tue, 13 Jul 2021 13:34:45 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/24] namei: handle mappings in lookup_one_len_unlocked()
Message-ID: <YO2WdWc/DBspIgZH@zeniv-ca.linux.org.uk>
References: <20210713111344.1149376-1-brauner@kernel.org>
 <20210713111344.1149376-3-brauner@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713111344.1149376-3-brauner@kernel.org>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 13, 2021 at 01:13:22PM +0200, Christian Brauner wrote:
> From: Christian Brauner <christian.brauner@ubuntu.com>
> 
> Various filesystems use the lookup_one_len_unlocked() helper to lookup a single
> path component relative to a well-known starting point. Allow such filesystems
> to support idmapped mounts by enabling lookup_one_len_unlocked() to take the
> idmap into account when calling inode_permission().

Ditto.  The same applies to the rest of primitives you modify - if you need
a new variant, *add* *that* *variant*.
