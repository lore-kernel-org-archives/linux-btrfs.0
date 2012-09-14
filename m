Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:58353 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab2INNyc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 09:54:32 -0400
Date: Fri, 14 Sep 2012 15:54:18 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: cleanup duplicated division functions
Message-ID: <20120914135418.GM17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5051BAB8.7080200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5051BAB8.7080200@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 13, 2012 at 06:51:36PM +0800, Miao Xie wrote:
> div_factor{_fine} has been implemented for two times, cleanup it.
> And I move them into a independent file named math.h because they are
> common math functions.

You removed the sanity checks:

-       if (factor <= 0)
-               return 0;
-       if (factor >= 100)
-               return num;

in new version. And I don't think it's necessary to add an extra include
with a rather generic name and trivial code. A separate .h/.c with
non-filesystem related support code like this looks more suitable.

Do you intend to use the functions out of extent-tree.c ?


david
