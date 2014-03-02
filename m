Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:52529 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaCBMRD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Mar 2014 07:17:03 -0500
Received: by mail-lb0-f173.google.com with SMTP id p9so3936790lbv.32
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Mar 2014 04:17:01 -0800 (PST)
Received: from vuvuzela.stingr.net ([2001:b08:e:1:6ab5:99ff:fe4f:770a])
        by mx.google.com with ESMTPSA id qf1sm8833558lbc.8.2014.03.02.04.17.00
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Mar 2014 04:17:00 -0800 (PST)
Date: Sun, 2 Mar 2014 16:16:58 +0400
From: Paul Komkoff <i@stingr.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: Beyond-repair corruption, btrfs on ssd
Message-ID: <20140302121658.GB14259@vuvuzela.stingr.net>
References: <20140302091301.GA14259@vuvuzela.stingr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140302091301.GA14259@vuvuzela.stingr.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 02, 2014 at 01:13:01PM +0400, Paul Komkoff wrote:
> Suddenly, a filesystem on SSD became corrupted. None of the usual repair mechanisms work.
> check_tree_block complains (have=0) for blocks in root (?), I have modified it to print
> buf->data and for affected blocks the entire header is filled with zeros.

So I'm able to get some output from btrfs-debug-tree, it is actually able to print some of
the inode items. The question is - did someone already have a tool to extract data for
those inodes?

Thanks.
