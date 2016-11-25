Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45390 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753700AbcKYJfl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 04:35:41 -0500
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>, Omar Sandoval <osandov@osandov.com>
Subject: don't poke into bio internals V2
Date: Fri, 25 Nov 2016 09:07:45 +0100
Message-Id: <1480061273-5722-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

this series has a few patches that switch btrfs to use the proper helpers for
accessing bio internals.  This helps to prepare for supporting multi-page
bio_vecs, which are currently under development.

Changes since v1:
 - fixed two compression related bugs
 - various minor cleanups
 - dropped the last patch of the old series for now - I think
   the old code there is already buggy, but it seems like no one
   can fully explain to me what it's actually supposed to do..
