From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: avoid taking the chunk_mutex in do_chunk_alloc
Date: Wed, 13 Apr 2011 14:11:13 +0200
Message-ID: <20110413121112.GM31675@twin.jikos.cz>
References: <1302568224-4567-1-git-send-email-josef@redhat.com>
 <4DA3ABCF.4060405@cn.fujitsu.com>
 <20110412124239.GB26337@dhcp231-156.rdu.redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: liubo <liubo2009@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110412124239.GB26337@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 12, 2011 at 08:42:39AM -0400, Josef Bacik wrote:
> > hmm, the "goto" will lead to problems, cause in "out" clause there is a mutex_unlock(), which
> > we do not have a mutex_lock yet.
> >
> 
> Hrm I wonder why xfstests didn't trip over that, thats what I get for patching
> while watching the kid.  Thanks,

a 'dad lock' :)

dave
