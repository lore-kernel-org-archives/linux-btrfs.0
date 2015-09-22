Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758000AbbIVNZd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 09:25:33 -0400
Date: Tue, 22 Sep 2015 15:24:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: memset cur_trans->delayed_refs to zero
Message-ID: <20150922132437.GE12815@suse.cz>
Reply-To: dsterba@suse.cz
References: <20150907142437.GA21090@gmail.com>
 <20150922130454.GB12815@twin.jikos.cz>
 <20150922131936.GA1757@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150922131936.GA1757@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 04:19:36PM +0300, Alexandru Moise wrote:
> Alright, do you want me to resend it with the different subject tag
> or shall I just keep that in mind for future patches?

No need to resend.
