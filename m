Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF51FC07E95
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Jul 2021 13:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6128611C0
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Jul 2021 13:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbhGMNod (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 09:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236222AbhGMNod (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jul 2021 09:44:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 994D760C40;
        Tue, 13 Jul 2021 13:41:40 +0000 (UTC)
Date:   Tue, 13 Jul 2021 15:41:37 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/24] namei: handle mappings in lookup_one_len()
Message-ID: <20210713134137.rsfcyk5kxfb3p6lo@wittgenstein>
References: <20210713111344.1149376-1-brauner@kernel.org>
 <20210713111344.1149376-2-brauner@kernel.org>
 <YO2V+n1Cttrky+bD@zeniv-ca.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YO2V+n1Cttrky+bD@zeniv-ca.linux.org.uk>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 13, 2021 at 01:32:42PM +0000, Al Viro wrote:
> On Tue, Jul 13, 2021 at 01:13:21PM +0200, Christian Brauner wrote:
> > From: Christian Brauner <christian.brauner@ubuntu.com>
> > 
> > Various filesystems use the lookup_one_len() helper to lookup a single path
> > component relative to a well-known starting point. Allow such filesystems to
> > support idmapped mounts by enabling lookup_one_len() to take the idmap into
> > account when calling inode_permission(). This change is a required to let btrfs
> > (and other filesystems) support idmapped mounts.
> 
> NAK.  Expose a new variant if you must, but leave the old one alone.

Ok, happy to do that.
