Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39969 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaIRFAt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 01:00:49 -0400
Received: by mail-pd0-f173.google.com with SMTP id ft15so603752pdb.18
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Sep 2014 22:00:48 -0700 (PDT)
Date: Wed, 17 Sep 2014 22:00:45 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix find_mount_root() to handle duplicated
 mount point correctly
Message-ID: <20140918050045.GA17002@mew.web-pass.com>
References: <1409797668-11870-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20140914074655.GA13454@mew.web-pass.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140914074655.GA13454@mew.web-pass.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What's the status on this patch? There have been at least a couple of bug
reports that this fixes, including
https://bugzilla.kernel.org/show_bug.cgi?id=83741.
-- 
Omar
