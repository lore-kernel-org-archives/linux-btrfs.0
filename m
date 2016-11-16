Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41687 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932155AbcKPMwV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 07:52:21 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6zhM-0005QC-Fa
        for linux-btrfs@vger.kernel.org; Wed, 16 Nov 2016 12:52:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Subject: don't poke into bio internals
Date: Wed, 16 Nov 2016 13:52:07 +0100
Message-Id: <1479300736-9724-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

this series has a few patches that switch btrfs to use the proper helpers for
accessing bio internals.  This helps to prepare for supporting multi-page
bio_vecs, which are currently under development.
