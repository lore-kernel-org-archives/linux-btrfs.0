From: Artem <artemciy@gmail.com>
Subject: Re: File compression control, again.
Date: Wed, 28 Sep 2011 13:26:11 +0000 (UTC)
Message-ID: <loom.20110928T151702-530@post.gmane.org>
References: <loom.20110927T185853-434@post.gmane.org> <4E827C41.1000805@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Li Zefan <lizf <at> cn.fujitsu.com> writes:
> See this "Per file/directory controls for COW and compression":
> 
> 	http://marc.info/?l=linux-btrfs&m=130078867208491&w=2
> 
> And the user tool patch (which got no reply):
> 
> 	http://marc.info/?l=linux-btrfs&m=130311215721242&w=2
> 
> So you can create a directory, and set the no-compress flag for it, and
> then any file created in that dir will inherit the flag.

Thanks, Li, but how do I set the no-compress flag?
The patched chattr you mention can only set the FS_COMPR_FL.
The 'C' argument is now used for FS_NOCOW_FL.

Could we use another flag for copy-on-write control in chattr?

