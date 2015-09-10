Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56454 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbbIJXuc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 19:50:32 -0400
Date: Thu, 10 Sep 2015 16:50:30 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH RFC 00/14] Accurate qgroup reserve framework
Message-ID: <20150910235030.GT1145@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150910210104.GS1145@wotan.suse.de>
 <CAL3q7H7SgKs=WYumRJ=5eEL7_4+NJX5FhtRyRPS4kd-4vAayAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H7SgKs=WYumRJ=5eEL7_4+NJX5FhtRyRPS4kd-4vAayAg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 10, 2015 at 10:33:02PM +0100, Filipe David Manana wrote:
> On Thu, Sep 10, 2015 at 10:01 PM, Mark Fasheh <mfasheh@suse.de> wrote:
> > Hi Qu,
> >
> > On Tue, Sep 08, 2015 at 04:56:52PM +0800, Qu Wenruo wrote:
> >> [[BUG]]
> >> One of the most common case to trigger the bug is the following method:
> >> 1) Enable quota
> >> 2) Limit excl of qgroup 5 to 16M
> >> 3) Write [0,2M) of a file inside subvol 5 10 times without sync
> >>
> >> EQUOT will be triggered at about the 8th write.
> >
> > Does this happen on all kernels with qgroups or is this related to your
> > recent rewrite?
> >
> >
> >> [[CAUSE]]
> >> The problem is caused by the fact that qgroup will reserve space even
> >> the data space is already reserved.
> >>
> >> In above reproducer, each time we buffered write [0,2M) qgroup will
> >> reserve 2M space, but in fact, at the 1st time, we have already reserved
> >> 2M and from then on, we don't need to reserved any data space as we are
> >> only writing [0,2M).
> >>
> >> Also, the reserved space will only be freed *ONCE* when its backref is
> >> run at commit_transaction() time.
> >>
> >> That's causing the reserved space leaking.
> >>
> >> [[FIX]]
> >> The fix is not a simple one, as currently btrfs_qgroup_reserve() follow
> >
> > Indeed, this is quite a large patch series and I see no testing details from
> > you. Can you please at the least provide a single reproducer in the form of
> > something that can be added to xfstests?
> 
> https://patchwork.kernel.org/patch/7047641/
> 
> Came way before this patchset :)

Ok, thanks. IMHO that sort of thing should be part of the topic e-mail so
potential reviewers don't have to go googling for a test case ;)
	--Mark

--
Mark Fasheh
