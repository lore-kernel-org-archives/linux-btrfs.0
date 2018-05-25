Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35558 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S971829AbeEYAHX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 20:07:23 -0400
Date: Fri, 25 May 2018 08:07:08 +0800
From: Ming Lei <ming.lei@redhat.com>
To: dsterba@suse.cz, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V5 10/33] btrfs: use segment_last_page to get bio's last
 page
Message-ID: <20180525000707.GA9503@ming.t460p>
References: <20180524090139.2150-1-ming.lei@redhat.com>
 <20180524090139.2150-11-ming.lei@redhat.com>
 <20180524214441.GL6649@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180524214441.GL6649@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 24, 2018 at 11:44:41PM +0200, David Sterba wrote:
> On Thu, May 24, 2018 at 05:01:15PM +0800, Ming Lei wrote:
> > Preparing for supporting multipage bvec.
> 
> Could you please also CC the cover letter so we have a chance to learn
> what multipage bvec means or what are the changes between the
> iterations? I found it in the archives, but a copy to mailinglist would
> be good too. Thanks.

Sorry, that is my fault, will resend with Cc today.

Thanks,
Ming
