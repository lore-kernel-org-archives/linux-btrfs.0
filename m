Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37957 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751872AbcIHJ5t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 05:57:49 -0400
Date: Thu, 8 Sep 2016 11:56:13 +0200
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] btrfs-progs: receive: Introduce option to exam
 and dump send stream
Message-ID: <20160908095613.GL16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160907002935.8539-1-quwenruo@cn.fujitsu.com>
 <20160907002935.8539-3-quwenruo@cn.fujitsu.com>
 <20160908094228.GK16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160908094228.GK16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 08, 2016 at 11:42:29AM +0200, David Sterba wrote:
> On Wed, Sep 07, 2016 at 08:29:34AM +0800, Qu Wenruo wrote:
> > @@ -1265,19 +1274,37 @@ int cmd_receive(int argc, char **argv)
> >  		}
> >  	}
> >  
> > -	ret = do_receive(&r, tomnt, realmnt, receive_fd, max_errors);
> > +	if (dump) {
> > +		struct btrfs_dump_send_args dump_args;
> > +
> > +		dump_args.root_path = malloc(PATH_MAX);
> > +		dump_args.root_path[0] = '.';
> > +		dump_args.root_path[1] = '\0';
> > +		dump_args.full_subvol_path = malloc(PATH_MAX);
> 
> Please always check malloc return values. I'm fixing this for now.

Uh and the buffers are not freed either. Anyway, I'm switching it to an
array, there's no reason to allocate the memory dynamically.
