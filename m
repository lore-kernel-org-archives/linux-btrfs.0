Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:51114 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab2JCNcv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Oct 2012 09:32:51 -0400
Date: Wed, 3 Oct 2012 09:32:42 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH] Btrfs: try to avoid doing a search in btrfs_next_leaf
Message-ID: <20121003133242.GM2370@localhost.localdomain>
References: <1348516979-2343-1-git-send-email-jbacik@fusionio.com>
 <20121002142538.GV14582@twin.jikos.cz>
 <20121002143232.GE2370@localhost.localdomain>
 <20121002150543.GW14582@twin.jikos.cz>
 <20121002152731.GF2370@localhost.localdomain>
 <506B087F.7030006@gmx.net>
 <CAHf9xvbKMLjrn2MOo4O+NZhHHOFUaXsJ+KwkqBkbUvKKbD9jYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAHf9xvbKMLjrn2MOo4O+NZhHHOFUaXsJ+KwkqBkbUvKKbD9jYg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 03, 2012 at 06:57:26AM -0600, Alex Lyakas wrote:
> Hi Josef,
> in send code, in full_send_tree() there is code like this:
>                 key.objectid = found_key.objectid;
>                 key.type = found_key.type;
>                 key.offset = found_key.offset + 1;
> 
>                 ret = btrfs_next_item(send_root, path);
>                 if (ret < 0)
>                         goto out;
>                 if (ret) {
>                         ret  = 0;
>                         break;
> 
> It wants to jump to the next greater key in the tree, whatever
> objectid it has (the reason is that here we need to traverse the whole
> file tree). I believe with your change it might get broken... What do
> you think?

Yeah you are right, I'll hold off on this for now.  Thanks,

Josef 
