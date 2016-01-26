Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966467AbcAZP6A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 10:58:00 -0500
Date: Tue, 26 Jan 2016 16:57:49 +0100
From: David Sterba <dsterba@suse.cz>
To: Caio Lima <ticaiolima@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] btrfs: cleanup unusable parameters from ctree.h
Message-ID: <20160126155749.GG8567@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1451085669-5009-1-git-send-email-ticaiolima@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1451085669-5009-1-git-send-email-ticaiolima@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 25, 2015 at 06:21:09PM -0500, Caio Lima wrote:
> Cleanup of ununsed parameters in btrfs_header_chunk_tree_uuid,
> btrfs_leaf_data and btrfs_defrag_cancelled

The parameters are unused so the question is what are the functions
supposed to do. They just return offset within the header or leaf
structures.

Adding the _offset to the current function names would make them too
long, I suggest to opencode the 'offsetof(struct ..., member)' instead.
We do that anyway in many places.

Please keep btrfs_defrag_cancelled as-is for now.
