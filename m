Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:52599 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbcFBKD4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 06:03:56 -0400
Date: Thu, 2 Jun 2016 13:03:51 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Scott Talbert <scott.talbert@hgst.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Device replace issues and disabling it until they are solved
Message-ID: <20160602100321.GA20887@jeknote.loshitsa1.net>
References: <CAL3q7H6R=Sii-Qn3G7ZL5d4vT33jj-MZOF92fH7T-QHjHSNtow@mail.gmail.com>
 <CAL3q7H71v-U+hAKyscCd4ShckoKapFEEQn=3xS1d2M4u9KAEZQ@mail.gmail.com>
 <alpine.DEB.2.10.1605261506540.25778@dispatch>
 <CAL3q7H67b3JNMogY5DS4X3JTLQEugB4E48kjLx6fE69VwXGpDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H67b3JNMogY5DS4X3JTLQEugB4E48kjLx6fE69VwXGpDQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 27, 2016 at 10:43:47AM +0100, Filipe Manana wrote:
> > Hi Filipe,
> 
> Hi Scott,
> 
> >
> > Does your recent patch set (from May 20) address all of these issues?
> 
> Yes.

Tested, RAID5/6 still produces a plenty of 'failed to rebuild valid
logical NNNNNN" messages after two consecutive device replaces. So,
replace is still not usable for RAID5/6. And it is very slow in
comparison with 'device add && balance device remove missing' sequence
(4x slower).

-- 
Yauhen Kharuzhy
