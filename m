Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58192 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbbCXWZ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 18:25:57 -0400
Date: Tue, 24 Mar 2015 23:25:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Chengyu Song <csong84@gatech.edu>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, taesoo@gatech.edu, changwoo@gatech.edu,
        sanidhya@gatech.edu, blee@gatech.edu
Subject: Re: [PATCH 1/1] btrfs: incorrect handling for
 fiemap_fill_next_extent return
Message-ID: <20150324222554.GZ20767@suse.cz>
Reply-To: dsterba@suse.cz
References: <1427235176-19381-1-git-send-email-csong84@gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427235176-19381-1-git-send-email-csong84@gatech.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 24, 2015 at 06:12:56PM -0400, Chengyu Song wrote:
> fiemap_fill_next_extent returns 0 on success, -errno on error, 1 if this was
> the last extent that will fit in user array. If 1 is returned, the return
> value may eventually returned to user space, which should not happen, according
> to manpage of ioctl.
> 
> Signed-off-by: Chengyu Song <csong84@gatech.edu>

Good catch, thanks.

Reviewed-by: David Sterba <dsterba@suse.cz>

Should go to stable.
