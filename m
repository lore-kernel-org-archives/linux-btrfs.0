Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757848AbbIVNof (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:44:35 -0400
Date: Tue, 22 Sep 2015 15:43:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: avoid passing int param to start_transaction
 which takes u64
Message-ID: <20150922134340.GF12815@suse.cz>
Reply-To: dsterba@suse.cz
References: <20150913184720.GA25846@gmail.com>
 <20150922130933.GD12815@twin.jikos.cz>
 <20150922133307.GA2369@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150922133307.GA2369@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 04:33:07PM +0300, Alexandru Moise wrote:
> > I think it's better to do it the other way around, ie. let all the
> > equivalents of 'num_items' be an int. We know that this is a small
> > number, using u64 for that is an overkill. As the number is always
> > positive, please make it 'unsigned'.
> 
> So you'd want it to be "unsigned int" or "u32"?

'unsigned int' please
