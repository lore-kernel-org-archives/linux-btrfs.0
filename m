Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbbG1MAQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jul 2015 08:00:16 -0400
Date: Tue, 28 Jul 2015 14:00:03 +0200
From: David Sterba <dsterba@suse.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 10/10] btrfs-progs: Allow open_ctree use backup tree
 root or search it automatically if primary tree root is corrupted.
Message-ID: <20150728120003.GH6306@suse.cz>
Reply-To: dsterba@suse.com
References: <1421649912-14539-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1421649912-14539-11-git-send-email-quwenruo@cn.fujitsu.com>
 <20150727150403.GG6306@suse.cz>
 <55B6CE2A.7010000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55B6CE2A.7010000@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 28, 2015 at 08:34:50AM +0800, Qu Wenruo wrote:
> Yes, you were against the automatic use of backup root or especially 
> iteration all metadata space to find the latest tree root.
> 
> I'll try to add a new option like "--full-scan" to enable the automatic 
> search of all metadata space.
> 
> But I'm afraid it may be a little late as I'm recently debugging other 
> things like in-band deduplication.

This is not anything urgent, I was going through my git branches with
pending patches and found this.
