Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:51972 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab2JSMpC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 08:45:02 -0400
Message-ID: <50814B47.1020306@oracle.com>
Date: Fri, 19 Oct 2012 20:44:55 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] Btrfs: cleanup unused arguments
References: <1350640255-3760-1-git-send-email-bo.li.liu@oracle.com> <1350640255-3760-4-git-send-email-bo.li.liu@oracle.com> <5081443B.5060706@jan-o-sch.net>
In-Reply-To: <5081443B.5060706@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/19/2012 08:14 PM, Jan Schmidt wrote:
> Hi liubo,
> 
> Patches 3 and 4 are looking good. I'm still trying to sort out on the other two,
> as I cannot reproduce your bug with your script, unfortunately.
> 
> After applying all 4 patches, the result doesn't compile, here:
> 
> fs/btrfs/ctree.c: In function 'balance_level':
> fs/btrfs/ctree.c:1799: warning: passing argument 3 of
> 'tree_mod_log_set_node_key' makes integer from pointer without a cast
> fs/btrfs/ctree.c:774: note: expected 'int' but argument is of type 'struct
> btrfs_disk_key *'
> fs/btrfs/ctree.c:1799: error: too many arguments to function
> 'tree_mod_log_set_node_key'
> fs/btrfs/ctree.c:1844: warning: passing argument 3 of
> 'tree_mod_log_set_node_key' makes integer from pointer without a cast
> fs/btrfs/ctree.c:774: note: expected 'int' but argument is of type 'struct
> btrfs_disk_key *'
> fs/btrfs/ctree.c:1844: error: too many arguments to function
> 'tree_mod_log_set_node_key'
> fs/btrfs/ctree.c: In function 'push_nodes_for_insert':
> fs/btrfs/ctree.c:1943: warning: passing argument 3 of
> 'tree_mod_log_set_node_key' makes integer from pointer without a cast
> fs/btrfs/ctree.c:774: note: expected 'int' but argument is of type 'struct
> btrfs_disk_key *'
> fs/btrfs/ctree.c:1943: error: too many arguments to function
> 'tree_mod_log_set_node_key'
> fs/btrfs/ctree.c:1996: warning: passing argument 3 of
> 'tree_mod_log_set_node_key' makes integer from pointer without a cast
> fs/btrfs/ctree.c:774: note: expected 'int' but argument is of type 'struct
> btrfs_disk_key *'
> fs/btrfs/ctree.c:1996: error: too many arguments to function
> 'tree_mod_log_set_node_key'
> fs/btrfs/ctree.c: In function 'fixup_low_keys':
> fs/btrfs/ctree.c:2880: warning: passing argument 3 of
> 'tree_mod_log_set_node_key' makes integer from pointer without a cast
> fs/btrfs/ctree.c:774: note: expected 'int' but argument is of type 'struct
> btrfs_disk_key *'
> fs/btrfs/ctree.c:2880: error: too many arguments to function
> 'tree_mod_log_set_node_key'
>   CC [M]  fs/btrfs/sysfs.o
> make[2]: *** [fs/btrfs/ctree.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [fs/btrfs] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [fs] Error 2
> 

oh, I'm so sorry, I forgot to format new patches and sent the wrong version.

Sorry for the trouble.

thanks,
liubo

> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

