Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbcDFTsD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Apr 2016 15:48:03 -0400
Date: Wed, 6 Apr 2016 12:48:00 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Filipe Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: handle non-fatal errors in btrfs_qgroup_inherit()
Message-ID: <20160406194800.GE2187@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20160331005748.GI15881@wotan.suse.de>
 <CAL3q7H6vpRsun_jfhBTCaanb3Hv8DRCR2C5+3Qm4EesL9WkbRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6vpRsun_jfhBTCaanb3Hv8DRCR2C5+3Qm4EesL9WkbRw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 06, 2016 at 10:22:57AM +0100, Filipe Manana wrote:
> Mark, did you forgot to submit a patch with the test case for fstests,
> or is there any other reason why you didn't do it?

No, I was just waiting to see how my fix did in review. I'll be shooting
that test over later today.
	--Mark

--
Mark Fasheh
