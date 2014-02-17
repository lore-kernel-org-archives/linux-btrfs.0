Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49450 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbaBQBUF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 20:20:05 -0500
Message-ID: <1392599797.2278.2.camel@localhost.localdomain>
Subject: Re: [PATCH 4/4] btrfs-progs: fix fsck leaks on error returns
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 17 Feb 2014 09:16:37 +0800
In-Reply-To: <20140214173023.GZ16073@twin.jikos.cz>
References: <1392261398-6197-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <1392261398-6197-4-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <20140214173023.GZ16073@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-02-14 at 18:30 +0100, David Sterba wrote:
> On Thu, Feb 13, 2014 at 11:16:38AM +0800, Gui Hecheng wrote:
> > @@ -6460,6 +6460,7 @@ int cmd_check(int argc, char **argv)
> >  	    !extent_buffer_uptodate(info->dev_root->node) ||
> >  	    !extent_buffer_uptodate(info->chunk_root->node)) {
> >  		fprintf(stderr, "Critical roots corrupted, unable to fsck the FS\n");
> > +		close_ctree(info->fs_root);
> >  		return -EIO;
> 
> Can you please convert it to the 'goto + single return' pattern?

Thanks for your comments, David. I'll rework it soon.

Gui
> The other patches are ok, adding them to integration.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


