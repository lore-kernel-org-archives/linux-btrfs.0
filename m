Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:49206 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755187AbcJRFYa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Oct 2016 01:24:30 -0400
Date: Tue, 18 Oct 2016 10:24:24 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Divya Indi <divya.indi@oracle.com>, <linux-btrfs@vger.kernel.org>,
        <ashish.samant@oracle.com>, <bo.li.liu@oracle.com>
Subject: Re: [PATCH 2/3] btrfs-progs: Add a command to show bg info
Message-ID: <20161018102424.59fb14e4@natsu>
In-Reply-To: <d9e5bee8-d865-840d-11e4-74f98c34282e@cn.fujitsu.com>
References: <1476750915-3105-1-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-2-git-send-email-divya.indi@oracle.com>
 <1476750915-3105-3-git-send-email-divya.indi@oracle.com>
 <d9e5bee8-d865-840d-11e4-74f98c34282e@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 18 Oct 2016 09:39:32 +0800
Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

> >  static const char * const cmd_inspect_inode_resolve_usage[] = {
> >  	"btrfs inspect-internal inode-resolve [-v] <inode> <path>",
> >  	"Get file system paths for the given inode",
> > @@ -702,6 +814,8 @@ const struct cmd_group inspect_cmd_group = {
> >  			0 },
> >  		{ "min-dev-size", cmd_inspect_min_dev_size,
> >  			cmd_inspect_min_dev_size_usage, NULL, 0 },
> > +		{ "bg_analysis", cmd_inspect_bg_analysis,
> > +			cmd_inspect_bg_analysis_usage, NULL, 0 },
> 
> Just naming preference, IMHO show-block-groups or dump-block-groups 
> seems better for me.

And in any case please don't mix separation by "-" and "_" in the same command
string. In btrfs tool the convention is to separate words in subcommand names
using "-".

-- 
With respect,
Roman
